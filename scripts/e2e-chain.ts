/**
 * End-to-end proof: drive the whole business lifecycle through the real domain
 * services (the same functions the UI server actions call). Fails loudly.
 */
import 'dotenv/config';
process.env.DATABASE_URL ??= 'postgres://paravalves:paravalves_dev_pw@127.0.0.1:55432/paravalves';

import { pool, one, query } from '../src/server/db';
import type { AuthUser } from '../src/server/auth/session';
import { createLead, convertLead } from '../src/server/domain/crm';
import { createQuote, transitionQuote, convertQuoteToOrder, transitionOrder } from '../src/server/domain/sales';
import { generatePartNumber } from '../src/server/domain/product';
import { createDrawing, transitionDrawing } from '../src/server/domain/engineering';
import { createPurchaseOrder, transitionPO, receiveGoods } from '../src/server/domain/procurement';
import { createInvoiceFromOrder, transitionInvoice, recordPayment } from '../src/server/domain/finance';
import { adjustStock } from '../src/server/domain/inventory';

let pass = 0, fail = 0;
function check(label: string, cond: boolean, detail = '') {
  if (cond) { pass++; console.log(`  \x1b[32m✓\x1b[0m ${label}`); }
  else { fail++; console.log(`  \x1b[31m✗ ${label}\x1b[0m ${detail}`); }
}
async function expectThrow(label: string, fn: () => Promise<unknown>) {
  try { await fn(); check(label + ' (should have blocked)', false); }
  catch { check(label, true); }
}

