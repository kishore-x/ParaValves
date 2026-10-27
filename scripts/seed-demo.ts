/**
 * Rich, realistic demo dataset built through the REAL domain services, so every
 * screen is populated and the whole platform is demonstrable. Idempotent-ish:
 * run after db:seed on a fresh DB.
 */
import 'dotenv/config';
process.env.DATABASE_URL ??= 'postgres://paravalves:paravalves_dev_pw@127.0.0.1:55432/paravalves';

import { pool, one, query } from '../src/server/db';
import type { AuthUser } from '../src/server/auth/session';
import { createLead, transitionLead, convertLead, findOrCreateCompanyByName } from '../src/server/domain/crm';
import { createQuote, transitionQuote, convertQuoteToOrder, transitionOrder } from '../src/server/domain/sales';
import { generatePartNumber } from '../src/server/domain/product';
import { createDrawing, transitionDrawing } from '../src/server/domain/engineering';
import { createPurchaseOrder, transitionPO, receiveGoods } from '../src/server/domain/procurement';
import { createInvoiceFromOrder, transitionInvoice, recordPayment } from '../src/server/domain/finance';

async function userFor(email: string): Promise<AuthUser> {
  const u = await one<any>(`select id, name, is_global from users where email=$1`, [email]);
  const org = await one<any>(`select id from organizations where code='IN'`);
  const perms = await query<{ permission_code: string }>(
    `select distinct rp.permission_code from user_roles ur join role_permissions rp on rp.role_id=ur.role_id where ur.user_id=$1`, [u.id]);
  return { id: u.id, email, name: u.name, isGlobal: u.is_global, orgIds: [org.id], permissions: new Set(perms.map((p) => p.permission_code)), currentOrgId: org.id };
}

async function ver(table: string, id: string) { return (await one<any>(`select version from ${table} where id=$1`, [id])).version; }

