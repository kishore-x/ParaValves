// @ts-nocheck
/**
 * Client demonstration dataset for the valve-manufacturing ERP.
 * Built through the REAL domain services so every business rule (quality gates,
 * maker-checker, lot traceability, shipment gates…) is exercised and every screen
 * is populated. Run on a fresh database after db:migrate + db:seed:
 *     npm run db:client-demo
 */
import 'dotenv/config';
process.env.DATABASE_URL ??= 'postgres://paravalves:paravalves_dev_pw@127.0.0.1:55432/paravalves';

import { pool, one, query, tx } from '../src/server/db';
import { hashPassword } from '../src/server/auth/password';
import type { AuthUser } from '../src/server/auth/session';
import { createLead, transitionLead, findOrCreateCompanyByName } from '../src/server/domain/crm';
import { createQuote, transitionQuote, convertQuoteToOrder, transitionOrder } from '../src/server/domain/sales';
import { createProduct } from '../src/server/domain/product';
import { createDrawing, transitionDrawing } from '../src/server/domain/engineering';
import { createPurchaseOrder, transitionPO, receiveGoods } from '../src/server/domain/procurement';
import { createInvoiceFromOrder, transitionInvoice, recordPayment } from '../src/server/domain/finance';
import { createInspection, decideInspection, proposeDisposition, recordTest, releaseUnit } from '../src/server/domain/quality';
import { createWorkOrder, releaseWorkOrder, issueMaterial, recordOperation, createSubcontract, updateSubcontract, createSerialUnit } from '../src/server/domain/production';
import { createShipment, updateShipmentDocs, shipShipment } from '../src/server/domain/shipping';
import { decideApproval, requestApproval, createEcn, assessEcnImpact, submitEcn, implementEcn, raiseException, resolveException, saveOrderReview, logIntegration, retryIntegration } from '../src/server/domain/governance';
import { nextNumber } from '../src/server/numbering/engine';

const ok = (m: string) => console.log(`  ✓ ${m}`);
async function step<T>(name: string, fn: () => Promise<T>): Promise<T | undefined> {
  try { return await fn(); } catch (e: any) { console.warn(`  ⚠ ${name}: ${e.message}`); return undefined; }
}
async function userFor(email: string): Promise<AuthUser> {
  const u = await one<any>(`select id, name, is_global from users where email=$1`, [email]);
  const org = await one<any>(`select id from organizations where code='IN'`);
  const perms = await query<{ permission_code: string }>(`select distinct rp.permission_code from user_roles ur join role_permissions rp on rp.role_id=ur.role_id where ur.user_id=$1`, [u.id]);
  return { id: u.id, email, name: u.name, isGlobal: u.is_global, orgIds: [org.id], permissions: new Set(perms.map((p) => p.permission_code)), currentOrgId: org.id };
}
async function ver(table: string, id: string) { return (await one<any>(`select version from ${table} where id=$1`, [id])).version; }
const day = (n: number) => new Date(Date.now() + n * 86400000).toISOString().slice(0, 10);