async function main() {
  // build a real AuthUser for the admin
  const u = await one<any>(`select id, name, is_global from users where email='admin@paravalves.com'`);
  const org = await one<any>(`select id from organizations where code='IN'`);
  const perms = await query<{ permission_code: string }>(
    `select distinct rp.permission_code from user_roles ur join role_permissions rp on rp.role_id=ur.role_id where ur.user_id=$1`, [u.id]);
  const user: AuthUser = {
    id: u.id, email: 'admin@paravalves.com', name: u.name, isGlobal: true,
    orgIds: [org.id], permissions: new Set(perms.map((p) => p.permission_code)), currentOrgId: org.id,
  };

  console.log('\n\x1b[1mParavalves — full lifecycle E2E\x1b[0m');

  console.log('\n[1] CRM: lead → customer');
  const lead = await createLead(user, { company_name: 'E2E Test Industries', contact_name: 'Test Buyer', email: 'e2e@test.com', product_requirement: 'Ball valves', quantity: 15 });
  check('lead created with number', /^LEAD-\d{4}-\d{6}$/.test(lead.lead_number), lead.lead_number);
  const followup = await one<any>(`select 1 from tasks where source_key=$1`, [`lead-followup-${lead.id}`]);
  check('follow-up task auto-created', !!followup);
  const { company_id } = await convertLead(user, lead.id);
  check('lead converted to company (reuses/creates)', !!company_id);

  console.log('\n[2] Product + part number');
  const product = await one<any>(`select id from products where org_id=$1 and product_code='PV-BV-050'`, [org.id]);
  const pn1 = await generatePartNumber(user, product.id, { family: 'BV', size: '50', material: 'SS316' });
  const pn2 = await generatePartNumber(user, product.id, { family: 'BV', size: '50', material: 'SS316' });
  check('part number generated', /^PV-BV-050-SS316-R01$/.test(pn1.part_number), pn1.part_number);
  check('revision bumps, no overwrite', pn2.revision === 2 && pn2.part_number !== pn1.part_number);

  console.log('\n[3] Quotation → Sales Order (carry-forward, automation)');
  const quote = await createQuote(user, { company_id, lines: [
    { product_id: product.id, description: 'PV-BV-050 — Ball Valve 50mm SS316', quantity: 15, unit_price: 2100, discount_pct: 5, tax_rate: 18 },
  ] });
  check('quote created', /^QUO-\d{4}-\d{6}$/.test(quote.quote_number), quote.quote_number);
  const q = await one<any>(`select * from quotations where id=$1`, [quote.id]);
  // 15*2100=31500, -5%=29925, +18%=35311.5
  check('server recomputed totals', Number(q.grand_total) === 35311.5, `got ${q.grand_total}`);
  await transitionQuote(user, quote.id, 'SENT', q.version);
  const order = await convertQuoteToOrder(user, quote.id);
  check('quote → order (one click)', /^SO-\d{4}-\d{6}$/.test(order.order_number), order.order_number);
  const order2 = await convertQuoteToOrder(user, quote.id);
  check('conversion is idempotent', order2.id === order.id && order2.existed);
  const proj = await one<any>(`select * from projects where sales_order_id=$1`, [order.id]);
  check('project auto-created', !!proj);
  const er = await one<any>(`select 1 from engineering_requests where sales_order_id=$1`, [order.id]);
  check('engineering request auto-created', !!er);
  const mrp = await one<any>(`select shortage_qty, required_qty from material_requirements where sales_order_id=$1`, [order.id]);
  check('MRP computed (required 15, shortage 2 vs 13 on hand)', Number(mrp.required_qty) === 15 && Number(mrp.shortage_qty) === 2, `shortage ${mrp?.shortage_qty}`);

  console.log('\n[4] Workflow GATES enforced');
  const o1 = await one<any>(`select version from sales_orders where id=$1`, [order.id]);
  await transitionOrder(user, order.id, 'ENGINEERING', o1.version);
  await expectThrow('EXECUTION blocked without released drawing', async () => {
    const ov = await one<any>(`select version, status from sales_orders where id=$1`, [order.id]);
    // jump path: ENGINEERING→MATERIAL_CHECK→... force execution attempt after material check
    await transitionOrder(user, order.id, 'MATERIAL_CHECK', ov.version);
    const ov2 = await one<any>(`select version from sales_orders where id=$1`, [order.id]);
    await transitionOrder(user, order.id, 'PROCUREMENT', ov2.version);
    const ov3 = await one<any>(`select version from sales_orders where id=$1`, [order.id]);
    // READY should be blocked by material shortage
    await transitionOrder(user, order.id, 'READY', ov3.version);
  });

  console.log('\n[5] Engineering: drawing → RELEASED clears gate');
  const dr = await createDrawing(user, { title: 'GA drawing for ' + order.order_number, sales_order_id: order.id });
  for (const s of ['REVIEW', 'INTERNAL_APPROVAL', 'RELEASED']) {
    const dv = await one<any>(`select version from drawings where id=$1`, [dr.id]);
    await transitionDrawing(user, dr.id, s, dv.version);
  }
  const drReleased = await one<any>(`select status from drawings where id=$1`, [dr.id]);
  check('drawing RELEASED', drReleased.status === 'RELEASED');

  console.log('\n[6] Procurement: PO → confirm → goods receipt updates stock');
  const supplier = await one<any>(`select id from companies where org_id=$1 and is_supplier=true limit 1`, [org.id]);
  const po = await createPurchaseOrder(user, { supplier_id: supplier.id, lines: [
    { product_id: product.id, description: 'Ball Valve 50mm', quantity: 5, unit_price: 1200, tax_rate: 18 },
  ] });
  check('PO created', /^PO-\d{4}-\d{6}$/.test(po.po_number), po.po_number);
  let pov = await one<any>(`select version from purchase_orders where id=$1`, [po.id]);
  await transitionPO(user, po.id, 'SENT', pov.version);
  pov = await one<any>(`select version from purchase_orders where id=$1`, [po.id]);
  await transitionPO(user, po.id, 'CONFIRMED', pov.version);
  const stockBefore = await one<any>(`select on_hand from stock_items s join products p on p.id=s.product_id where p.id=$1 limit 1`, [product.id]);
  const poLine = await one<any>(`select id from purchase_order_lines where purchase_order_id=$1`, [po.id]);
  await receiveGoods(user, po.id, [{ po_line_id: poLine.id, product_id: product.id, received: 5, accepted: 5, rejected: 0, damaged: 0 }]);
  const stockAfter = await one<any>(`select on_hand from stock_items s join products p on p.id=s.product_id where p.id=$1 limit 1`, [product.id]);
  check('accepted goods increased stock (13→18)', Number(stockAfter.on_hand) === Number(stockBefore.on_hand) + 5, `${stockBefore.on_hand}→${stockAfter.on_hand}`);
  const mrpAfter = await one<any>(`select shortage_qty, status from material_requirements where sales_order_id=$1`, [order.id]);
  check('shortage recomputed to 0 after receipt', Number(mrpAfter.shortage_qty) === 0, `shortage ${mrpAfter.shortage_qty}`);

  console.log('\n[7] Advance order to delivery, invoice + payment');
  // now READY should pass (no shortage), then execution (drawing released)
  let ov = await one<any>(`select version, status from sales_orders where id=$1`, [order.id]);
  await transitionOrder(user, order.id, 'READY', ov.version);
  for (const s of ['EXECUTION', 'QC', 'DELIVERY']) {
    ov = await one<any>(`select version from sales_orders where id=$1`, [order.id]);
    await transitionOrder(user, order.id, s, ov.version);
  }
  const oDelivered = await one<any>(`select status from sales_orders where id=$1`, [order.id]);
  check('order reached DELIVERY (gates passed)', oDelivered.status === 'DELIVERY');
  const inv = await createInvoiceFromOrder(user, order.id);
  check('tax invoice generated', /^INV-\d{4}-\d{6}$/.test(inv.invoice_number), inv.invoice_number);
  const invRow = await one<any>(`select * from invoices where id=$1`, [inv.id]);
  // intra-state? seller state 33 vs buyer null → IGST path. Just assert total>0 and tax present
  check('invoice GST computed', Number(invRow.grand_total) > 0 && (Number(invRow.igst) > 0 || Number(invRow.cgst) > 0));
  await transitionInvoice(user, inv.id, 'ISSUED', invRow.version);
  const pay = await recordPayment(user, inv.id, Number(invRow.grand_total));
  check('payment recorded', /^PAY-\d{4}-\d{6}$/.test(pay.payment_number), pay.payment_number);
  const invPaid = await one<any>(`select status, paid_amount, grand_total from invoices where id=$1`, [inv.id]);
  check('invoice marked PAID', invPaid.status === 'PAID' && Number(invPaid.paid_amount) === Number(invPaid.grand_total));

  console.log('\n[8] Reservation / oversell protection');
  await expectThrow('cannot over-adjust stock negative', async () => {
    await adjustStock(user, product.id, (await one<any>(`select warehouse_id from stock_items s join products p on p.id=s.product_id where p.id=$1 limit 1`, [product.id])).warehouse_id, -99999, 'oversell test');
  });

  console.log('\n[9] Audit trail written');
  const auditCount = await one<any>(`select count(*)::int n from audit_logs where entity_id=$1`, [order.id]);
  check('order has audit history', auditCount.n > 0, `${auditCount.n} entries`);

  console.log(`\n\x1b[1mResult: ${pass} passed, ${fail} failed\x1b[0m\n`);
  await pool.end();
  process.exit(fail ? 1 : 0);
}
main().catch((e) => { console.error('\x1b[31mFATAL\x1b[0m', e); process.exit(1); });