async function main() {
  const admin = await userFor('admin@paravalves.com');
  const sales = await userFor('sales@paravalves.com');
  const org = admin.currentOrgId;
  const prod = async (code: string) => (await one<any>(`select id from products where org_id=$1 and product_code=$2`, [org, code])).id;
  const bv = await prod('PV-BV-050'), gv = await prod('PV-GV-080'), seat = await prod('PV-SEAT-01');

  console.log('Seeding demo data…');

  // ── Leads across the pipeline ───────────────────────────────────────────
  const leadDefs = [
    { company_name: 'Deccan Petrochem Ltd', contact_name: 'Anita Rao', email: 'anita@deccanpetro.com', phone: '+91 90000 11111', product_requirement: 'Gate valves 80mm', quantity: 30, source: 'WEBSITE', priority: 'HIGH', expected_value: 177000, to: 'QUALIFIED' },
    { company_name: 'Coastal Power Ltd', contact_name: 'Vikram Shah', email: 'vikram@coastalpower.in', phone: '+91 90000 22222', product_requirement: 'Ball valves assorted', quantity: 50, source: 'REFERRAL', priority: 'NORMAL', expected_value: 105000, to: 'CONTACTED' },
    { company_name: 'Nagpur Steel Works', contact_name: 'Farah Khan', email: 'farah@nagpursteel.com', product_requirement: 'Knife gate valves', quantity: 12, source: 'PHONE', priority: 'NORMAL', expected_value: 68000, to: 'MEETING' },
    { company_name: 'Iberia Water S.L.', contact_name: 'Carlos Ruiz', email: 'carlos@iberiawater.es', country: 'ES', product_requirement: 'Penstocks for water plant', quantity: 8, source: 'WEBSITE', priority: 'HIGH', expected_value: 240000, to: 'QUOTATION' },
    { company_name: 'Metro Utilities', contact_name: 'Ramesh Iyer', email: 'ramesh@metroutil.in', product_requirement: 'Dampers', quantity: 5, source: 'MANUAL', priority: 'LOW', expected_value: 42000, to: 'LOST' },
  ];
  for (const d of leadDefs) {
    const { to, ...input } = d as any;
    const lead = await createLead(sales, input);
    // walk to target stage through valid transitions
    const path: Record<string, string[]> = {
      CONTACTED: ['CONTACTED'], QUALIFIED: ['CONTACTED', 'QUALIFIED'],
      MEETING: ['CONTACTED', 'QUALIFIED', 'MEETING'], QUOTATION: ['CONTACTED', 'QUALIFIED', 'QUOTATION'],
      LOST: ['LOST'],
    };
    for (const step of path[to] ?? []) await transitionLead(sales, lead.id, step, await ver('leads', lead.id));
  }
  console.log('  ✓ 5 leads across the pipeline');

  // ── An accepted quote → advanced order (delivered, invoiced, part-paid) ──
  const abcId = (await one<any>(`select id from companies where org_id=$1 and name='ABC Industries'`, [org])).id;
  await generatePartNumber(admin, bv, { family: 'BV', size: '50', material: 'SS316' });
  await generatePartNumber(admin, gv, { family: 'GV', size: '80', material: 'CF8M' });

  const q1 = await createQuote(sales, { company_id: abcId, lines: [
    { product_id: bv, description: 'PV-BV-050 — Ball Valve 50mm SS316', quantity: 15, unit_price: 2100, discount_pct: 5, tax_rate: 18 },
    { product_id: seat, description: 'PV-SEAT-01 — PTFE Seat Ring', quantity: 15, unit_price: 180, tax_rate: 18 },
  ] });
  await transitionQuote(sales, q1.id, 'SENT', await ver('quotations', q1.id));
  const o1 = await convertQuoteToOrder(admin, q1.id);
  // drawing release
  const dr1 = await createDrawing(admin, { title: `GA drawing — ${o1.order_number}`, sales_order_id: o1.id });
  for (const s of ['REVIEW', 'INTERNAL_APPROVAL', 'RELEASED']) await transitionDrawing(admin, dr1.id, s, await ver('drawings', dr1.id));
  // procurement to clear the shortage (order needs 15 BV, 13 on hand → short 2)
  const supplier = (await one<any>(`select id from companies where org_id=$1 and is_supplier=true limit 1`, [org])).id;
  const po1 = await createPurchaseOrder(admin, { supplier_id: supplier, lines: [{ product_id: bv, description: 'Ball Valve 50mm SS316', quantity: 10, unit_price: 1200, tax_rate: 18 }] });
  await transitionPO(admin, po1.id, 'SENT', await ver('purchase_orders', po1.id));
  await transitionPO(admin, po1.id, 'CONFIRMED', await ver('purchase_orders', po1.id));
  const poLine1 = (await one<any>(`select id from purchase_order_lines where purchase_order_id=$1`, [po1.id])).id;
  await receiveGoods(admin, po1.id, [{ po_line_id: poLine1, product_id: bv, received: 10, accepted: 10, rejected: 0, damaged: 0 }]);
  // advance order to delivery
  await transitionOrder(admin, o1.id, 'ENGINEERING', await ver('sales_orders', o1.id));
  await transitionOrder(admin, o1.id, 'MATERIAL_CHECK', await ver('sales_orders', o1.id));
  await transitionOrder(admin, o1.id, 'PROCUREMENT', await ver('sales_orders', o1.id));
  await transitionOrder(admin, o1.id, 'READY', await ver('sales_orders', o1.id));
  await transitionOrder(admin, o1.id, 'EXECUTION', await ver('sales_orders', o1.id));
  await transitionOrder(admin, o1.id, 'QC', await ver('sales_orders', o1.id));
  await transitionOrder(admin, o1.id, 'DELIVERY', await ver('sales_orders', o1.id));
  const inv1 = await createInvoiceFromOrder(admin, o1.id);
  await transitionInvoice(admin, inv1.id, 'ISSUED', await ver('invoices', inv1.id));
  const inv1row = await one<any>(`select grand_total from invoices where id=$1`, [inv1.id]);
  await recordPayment(admin, inv1.id, Math.round(Number(inv1row.grand_total) * 0.5), 'BANK_TRANSFER', 'NEFT-DEMO-001'); // partial
  console.log(`  ✓ Advanced order ${o1.order_number} (delivered, invoiced, 50% paid)`);

  // ── A second order still mid-flow WITH an open shortage (shows MRP/attention) ──
  const q2 = await createQuote(sales, { company_id: abcId, lines: [
    { product_id: gv, description: 'PV-GV-080 — Gate Valve 80mm CF8M', quantity: 20, unit_price: 5900, discount_pct: 8, tax_rate: 18 },
  ] });
  await transitionQuote(sales, q2.id, 'SENT', await ver('quotations', q2.id));
  const o2 = await convertQuoteToOrder(admin, q2.id); // GV has 0 stock → shortage 20
  await transitionOrder(admin, o2.id, 'ENGINEERING', await ver('sales_orders', o2.id));
  const dr2 = await createDrawing(admin, { title: `GA drawing — ${o2.order_number}`, sales_order_id: o2.id });
  await transitionDrawing(admin, dr2.id, 'REVIEW', await ver('drawings', dr2.id)); // pending approval → attention
  console.log(`  ✓ Mid-flow order ${o2.order_number} (open shortage + drawing pending approval)`);

  // ── A draft quote for a converted lead ──────────────────────────────────
  const deccan = await findOrCreateCompanyByName(org, 'Deccan Petrochem Ltd', sales.id);
  await createQuote(sales, { company_id: deccan, lines: [
    { product_id: gv, description: 'PV-GV-080 — Gate Valve 80mm CF8M', quantity: 30, unit_price: 5900, tax_rate: 18 },
  ] });
  console.log('  ✓ Draft quote for Deccan Petrochem');

  const counts = await one<any>(`select
    (select count(*) from leads where org_id=$1) leads,
    (select count(*) from companies where org_id=$1) companies,
    (select count(*) from quotations where org_id=$1) quotes,
    (select count(*) from sales_orders where org_id=$1) orders,
    (select count(*) from invoices where org_id=$1) invoices,
    (select count(*) from tasks where org_id=$1) tasks,
    (select count(*) from material_requirements where org_id=$1 and shortage_qty>0) shortages`, [org]);
  console.log('\nDemo dataset ready:', counts);
  await pool.end();
}
main().catch((e) => { console.error(e); process.exit(1); });