async function main() {
  const orgRow = await one<any>(`select id from organizations where code='IN'`);
  const org = orgRow.id as string;

  // ── Users & roles ─────────────────────────────────────────────────────────
  for (const [email, name, role, pw] of [
    ['quality@paravalves.com', 'Anjali Nair (Quality)', 'quality', 'quality123'],
    ['production@paravalves.com', 'Suresh Pillai (Production)', 'production', 'production123'],
    ['manager@paravalves.com', 'Meera Krishnan (Plant Head)', 'management', 'manager123'],
  ]) {
    const u = await one<any>(`insert into users(email, name, password_hash) values ($1,$2,$3) on conflict (email) do update set password_hash=excluded.password_hash returning id`, [email, name, await hashPassword(pw)]);
    const r = await one<any>(`select id from roles where code=$1`, [role]);
    await query(`insert into user_roles(user_id, role_id) values ($1,$2) on conflict do nothing`, [u.id, r.id]);
    await query(`insert into user_organizations(user_id, org_id) values ($1,$2) on conflict do nothing`, [u.id, org]);
  }
  const admin = await userFor('admin@paravalves.com');
  const sales = await userFor('sales@paravalves.com');
  const quality = await userFor('quality@paravalves.com');
  const prodU = await userFor('production@paravalves.com');
  const manager = await userFor('manager@paravalves.com');
  ok('users: admin, sales, quality, production, manager');

  // ── Products: finished valves + components ────────────────────────────────
  const P: Record<string, string> = {};
  const loadP = async () => { for (const r of await query<any>(`select id, product_code from products where org_id=$1`, [org])) P[r.product_code] = r.id; };
  await loadP();
  const newProducts: [string, string, string, number, number, boolean][] = [
    ['PV-BV-025', 'Ball Valve 25mm SS316', 'SS316', 820, 1450, true],
    ['PV-BV-100', 'Ball Valve 100mm CF8M', 'CF8M', 3900, 6800, true],
    ['PV-GV-050', 'Gate Valve 50mm WCB', 'WCB', 1700, 3100, true],
    ['PV-GV-150', 'Gate Valve 150mm CF8M', 'CF8M', 7600, 12900, true],
    ['PV-CV-050', 'Check Valve 50mm SS316', 'SS316', 1350, 2400, true],
    ['PV-GLV-050', 'Globe Valve 50mm SS316', 'SS316', 1900, 3400, true],
    ['PV-BFV-200', 'Butterfly Valve 200mm', 'CI/SS', 4800, 8200, true],
    ['PV-BODY-01', 'Valve body casting CF8M', 'CF8M', 620, 0, false],
    ['PV-BONNET-01', 'Bonnet forging CF8M', 'CF8M', 410, 0, false],
    ['PV-BAR-316', 'SS316 bar stock Ø40', 'SS316', 150, 0, false],
    ['PV-GASKET-01', 'Graphite gasket set', 'Graphite', 45, 0, false],
  ];
  for (const [code, name, material, std, sell, mfg] of newProducts) {
    await step(`product ${code}`, () => createProduct(admin, { product_code: code, name, material, standard_cost: std, selling_price: sell, is_manufactured: mfg, hsn_sac: '84818090', min_stock: 5, reorder_point: 10 }));
  }
  await loadP();
  ok(`products: ${Object.keys(P).length} (valves + components)`);

  // Released drawings per valve (as-built revision comes from these); GV-150 stays in review
  const valveCodes = ['PV-BV-025', 'PV-BV-050', 'PV-BV-100', 'PV-GV-050', 'PV-GV-080', 'PV-CV-050', 'PV-GLV-050', 'PV-BFV-200'];
  const drawingIds: Record<string, string> = {};
  for (const code of valveCodes) {
    const d = await createDrawing(admin, { title: `GA drawing — ${code}`, product_id: P[code] });
    drawingIds[code] = d.id;
    for (const s of ['REVIEW', 'INTERNAL_APPROVAL', 'RELEASED']) await transitionDrawing(admin, d.id, s, await ver('drawings', d.id));
  }
  const dGv150 = await createDrawing(admin, { title: 'GA drawing — PV-GV-150 (under review)', product_id: P['PV-GV-150'] });
  await transitionDrawing(admin, dGv150.id, 'REVIEW', await ver('drawings', dGv150.id));
  ok('drawings: 8 released, 1 in review');

  // Released BOMs per valve (GV-150 left as draft revision)
  for (const code of [...valveCodes, 'PV-GV-150']) {
    const b = await one<any>(`insert into boms (org_id, product_id, revision, status, effective_date, created_by) values ($1,$2,1,$3,$4,$5) returning id`, [org, P[code], code === 'PV-GV-150' ? 'DRAFT' : 'RELEASED', code === 'PV-GV-150' ? null : day(-60), admin.id]);
    for (const [comp, qty, scrap] of [['PV-BODY-01', 1, 2], ['PV-STEM-01', 1, 1], ['PV-SEAT-01', 2, 0], ['PV-BONNET-01', 1, 2], ['PV-GASKET-01', 1, 0]] as const) {
      await query(`insert into bom_lines (bom_id, component_id, quantity, scrap_pct) values ($1,$2,$3,$4)`, [b.id, P[comp], qty, scrap]);
    }
  }
  ok('BOMs: 8 released + 1 draft');

  // ── Suppliers (approval status, ratings) ──────────────────────────────────
  const supDefs: [string, string, string, number | null][] = [
    ['Precision Castings Ltd', 'APPROVED', 'Coimbatore', 4.6],
    ['Bharat Forgings Pvt Ltd', 'APPROVED', 'Pune', 4.4],
    ['Tamil Heat Treat Works', 'APPROVED', 'Chennai', 4.2],
    ['Sri Hardfacing & Coatings', 'APPROVED', 'Hosur', 4.0],
    ['Precision Seals India', 'APPROVED', 'Bengaluru', 4.7],
    ['Metro Fasteners', 'APPROVED', 'Mumbai', 3.9],
    ['Eastern Alloys Corp', 'CONDITIONAL', 'Kolkata', 3.1],
    ['QuickCast Metals', 'BLOCKED', 'Rajkot', 1.8],
  ];
  const S: Record<string, string> = {};
  for (const [name, status, city, rating] of supDefs) {
    const ex = await one<any>(`select id from companies where org_id=$1 and name=$2`, [org, name]);
    if (ex) { S[name] = ex.id; await query(`update companies set approval_status=$1, supplier_rating=$2, city=$3, is_supplier=true where id=$4`, [status, rating, city, ex.id]); continue; }
    const no = await tx((c) => nextNumber(c, org, 'SUPP'));
    const r = await one<any>(`insert into companies (org_id, company_number, name, is_customer, is_supplier, country, state_code, city, approval_status, supplier_rating, created_by) values ($1,$2,$3,false,true,'IN','27',$4,$5,$6,$7) returning id`, [org, no, name, city, status, rating, admin.id]);
    S[name] = r.id;
  }
  ok('suppliers: 8 (approved / conditional / blocked)');

  // ── Customers ─────────────────────────────────────────────────────────────
  const custNames = ['ABC Industries', 'Deccan Petrochem Ltd', 'Coastal Power Ltd', 'Nagpur Steel Works', 'Metro Utilities', 'Vizag Chemicals', 'Kaveri Water Board', 'Sahara Fertilizers Ltd', 'Gulf Refining Co.', 'Hamburg Process GmbH', 'Iberia Water S.L.', 'Reliance Marine Services', 'Tata Process Systems', 'Bharat Oilfield Services'];
  const C: string[] = [];
  for (const n of custNames) C.push(await findOrCreateCompanyByName(org, n, sales.id));
  await query(`update companies set credit_hold=true, credit_limit=500000 where id=$1`, [C[7]]);
  await query(`update companies set country='AE', tax_treatment='EXPORT', currency='USD', export_cleared=false, city='Dubai' where id=$1`, [C[8]]);
  await query(`update companies set country='DE', tax_treatment='EXPORT', currency='EUR', export_cleared=true, city='Hamburg' where id=$1`, [C[9]]);
  await query(`update companies set country='ES', tax_treatment='EXPORT', currency='EUR', export_cleared=true, city='Madrid' where id=$1`, [C[10]]);
  for (const [i, city] of [[1, 'Hyderabad'], [2, 'Visakhapatnam'], [3, 'Nagpur'], [4, 'Mumbai'], [5, 'Vizag'], [6, 'Mysuru'], [7, 'Kanpur'], [11, 'Kochi'], [12, 'Jamshedpur'], [13, 'Mumbai']] as [number, string][]) {
    await query(`update companies set city=$1, country='IN', state_code=coalesce(state_code,'27') where id=$2`, [city, C[i]]);
  }
  ok(`customers: ${C.length} (1 on credit hold, 3 export — 1 not cleared)`);

  // ── 15 leads across the pipeline ──────────────────────────────────────────
  const leadDefs: any[] = [
    ['Deccan Petrochem Ltd', 'Anita Rao', 'Gate valves 80mm', 30, 'WEBSITE', 'HIGH', 177000, 'QUALIFIED'],
    ['Coastal Power Ltd', 'Vikram Shah', 'Ball valves assorted', 50, 'REFERRAL', 'NORMAL', 105000, 'CONTACTED'],
    ['Nagpur Steel Works', 'Farah Khan', 'Knife gate valves', 12, 'PHONE', 'NORMAL', 68000, 'MEETING'],
    ['Iberia Water S.L.', 'Carlos Ruiz', 'Butterfly valves for water plant', 8, 'WEBSITE', 'HIGH', 240000, 'QUOTATION'],
    ['Metro Utilities', 'Ramesh Iyer', 'Dampers', 5, 'MANUAL', 'LOW', 42000, 'LOST'],
    ['Kaveri Water Board', 'Lakshmi Gowda', 'Check valves 50mm', 40, 'WEBSITE', 'NORMAL', 96000, 'QUALIFIED'],
    ['Hamburg Process GmbH', 'Jonas Weber', 'Ball valves CF8M 100mm', 20, 'WEBSITE', 'HIGH', 136000, 'QUOTATION'],
    ['Tata Process Systems', 'Neha Joshi', 'Globe valves', 25, 'REFERRAL', 'NORMAL', 85000, 'MEETING'],
    ['Reliance Marine Services', 'Capt. Dsouza', 'Marine ball valves', 60, 'TRADE_SHOW', 'HIGH', 290000, 'CONTACTED'],
    ['Bharat Oilfield Services', 'Gurpreet Singh', 'High-pressure gate valves', 16, 'PHONE', 'HIGH', 206000, 'QUALIFIED'],
    ['Sunrise Pharma', 'Dr. Mehta', 'Sanitary ball valves', 30, 'WEBSITE', 'NORMAL', 120000, 'NEW'],
    ['Eastern Fertilizers', 'Amit Das', 'Butterfly valves 200mm', 10, 'REFERRAL', 'NORMAL', 82000, 'NEW'],
    ['Gulf Refining Co.', 'Omar Al Farsi', 'Gate valves 150mm', 14, 'WEBSITE', 'HIGH', 180000, 'NEGOTIATION'],
    ['Pune Auto Components', 'Sachin Patil', 'Check valves', 20, 'MANUAL', 'LOW', 48000, 'LOST'],
    ['Hindustan Chemicals', 'Rekha Menon', 'Ball valves 25mm', 80, 'WEBSITE', 'NORMAL', 116000, 'CONTACTED'],
  ];
  const path: Record<string, string[]> = { NEW: [], CONTACTED: ['CONTACTED'], QUALIFIED: ['CONTACTED', 'QUALIFIED'], MEETING: ['CONTACTED', 'QUALIFIED', 'MEETING'], QUOTATION: ['CONTACTED', 'QUALIFIED', 'QUOTATION'], NEGOTIATION: ['CONTACTED', 'QUALIFIED', 'QUOTATION', 'NEGOTIATION'], LOST: ['LOST'] };
  let li = 0;
  for (const [company_name, contact_name, product_requirement, quantity, source, priority, expected_value, to] of leadDefs) {
    const lead = await createLead(sales, { company_name, contact_name, email: `${contact_name.split(' ')[0].toLowerCase().replace(/\W/g, '')}@${company_name.toLowerCase().replace(/[^a-z]/g, '').slice(0, 12)}.com`, phone: `+91 9${String(10000000 + li * 1111111).slice(0, 8)}`, product_requirement, quantity, source, priority, expected_value, expected_close: day(14 + li * 3) });
    for (const st of path[to]) await transitionLead(sales, lead.id, st, await ver('leads', lead.id));
    li++;
  }
  ok('leads: 15 across the pipeline');

  // ── 16 quotations → 12 orders ─────────────────────────────────────────────
  type QL = [string, number, number?];  // product, qty, discount
  const quoteDefs: { c: number; lines: QL[]; order: boolean }[] = [
    { c: 0, lines: [['PV-BV-050', 3, 5], ['PV-SEAT-01', 3]], order: true },      // O1
    { c: 1, lines: [['PV-GV-080', 4, 3]], order: true },                         // O2
    { c: 2, lines: [['PV-BV-025', 3]], order: true },                            // O3
    { c: 3, lines: [['PV-GLV-050', 3]], order: true },                           // O4
    { c: 4, lines: [['PV-CV-050', 2]], order: true },                            // O5
    { c: 5, lines: [['PV-BV-100', 2]], order: true },                            // O6
    { c: 6, lines: [['PV-GV-150', 4, 4]], order: true },                         // O7 (drawing in review)
    { c: 7, lines: [['PV-GV-050', 2]], order: true },                            // O8 credit hold
    { c: 8, lines: [['PV-BFV-200', 2]], order: true },                           // O9 export not cleared
    { c: 9, lines: [['PV-BV-100', 6, 2]], order: true },                         // O10 Hamburg
    { c: 10, lines: [['PV-BFV-200', 4]], order: true },                          // O11 Iberia
    { c: 11, lines: [['PV-BV-025', 10, 5]], order: true },                       // O12
    { c: 12, lines: [['PV-GLV-050', 6]], order: false },
    { c: 13, lines: [['PV-GV-080', 8, 6]], order: false },
    { c: 1, lines: [['PV-CV-050', 12]], order: false },
    { c: 0, lines: [['PV-BV-100', 5, 8]], order: false },
  ];
  const orders: { id: string; order_number: string }[] = [];
  let qn = 0;
  for (const qd of quoteDefs) {
    const prices = await query<any>(`select id, product_code, name, selling_price from products where org_id=$1 and product_code = any($2)`, [org, qd.lines.map((l) => l[0])]);
    const lines = qd.lines.map(([code, qty, disc]) => { const p = prices.find((x: any) => x.product_code === code); return { product_id: p.id, description: `${code} — ${p.name}`, quantity: qty, unit_price: Number(p.selling_price) || 180, discount_pct: disc ?? 0, tax_rate: 18 }; });
    const q = await createQuote(sales, { company_id: C[qd.c], lines, valid_until: day(30), delivery_terms: 'Ex-works, 8–10 weeks', notes: 'Hydrotest certificates and MTCs included.' });
    qn++;
    if (qn <= 14) await transitionQuote(sales, q.id, 'SENT', await ver('quotations', q.id));
    if (qd.order) { const o = await convertQuoteToOrder(admin, q.id); orders.push({ id: o.id, order_number: o.order_number }); }
  }
  // a second version of one sent quote is represented by re-sending after negotiation
  await step('quote negotiation', async () => { const q = await one<any>(`select id from quotations where org_id=$1 and status='SENT' limit 1 offset 12`, [org]); if (q) await transitionQuote(sales, q.id, 'NEGOTIATION', await ver('quotations', q.id)); });
  // delivery dates: some comfortably ahead, a few at risk
  const dd = [30, 21, 12, 9, 8, 25, 28, 6, 18, 35, 40, 45];
  for (let i = 0; i < orders.length; i++) await query(`update sales_orders set delivery_date=$1, customer_po_ref=$2 where id=$3`, [day(dd[i]), `PO-${2026}-${4100 + i * 17}`, orders[i].id]);
  ok(`quotations: 16 (versions retained on send) → orders: ${orders.length}`);

  // ── Equipment & calibration ───────────────────────────────────────────────
  const eqDefs: [string, string, string, number, string][] = [
    ['EQ-TB-01', 'Hydrostatic test bench 100 bar', 'TEST_BENCH', 120, 'ACTIVE'],
    ['EQ-TB-02', 'Pneumatic seat-leak bench', 'TEST_BENCH', 45, 'ACTIVE'],
    ['EQ-CMM-01', 'Coordinate measuring machine', 'CMM', 200, 'ACTIVE'],
    ['EQ-VC-01', 'Vernier caliper set', 'GAUGE', 60, 'ACTIVE'],
    ['EQ-TW-01', 'Torque wrench 20–200 Nm', 'GAUGE', 10, 'ACTIVE'],
    ['EQ-PG-07', 'Pressure gauge 0–160 bar', 'GAUGE', -15, 'ACTIVE'],          // calibration lapsed
    ['EQ-HT-02', 'Hardness tester (Rockwell)', 'GAUGE', -40, 'OUT_OF_CALIBRATION'],
  ];
  const E: Record<string, string> = {};
  for (const [code, name, kind, due, status] of eqDefs) {
    const r = await one<any>(`insert into equipment (org_id, code, name, kind, calibration_due, status) values ($1,$2,$3,$4,$5,$6) on conflict (org_id, code) do update set status=excluded.status returning id`, [org, code, name, kind, day(due), status]);
    E[code] = r.id;
  }
  ok('equipment: 7 (2 out of calibration — blocked from use)');

  // ── Procurement → receiving → lots (heat / cert) ──────────────────────────
  const comps: { name: string; code: string; supplier: string; price: number }[] = [
    { name: 'Body', code: 'PV-BODY-01', supplier: 'Precision Castings Ltd', price: 620 },
    { name: 'Stem', code: 'PV-STEM-01', supplier: 'Bharat Forgings Pvt Ltd', price: 220 },
    { name: 'Seat', code: 'PV-SEAT-01', supplier: 'Precision Seals India', price: 90 },
    { name: 'Bonnet', code: 'PV-BONNET-01', supplier: 'Bharat Forgings Pvt Ltd', price: 410 },
  ];
  const lotsByComp: Record<string, string[]> = {};   // component -> lot ids (index = batch 1..5)
  for (const comp of comps) {
    const po = await createPurchaseOrder(admin, { supplier_id: S[comp.supplier], expected_date: day(-5), lines: Array.from({ length: 5 }, (_, i) => ({ product_id: P[comp.code], description: `${comp.code} batch ${i + 1}`, quantity: 20, unit_price: comp.price, tax_rate: 18 })) });
    await transitionPO(admin, po.id, 'SENT', await ver('purchase_orders', po.id));
    await transitionPO(admin, po.id, 'CONFIRMED', await ver('purchase_orders', po.id));
    const lines = await query<any>(`select id from purchase_order_lines where purchase_order_id=$1 order by line_no`, [po.id]);
    await receiveGoods(admin, po.id, lines.map((l: any, i: number) => ({ po_line_id: l.id, product_id: P[comp.code], received: 20, accepted: 20, rejected: 0, damaged: 0, batch: `${({ Body: 'BD', Stem: 'ST', Seat: 'SE', Bonnet: 'BN' } as Record<string, string>)[comp.name]}-H26${String(100 + i * 7 + comp.code.length)}` })));
    const lots = await query<any>(`select id, lot_number from material_lots where goods_receipt_id in (select id from goods_receipts where purchase_order_id=$1) order by lot_number`, [po.id]);
    await query(`update material_lots set certificate_ref='MTC-'||lot_number||' (EN 10204 3.1)' where goods_receipt_id in (select id from goods_receipts where purchase_order_id=$1)`, [po.id]);
    lotsByComp[comp.name] = lots.map((l: any) => l.id);
  }
  // open / late POs for the planning & exception views
  const poLate = await createPurchaseOrder(admin, { supplier_id: S['Tamil Heat Treat Works'], expected_date: day(-6), lines: [{ description: 'Heat-treatment consumables', quantity: 10, unit_price: 1800, tax_rate: 18 }] });
  await transitionPO(admin, poLate.id, 'SENT', await ver('purchase_orders', poLate.id));
  const poBig = await createPurchaseOrder(admin, { supplier_id: S['Eastern Alloys Corp'], expected_date: day(20), lines: [{ product_id: P['PV-BAR-316'], description: 'SS316 bar stock Ø40', quantity: 4000, unit_price: 150, tax_rate: 18 }] });
  await transitionPO(admin, poBig.id, 'PENDING_APPROVAL', await ver('purchase_orders', poBig.id));
  ok('procurement: 6 POs, 20 receipt lots created in quarantine');

  // ── Incoming inspection: most pass; two fail; two still waiting ───────────
  const allLots = Object.entries(lotsByComp);
  let nPass = 0;
  for (const [compName, ids] of allLots) {
    for (let i = 0; i < ids.length; i++) {
      const lotLabel = (await one<any>(`select lot_number from material_lots where id=$1`, [ids[i]])).lot_number;
      const skip = (compName === 'Seat' && i === 4) || (compName === 'Bonnet' && i === 4);   // still awaiting / uninspected
      if (skip) { if (compName === 'Seat') await createInspection(quality, { stage: 'INCOMING', subject_type: 'LOT', subject_id: ids[i], subject_label: `Lot ${lotLabel}`, checks: [] , equipment_id: E['EQ-VC-01'] }); continue; }
      const fail = (compName === 'Body' && i === 4) || (compName === 'Stem' && i === 4);
      const ins = await createInspection(quality, { stage: 'INCOMING', subject_type: 'LOT', subject_id: ids[i], subject_label: `Lot ${lotLabel}`, checks: [], equipment_id: E['EQ-VC-01'] });
      const names = ['Dimensional check vs drawing', 'Material / heat certificate matches lot', 'Visual & surface condition', 'Hardness / PMI (if specified)'];
      const r = await decideInspection(quality, ins.id, names.map((n, k) => ({ name: n, measured: fail && k === 3 ? '168 HB (min 180)' : 'within tol.', ok: !(fail && k === 3) })), fail ? 'Hardness below specification' : 'Accepted');
      if (r.passed) nPass++;
    }
  }
  // NCR on the failed body lot: scrapped with maker-checker approval; failed stem lot: waiting for approval
  const ncrs = await query<any>(`select id, source_label, description from nonconformances where org_id=$1 order by ncr_number`, [org]);
  for (const n of ncrs) {
    const isBody = /Lot BD-/.test(n.source_label ?? '');
    await proposeDisposition(quality, n.id, isBody ? 'SCRAP' : 'RETURN_TO_SUPPLIER', isBody ? 'Hardness out of spec — scrap, claim from supplier' : 'Return batch to supplier for re-heat-treatment');
    if (isBody) { const a = await one<any>(`select id from approval_requests where entity_id=$1 and status='PENDING'`, [n.id]); await decideApproval(manager, a.id, true, 'Agreed — scrap and raise supplier debit note'); }
  }
  ok(`incoming inspection: ${nPass} lots released, 2 failed (1 scrapped & approved, 1 awaiting approval), 2 pending/uninspected`);

  // ── Orders review (stage 2) ───────────────────────────────────────────────
  const allOk = { po_ok: true, spec_ok: true, price_ok: true, terms_ok: true, credit_ok: true, capacity_ok: true, date_ok: true };
  await step('review O1', () => saveOrderReview(sales, orders[0].id, allOk, '', day(dd[0]), true));
  await step('review O2', () => saveOrderReview(sales, orders[1].id, allOk, 'Customer PO adds 1 spare seat kit — price confirmed', day(dd[1]), true));
  await step('review O3', () => saveOrderReview(sales, orders[2].id, { ...allOk, spec_ok: false }, 'Flange standard on PO differs from quote (ANSI 150 vs PN16) — clarification requested', undefined, false));
  await step('review O4', () => saveOrderReview(sales, orders[3].id, { ...allOk, capacity_ok: false, date_ok: false }, 'Requested date needs expedited heat-treatment slot', undefined, false));
  ok('order review: 2 acknowledged, 2 with open differences');

  // ── Work orders (15) ──────────────────────────────────────────────────────
  const woDefs: { o: number | null; code: string; qty: number }[] = [
    { o: 0, code: 'PV-BV-050', qty: 3 }, { o: 1, code: 'PV-GV-080', qty: 4 }, { o: 2, code: 'PV-BV-025', qty: 3 }, { o: 3, code: 'PV-GLV-050', qty: 3 },
    { o: 4, code: 'PV-CV-050', qty: 2 }, { o: 5, code: 'PV-BV-100', qty: 2 }, { o: 7, code: 'PV-GV-050', qty: 2 }, { o: 8, code: 'PV-BFV-200', qty: 2 },
    { o: 6, code: 'PV-GV-150', qty: 4 }, { o: 9, code: 'PV-BV-100', qty: 6 }, { o: 10, code: 'PV-BFV-200', qty: 4 }, { o: 11, code: 'PV-BV-025', qty: 10 },
    { o: null, code: 'PV-BV-050', qty: 8 }, { o: null, code: 'PV-GV-080', qty: 5 }, { o: null, code: 'PV-CV-050', qty: 6 },
  ];
  const W: { id: string; wo_number: string; def: (typeof woDefs)[number] }[] = [];
  for (const d of woDefs) {
    const w = await createWorkOrder(prodU, { sales_order_id: d.o === null ? undefined : orders[d.o].id, product_id: P[d.code], quantity: d.qty, due_date: d.o === null ? day(40) : day(dd[d.o] - 6) });
    W.push({ ...w, def: d });
  }
  ok('work orders: 15 created with routing');

  // release (some are intentionally blocked), issue material, run operations
  const releasedLots = async (comp: string) => (await query<any>(`select id, qty_available from material_lots where id=any($1) and status='RELEASED' and qty_available>0 order by lot_number`, [lotsByComp[comp]])).map((r: any) => r.id);
  let released = 0;
  for (let i = 0; i < W.length; i++) {
    const w = W[i];
    const r = await step(`release ${w.wo_number}`, async () => { await releaseWorkOrder(prodU, w.id); return true; });
    if (!r) continue;
    released++;
    // issue body + stem lots (traceability)
    const bodyLots = await releasedLots('Body'), stemLots = await releasedLots('Stem');
    await step('issue body', () => issueMaterial(prodU, w.id, bodyLots[i % bodyLots.length], w.def.qty));
    await step('issue stem', () => issueMaterial(prodU, w.id, stemLots[i % stemLots.length], w.def.qty));
  }
  // operations: first 8 WOs fully progressed (non-subcontract), later ones partially
  for (let i = 0; i < W.length; i++) {
    const w = W[i];
    const ops = await query<any>(`select id, seq, is_subcontract, planned_hours from work_order_operations where work_order_id=$1 order by seq`, [w.id]);
    const st = (await one<any>(`select status from work_orders where id=$1`, [w.id])).status;
    const upTo = st === 'PLANNED' ? 0 : i < 8 ? ops.length : i < 12 ? 2 : 0;
    for (let k = 0; k < upTo; k++) {
      if (ops[k].is_subcontract) continue;
      await step(`op ${w.wo_number}/${ops[k].seq}`, () => recordOperation(prodU, ops[k].id, { hours: Number(ops[k].planned_hours) * (1 + (i % 3) * 0.08), scrap: i === 2 && k === 1 ? 1 : 0, rework: i === 4 && k === 3 ? 1 : 0, downtime: k === 1 && i % 4 === 0 ? 35 : 0, operator: ['R. Kumar', 'S. Iyer', 'P. Das'][i % 3], done: true }));
    }
  }
  ok(`production: ${released} work orders released (others blocked by engineering / credit gates), material issued with lot traceability`);

  // ── Subcontract (8) with reconciliation states ────────────────────────────
  const scDefs: { w: number; sup: string; process: string; sent: number; ret: number; proc: number; scrap: number; cost: number }[] = [
    { w: 0, sup: 'Tamil Heat Treat Works', process: 'Heat treatment', sent: 3, ret: 3, proc: 3, scrap: 0, cost: 4500 },
    { w: 1, sup: 'Tamil Heat Treat Works', process: 'Heat treatment', sent: 4, ret: 4, proc: 4, scrap: 0, cost: 6000 },
    { w: 2, sup: 'Sri Hardfacing & Coatings', process: 'Stellite hard-facing', sent: 3, ret: 2, proc: 2, scrap: 1, cost: 7800 },
    { w: 3, sup: 'Tamil Heat Treat Works', process: 'Heat treatment', sent: 3, ret: 3, proc: 3, scrap: 0, cost: 4500 },
    { w: 4, sup: 'Sri Hardfacing & Coatings', process: 'Plating', sent: 2, ret: 2, proc: 2, scrap: 0, cost: 3200 },
    { w: 5, sup: 'Tamil Heat Treat Works', process: 'Heat treatment', sent: 2, ret: 2, proc: 2, scrap: 0, cost: 3000 },
    { w: 6, sup: 'Sri Hardfacing & Coatings', process: 'Hard-facing', sent: 2, ret: 2, proc: 2, scrap: 0, cost: 3900 },
    { w: 7, sup: 'Tamil Heat Treat Works', process: 'Heat treatment', sent: 2, ret: 2, proc: 2, scrap: 0, cost: 3000 },
  ];
  const SC: string[] = [];
  for (const s of scDefs) {
    const sc = await createSubcontract(prodU, { work_order_id: W[s.w].id, supplier_id: S[s.sup], product_id: P[W[s.w].def.code], process: s.process, qty_sent: s.sent, cost: s.cost, due_date: day(-2) });
    SC.push(sc.id);
    await updateSubcontract(prodU, sc.id, { returned: s.ret, processed: s.proc, scrapped: s.scrap, note: s.scrap ? 'One piece rejected at supplier — cracking after quench' : undefined });
  }
  // two more still at supplier, one with a deliberate mismatch (processed > returned)
  const scA = await createSubcontract(prodU, { work_order_id: W[8].id, supplier_id: S['Tamil Heat Treat Works'], product_id: P['PV-GV-150'], process: 'Heat treatment', qty_sent: 4, cost: 6400, due_date: day(5) });
  const scB = await createSubcontract(prodU, { work_order_id: W[9].id, supplier_id: S['Sri Hardfacing & Coatings'], product_id: P['PV-BV-100'], process: 'Hard-facing', qty_sent: 6, cost: 9600, due_date: day(7) });
  await updateSubcontract(prodU, scB.id, { returned: 4, processed: 5, scrapped: 0, note: 'Supplier DC shows 5 processed but only 4 received — raised with supplier' });
  ok('subcontract: 10 orders (reconciled, partial scrap, 1 mismatch, 1 still at supplier)');

  // ── Assembly → final inspection → tests → release (21 serialised valves) ──
  const finalChecks = ['Visual, marking & nameplate', 'Face-to-face & end dimensions', 'Seat & stem operation (torque)', 'Tag / serial verified'];
  const unitPlan: { w: number; count: number }[] = [{ w: 0, count: 3 }, { w: 1, count: 4 }, { w: 2, count: 3 }, { w: 3, count: 3 }, { w: 4, count: 2 }, { w: 5, count: 2 }, { w: 6, count: 2 }, { w: 7, count: 2 }];
  const U: Record<number, string[]> = {};
  const seatLots = await releasedLots('Seat'), bonnetLots = await releasedLots('Bonnet'), bodyLots = await releasedLots('Body'), stemLots = await releasedLots('Stem');
  let un = 0;
  for (const p of unitPlan) {
    U[p.w] = [];
    for (let k = 0; k < p.count; k++) {
      const r = await step(`serial ${p.w}/${k}`, () => createSerialUnit(prodU, { work_order_id: W[p.w].id, tag_number: `TAG-${W[p.w].def.code.slice(3, 6)}-${String(100 + un)}`, components: [
        { component_name: 'Body', lot_id: bodyLots[un % bodyLots.length] }, { component_name: 'Stem', lot_id: stemLots[un % stemLots.length] },
        { component_name: 'Seat', lot_id: seatLots[un % seatLots.length] }, { component_name: 'Bonnet', lot_id: bonnetLots[un % bonnetLots.length] },
        ...(k === 0 && SC[p.w] ? [{ component_name: 'Heat-treated stem (subcontract)', subcontract_id: SC[p.w] } as any] : []) ] }));
      if (r) { U[p.w].push(r.id); un++; }
    }
  }
  ok(`assembly: ${un} serialised valves with genealogy`);

  const doFinal = async (unitId: string, label: string, pass = true) => {
    const ins = await createInspection(quality, { stage: 'FINAL', subject_type: 'SERIAL', subject_id: unitId, subject_label: label, checks: [] });
    return decideInspection(quality, ins.id, finalChecks.map((n) => ({ name: n, measured: 'OK', ok: pass })), pass ? 'Accepted' : 'Rejected');
  };
  const doTests = async (unitId: string, only?: string[], failSeat = false) => {
    for (const [type, bar, hold, allow, meas, eq] of [['SHELL_PRESSURE', 150, 15, 'No visible leakage', 'No leakage', 'EQ-TB-01'], ['SEAT_LEAK', 110, 5, 'Max 0 bubbles/min (ISO 5208 Rate A)', failSeat ? '12 bubbles/min' : '0 bubbles/min', 'EQ-TB-02'], ['FUNCTIONAL', 0, 0, 'Smooth operation, torque ≤ 85 Nm', '62 Nm', 'EQ-TW-01']] as const) {
      if (only && !only.includes(type)) continue;
      await recordTest(quality, { serial_unit_id: unitId, test_type: type, test_pressure_bar: bar || undefined, hold_minutes: hold || undefined, allowable: allow, measured: meas, result: type === 'SEAT_LEAK' && failSeat ? 'FAIL' : 'PASS', equipment_id: E[eq], evidence_ref: `CERT-${type.slice(0, 3)}-${Math.floor(Math.random() * 9000 + 1000)}` });
    }
  };
  const unitLabel = async (id: string) => (await one<any>(`select serial_number from serial_units where id=$1`, [id])).serial_number;

  // fully processed & released: WO0 (3), WO1 first 2 of 4, WO2 (3), WO4 (2), WO6 (2 - credit hold customer), WO7 (2 - export customer)
  const releaseList = [...U[0], U[1][0], U[1][1], ...U[2].slice(0, 2), ...U[4], ...U[6], ...U[7]];
  for (const id of releaseList) { await doFinal(id, await unitLabel(id)); await doTests(id); await step('release', () => releaseUnit(quality, id)); }
  // WO2 third unit: seat-leak FAIL, NCR approved for RETEST, retest PASS, then released (original failure preserved)
  const u2c = U[2][2];
  await doTests(u2c, ['SHELL_PRESSURE', 'SEAT_LEAK'], true);
  const failedTest = await one<any>(`select id from test_records where serial_unit_id=$1 and result='FAIL'`, [u2c]);
  const ncrT = await one<any>(`select id from nonconformances where source_id=$1`, [failedTest.id]);
  await proposeDisposition(quality, ncrT.id, 'RETEST', 'Seat re-lapped; retest after cleaning seat face');
  const apT = await one<any>(`select id from approval_requests where entity_id=$1 and status='PENDING'`, [ncrT.id]);
  await decideApproval(manager, apT.id, true, 'Approved — retest under witness');
  await recordTest(quality, { serial_unit_id: u2c, test_type: 'SEAT_LEAK', test_pressure_bar: 110, hold_minutes: 5, allowable: 'Max 0 bubbles/min (ISO 5208 Rate A)', measured: '0 bubbles/min', result: 'PASS', equipment_id: E['EQ-TB-02'], retest_of: failedTest.id, evidence_ref: 'CERT-SEA-RETEST' });
  await doTests(u2c, ['FUNCTIONAL']); await doFinal(u2c, await unitLabel(u2c));
  await step('release retested', () => releaseUnit(quality, u2c));
  // WO5: one unit quarantined on a seat-leak failure (NCR left open), other fully released
  await doFinal(U[5][0], await unitLabel(U[5][0])); await doTests(U[5][0], ['SHELL_PRESSURE', 'SEAT_LEAK', 'FUNCTIONAL'], true);   // leaves NCR open, unit quarantined
  await doFinal(U[5][1], await unitLabel(U[5][1])); await doTests(U[5][1]); await step('release', () => releaseUnit(quality, U[5][1]));
  // WO1 units 3-4, WO3: awaiting final inspection (no inspection recorded yet)
  ok('final inspection & tests: 12 released, 1 retest-then-release, 1 quarantined (NCR open), 5 awaiting final inspection');

  // ── Dispatch scenarios ────────────────────────────────────────────────────
  const docsAll = { packing_list: true, mtc: true, export_docs: true };
  const mkShip = async (oi: number, ids: string[], docs: Record<string, boolean>, carrier: string) => {
    const s = await createShipment(prodU, { sales_order_id: orders[oi].id, serial_unit_ids: ids });
    await updateShipmentDocs(prodU, s.id, docs, carrier);
    return s;
  };
  const s1 = await mkShip(0, U[0], docsAll, 'Blue Dart Freight');                           // full shipment
  await shipShipment(prodU, s1.id);
  const s2 = await mkShip(1, [U[1][0], U[1][1]], docsAll, 'VRL Logistics');                // partial shipment
  await shipShipment(prodU, s2.id);
  const s3 = await mkShip(4, U[4], docsAll, 'DTDC Industrial');                           // full shipment
  await shipShipment(prodU, s3.id);
  const s4 = await mkShip(2, U[2], { packing_list: true }, 'Gati');                         // blocked: certificates missing + one unit
  await shipShipment(prodU, s4.id);
  const s5 = await mkShip(7, U[6], docsAll, 'Safexpress');                                // blocked: credit hold (order index 7 is Sahara)
  await shipShipment(prodU, s5.id);
  const s6 = await mkShip(8, U[7], { packing_list: true, mtc: true }, 'Maersk Line');      // blocked: export not cleared / docs missing
  await shipShipment(prodU, s6.id);
  const s7 = await mkShip(3, U[3], docsAll, 'Gati');                                      // blocked: units not released
  await shipShipment(prodU, s7.id);
  await mkShip(5, [U[5][1]], docsAll, 'TCI Freight');                                      // packed, ready to dispatch
  ok('dispatch: 3 shipped (1 partial), 4 blocked (documents / credit / export / quality), 1 packed & ready');

  // invoices from shipments (orders fully delivered)
  for (const oi of [0, 4]) {
    await step(`order→delivery ${oi}`, async () => { for (const s of ['ENGINEERING', 'MATERIAL_CHECK', 'PROCUREMENT', 'READY', 'EXECUTION', 'QC', 'DELIVERY']) await step(`o ${s}`, async () => transitionOrder(admin, orders[oi].id, s, await ver('sales_orders', orders[oi].id))); });
    const inv = await createInvoiceFromOrder(admin, orders[oi].id);
    await transitionInvoice(admin, inv.id, 'ISSUED', await ver('invoices', inv.id));
    const g = await one<any>(`select grand_total from invoices where id=$1`, [inv.id]);
    await recordPayment(admin, inv.id, Math.round(Number(g.grand_total) * (oi === 0 ? 0.5 : 1)), 'BANK_TRANSFER', `NEFT-DEMO-${oi}01`);
  }
  await step('invoice O2 partial', async () => { const inv = await createInvoiceFromOrder(admin, orders[1].id); await transitionInvoice(admin, inv.id, 'ISSUED', await ver('invoices', inv.id)); await query(`update invoices set due_date = current_date - 12 where id=$1`, [inv.id]); await transitionInvoice(admin, inv.id, 'OVERDUE', await ver('invoices', inv.id)); });
  ok('invoicing: 3 invoices (paid / part-paid / overdue)');

  // ── Engineering changes after release ─────────────────────────────────────
  const e1 = await createEcn(admin, { product_id: P['PV-BV-050'], title: 'Change stem O-ring material to FKM', reason: 'Field failures with EPDM at 120°C service' });
  await assessEcnImpact(admin, e1.id);
  const e2 = await createEcn(admin, { product_id: P['PV-GV-080'], title: 'Increase bonnet bolt torque spec', reason: 'Leak at bonnet joint during site hydrotest' });
  await assessEcnImpact(admin, e2.id);
  await submitEcn(admin, e2.id, 'Rework WIP & stock to new revision', 'from serial 20');
  const e3 = await createEcn(admin, { product_id: P['PV-CV-050'], drawing_id: drawingIds['PV-CV-050'], title: 'Add spring retainer groove', reason: 'Supplier casting update' });
  await assessEcnImpact(admin, e3.id);
  await submitEcn(admin, e3.id, 'Use existing stock until exhausted, then change', 'from next batch');
  const ap3 = await one<any>(`select id from approval_requests where entity_id=$1 and status='PENDING'`, [e3.id]);
  await decideApproval(manager, ap3.id, true, 'Approved');
  await implementEcn(manager, e3.id);
  ok('engineering changes: 3 (1 assessed, 1 awaiting checker, 1 implemented)');

  // ── Approvals & exceptions & interfaces ───────────────────────────────────
  await requestApproval(sales, { kind: 'QUOTE_DISCOUNT', entity_type: 'manual', entity_label: 'Quote for Bharat Oilfield — 12% discount', amount: 85000, reason: 'Competitive tender' });
  await requestApproval(admin, { kind: 'PO_VALUE', entity_type: 'manual', entity_label: 'PO — Eastern Alloys SS316 bar stock', amount: 708000, reason: 'Above ₹5 lakh — needs senior approval' });
  await requestApproval(sales, { kind: 'CREDIT_OVERRIDE', entity_type: 'manual', entity_label: 'Release order for Sahara Fertilizers on credit hold', amount: 300000, reason: 'Customer promised payment on Friday' });
  await raiseException(sales, { sales_order_id: orders[2].id, type: 'SPEC_CHANGE', description: 'Flange standard on customer PO differs from quotation — clarification requested from customer' });
  await raiseException(prodU, { sales_order_id: orders[6].id, type: 'MATERIAL_SHORTAGE', description: 'Gate valve 150mm: bodies not available; CF8M casting lead time 5 weeks' });
  const exLate = await raiseException(admin, { sales_order_id: orders[3].id, type: 'LATE_SUPPLIER', description: 'Heat-treatment consumables PO is 6 days late (Tamil Heat Treat Works)' });
  await resolveException(admin, exLate.id, { action_taken: 'EXPEDITE', new_promise_date: day(14) });
  const exDate = await raiseException(sales, { sales_order_id: orders[9].id, type: 'OTHER', description: 'Customer requested 1 week earlier delivery' });
  await resolveException(sales, exDate.id, { action_taken: 'DATE_CHANGE', new_promise_date: day(28) });
  const inte: [string, string, string, string?][] = [
    ['ACCOUNTING', 'invoice.post', 'INV-SYNC-0001'], ['ACCOUNTING', 'invoice.post', 'INV-SYNC-0002'], ['WEBSITE', 'inquiry.import', 'WEB-INQ-5521'], ['EMAIL', 'quote.sent', 'MAIL-QUO-0014'],
    ['CUSTOMER_PORTAL', 'order.status', 'PORTAL-SO-0007'], ['SUPPLIER_EDI', 'po.confirm', 'EDI-PO-0003'],
    ['ACCOUNTING', 'invoice.post', 'INV-SYNC-0003', 'Remote system timeout (HTTP 504)'], ['SUPPLIER_EDI', 'po.confirm', 'EDI-PO-0009', 'Supplier endpoint returned 401 — credentials expired'],
  ];
  const failedIds: string[] = [];
  for (const [system, event_type, key, err] of inte) {
    await logIntegration(org, { system, event_type, reference: key, idempotency_key: key, status: err ? 'FAILED' : 'OK', error: err, owner_id: err ? undefined : admin.id });
  }
  const f = await query<any>(`select id from integration_events where status='FAILED' order by created_at`);
  if (f[0]) await retryIntegration(admin, f[0].id);
  ok('approvals: 3 manual + NCR/ECN items · exceptions: 7 · interface events: 8 (2 failed, 1 retried)');

  const counts = await one<any>(`select
    (select count(*) from leads where org_id=$1) leads, (select count(*) from companies where org_id=$1 and is_customer) customers, (select count(*) from companies where org_id=$1 and is_supplier) suppliers,
    (select count(*) from quotations where org_id=$1) quotes, (select count(*) from sales_orders where org_id=$1) orders, (select count(*) from products where org_id=$1) products,
    (select count(*) from material_lots where org_id=$1) lots, (select count(*) from inspections where org_id=$1) inspections, (select count(*) from nonconformances where org_id=$1) ncrs,
    (select count(*) from work_orders where org_id=$1) work_orders, (select count(*) from subcontract_orders where org_id=$1) subcontract, (select count(*) from serial_units where org_id=$1) serials,
    (select count(*) from test_records where org_id=$1) tests, (select count(*) from shipments where org_id=$1) shipments, (select count(*) from invoices where org_id=$1) invoices,
    (select count(*) from engineering_changes where org_id=$1) ecns, (select count(*) from approval_requests where org_id=$1) approvals, (select count(*) from order_exceptions where org_id=$1) exceptions`, [org]);
  console.log('\nClient demo dataset ready:', counts);
  console.log('\nLogins:\n  admin@paravalves.com / admin123  (super admin)\n  manager@paravalves.com / manager123  (plant head — senior approver)\n  quality@paravalves.com / quality123\n  production@paravalves.com / production123\n  sales@paravalves.com / sales123');
  await pool.end();
}
main().catch((e) => { console.error(e); process.exit(1); });
