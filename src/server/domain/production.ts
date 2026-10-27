import 'server-only';
import { tx } from '@/server/db';
import { nextNumber } from '@/server/numbering/engine';
import { audit, logActivity } from '@/server/audit';
import { AppError } from '@/server/http/errors';
import type { AuthUser } from '@/server/auth/session';

/** Standard valve routing. is_subcontract operations are sent to an external processor. */
export const DEFAULT_ROUTING = [
  { name: 'Material cut & forge/casting prep', work_center: 'Stores/Saw', hours: 2, sub: false },
  { name: 'CNC machining (body, bonnet, stem)', work_center: 'CNC', hours: 6, sub: false },
  { name: 'Heat treatment / surface hardening', work_center: 'Subcontract', hours: 0, sub: true },
  { name: 'Seat lapping & deburr', work_center: 'Finishing', hours: 2, sub: false },
  { name: 'Assembly', work_center: 'Assembly', hours: 3, sub: false },
];

export async function createWorkOrder(user: AuthUser, input: { sales_order_id?: string; product_id: string; quantity: number; due_date?: string }) {
  if (!(input.quantity > 0)) throw new AppError('Quantity must be positive', 422, 'BAD_QTY');
  return tx(async (c) => {
    const p = await c.one<any>(`select * from products where id=$1 and org_id=$2`, [input.product_id, user.currentOrgId]);
    if (!p) throw new AppError('Product not found', 404, 'NOT_FOUND');
    const no = await nextNumber(c, user.currentOrgId, 'WO');
    const std = Number(p.standard_cost) * input.quantity;
    const hours = DEFAULT_ROUTING.reduce((a, r) => a + r.hours, 0) * input.quantity;
    const row = (await c.query<{ id: string }>(
      `insert into work_orders (org_id, wo_number, sales_order_id, product_id, quantity, due_date, planned_start,
         planned_material_cost, planned_labor_cost, planned_subcontract_cost, planned_overhead, created_by)
       values ($1,$2,$3,$4,$5,$6, current_date, $7,$8,$9,$10,$11) returning id`,
      [user.currentOrgId, no, input.sales_order_id || null, p.id, input.quantity, input.due_date || null,
        Math.round(std * 0.55 * 100) / 100, Math.round(hours * 450 * 100) / 100, Math.round(std * 0.12 * 100) / 100, Math.round(std * 0.08 * 100) / 100, user.id]))[0]!;
    let seq = 10;
    for (const r of DEFAULT_ROUTING) {
      await c.query(`insert into work_order_operations (work_order_id, seq, name, work_center, is_subcontract, planned_hours) values ($1,$2,$3,$4,$5,$6)`,
        [row.id, seq, r.name, r.work_center, r.sub, r.hours * input.quantity]);
      seq += 10;
    }
    await audit({ orgId: user.currentOrgId, actorId: user.id, actorName: user.name, action: 'wo.create', entityType: 'work_order', entityId: row.id, after: { no } }, c);
    return { id: row.id, wo_number: no };
  });
}

/** Controlled release: engineering drawing released + order not on credit hold. */
export async function releaseGates(c: any, wo: any): Promise<{ ok: boolean; reasons: string[] }> {
  const reasons: string[] = [];
  const dr = await c.one(`select count(*) filter (where status='RELEASED')::int rel, count(*)::int total from drawings where product_id=$1`, [wo.product_id]);
  if (dr && dr.total > 0 && dr.rel === 0) reasons.push('Engineering: no released drawing for this product');
  if (wo.sales_order_id) {
    const o = await c.one(`select co.credit_hold, co.name from sales_orders so join companies co on co.id=so.company_id where so.id=$1`, [wo.sales_order_id]);
    if (o?.credit_hold) reasons.push(`Credit: ${o.name} is on credit hold`);
    const sp = await c.one(`select count(*)::int n from order_exceptions where sales_order_id=$1 and type='SPEC_CHANGE' and status<>'RESOLVED'`, [wo.sales_order_id]);
    if (sp?.n > 0) reasons.push('Specification change unresolved on the sales order');
  }
  return { ok: reasons.length === 0, reasons };
}

export async function releaseWorkOrder(user: AuthUser, id: string) {
  return tx(async (c) => {
    const wo = await c.one<any>(`select * from work_orders where id=$1 and org_id=any($2) for update`, [id, user.orgIds]);
    if (!wo) throw new AppError('Work order not found', 404, 'NOT_FOUND');
    if (wo.status !== 'PLANNED' && wo.status !== 'ON_HOLD') throw new AppError(`Work order is ${wo.status}`, 422, 'INVALID_STATE');
    const g = await releaseGates(c, wo);
    if (!g.ok) throw new AppError(`Release blocked — ${g.reasons.join('; ')}`, 422, 'RELEASE_GATE');
    await c.query(`update work_orders set status='RELEASED', hold_reason=null where id=$1`, [id]);
    await logActivity(wo.org_id, 'work_order', id, 'status', 'Work order released to shop floor', user, c);
  });
}

export async function holdWorkOrder(user: AuthUser, id: string, reason: string) {
  await tx(async (c) => {
    await c.query(`update work_orders set status='ON_HOLD', hold_reason=$1 where id=$2 and org_id=any($3) and status<>'COMPLETED'`, [reason, id, user.orgIds]);
  });
}

export async function issueMaterial(user: AuthUser, woId: string, lotId: string, quantity: number) {
  if (!(quantity > 0)) throw new AppError('Quantity must be positive', 422, 'BAD_QTY');
  return tx(async (c) => {
    const wo = await c.one<any>(`select * from work_orders where id=$1 and org_id=any($2) for update`, [woId, user.orgIds]);
    if (!wo) throw new AppError('Work order not found', 404, 'NOT_FOUND');
    if (wo.status === 'PLANNED') throw new AppError('Release the work order before issuing material', 422, 'NOT_RELEASED');
    const lot = await c.one<any>(`select l.*, p.standard_cost, p.name pname from material_lots l join products p on p.id=l.product_id where l.id=$1 and l.org_id=$2 for update of l`, [lotId, wo.org_id]);
    if (!lot) throw new AppError('Lot not found', 404, 'NOT_FOUND');
    if (lot.status !== 'RELEASED') throw new AppError(`Lot ${lot.lot_number} is ${lot.status} — only released lots can be issued`, 422, 'LOT_NOT_RELEASED');
    if (Number(lot.qty_available) < quantity) throw new AppError(`Only ${lot.qty_available} available in ${lot.lot_number}`, 422, 'INSUFFICIENT');
    const left = Number(lot.qty_available) - quantity;
    await c.query(`update material_lots set qty_available=$1, status=$2 where id=$3`, [left, left === 0 ? 'CONSUMED' : 'RELEASED', lotId]);
    await c.query(`insert into wo_material_issues (work_order_id, lot_id, product_id, quantity, unit_cost, issued_by) values ($1,$2,$3,$4,$5,$6)`,
      [woId, lotId, lot.product_id, quantity, lot.standard_cost, user.id]);
    await c.query(`insert into cost_entries (org_id, work_order_id, cost_type, amount, description) values ($1,$2,'MATERIAL',$3,$4)`,
      [wo.org_id, woId, Math.round(quantity * Number(lot.standard_cost) * 100) / 100, `${lot.pname} lot ${lot.lot_number} × ${quantity}`]);
    if (wo.status === 'RELEASED') await c.query(`update work_orders set status='IN_PROGRESS' where id=$1`, [woId]);
  });
}

export async function recordOperation(user: AuthUser, opId: string, input: { hours: number; scrap: number; rework: number; downtime: number; operator?: string; done: boolean }) {
  return tx(async (c) => {
    const op = await c.one<any>(`select o.*, w.org_id, w.status wstatus, w.product_id, w.id wid from work_order_operations o join work_orders w on w.id=o.work_order_id where o.id=$1 and w.org_id=any($2) for update of o`, [opId, user.orgIds]);
    if (!op) throw new AppError('Operation not found', 404, 'NOT_FOUND');
    if (op.wstatus === 'PLANNED') throw new AppError('Release the work order first', 422, 'NOT_RELEASED');
    if (op.wstatus === 'ON_HOLD') throw new AppError('Work order is on hold', 422, 'ON_HOLD');
    await c.query(
      `update work_order_operations set actual_hours = actual_hours + $1, scrap_qty = scrap_qty + $2, rework_qty = rework_qty + $3,
         downtime_minutes = downtime_minutes + $4, operator_name = coalesce($5, operator_name),
         status = $6, completed_at = case when $7 then now() else completed_at end where id=$8`,
      [input.hours, input.scrap, input.rework, input.downtime, input.operator || null, input.done ? 'DONE' : 'IN_PROGRESS', input.done, opId]);
    if (input.hours > 0) await c.query(`insert into cost_entries (org_id, work_order_id, cost_type, amount, description) values ($1,$2,'LABOR',$3,$4)`,
      [op.org_id, op.wid, Math.round(input.hours * Number(op.labor_rate) * 100) / 100, `${op.name} — ${input.hours}h`]);
    if (input.scrap > 0) {
      const p = await c.one<any>(`select standard_cost from products where id=$1`, [op.product_id]);
      await c.query(`insert into cost_entries (org_id, work_order_id, cost_type, amount, description) values ($1,$2,'SCRAP',$3,$4)`,
        [op.org_id, op.wid, Math.round(input.scrap * Number(p.standard_cost) * 0.4 * 100) / 100, `Scrap at ${op.name} × ${input.scrap}`]);
      await c.query(`update work_orders set qty_scrapped = qty_scrapped + $1 where id=$2`, [input.scrap, op.wid]);
    }
    await c.query(`update work_orders set status='IN_PROGRESS' where id=$1 and status='RELEASED'`, [op.wid]);
    const pending = await c.one<{ n: number }>(`select count(*)::int n from work_order_operations where work_order_id=$1 and status<>'DONE'`, [op.wid]);
    if (pending && pending.n === 0) await c.query(`update work_orders set status='COMPLETED', qty_completed = quantity - qty_scrapped where id=$1`, [op.wid]);
  });
}

// ── Subcontract ──────────────────────────────────────────────────────────────
export function reconcileStatus(s: { sent: number; returned: number; processed: number; scrapped: number }): string {
  const outstanding = s.sent - s.returned - s.scrapped;
  if (outstanding < 0 || s.processed > s.returned) return 'MISMATCH';
  if (outstanding === 0 && s.processed === s.returned) return 'RECONCILED';
  if (s.returned > 0 || s.scrapped > 0) return 'PARTIAL';
  return 'SENT';
}

export async function createSubcontract(user: AuthUser, input: { work_order_id?: string; supplier_id: string; product_id?: string; process: string; qty_sent: number; cost?: number; due_date?: string }) {
  return tx(async (c) => {
    const sup = await c.one<any>(`select approval_status, name from companies where id=$1 and org_id=$2`, [input.supplier_id, user.currentOrgId]);
    if (!sup) throw new AppError('Supplier not found', 404, 'NOT_FOUND');
    if (sup.approval_status === 'BLOCKED') throw new AppError(`${sup.name} is a blocked supplier`, 422, 'SUPPLIER_BLOCKED');
    const no = await nextNumber(c, user.currentOrgId, 'SC');
    const row = (await c.query<{ id: string }>(
      `insert into subcontract_orders (org_id, sc_number, work_order_id, supplier_id, product_id, process, qty_sent, cost, due_date, created_by)
       values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10) returning id`,
      [user.currentOrgId, no, input.work_order_id || null, input.supplier_id, input.product_id || null, input.process, input.qty_sent, input.cost ?? 0, input.due_date || null, user.id]))[0]!;
    return { id: row.id, sc_number: no };
  });
}

export async function updateSubcontract(user: AuthUser, id: string, d: { returned: number; processed: number; scrapped: number; note?: string }) {
  return tx(async (c) => {
    const s = await c.one<any>(`select * from subcontract_orders where id=$1 and org_id=any($2) for update`, [id, user.orgIds]);
    if (!s) throw new AppError('Subcontract order not found', 404, 'NOT_FOUND');
    const returned = Number(s.qty_returned) + d.returned, processed = Number(s.qty_processed) + d.processed, scrapped = Number(s.qty_scrapped) + d.scrapped;
    const status = reconcileStatus({ sent: Number(s.qty_sent), returned, processed, scrapped });
    await c.query(`update subcontract_orders set qty_returned=$1, qty_processed=$2, qty_scrapped=$3, status=$4, note=coalesce($5,note) where id=$6`, [returned, processed, scrapped, status, d.note || null, id]);
    if (status === 'RECONCILED' && s.work_order_id && Number(s.cost) > 0) {
      await c.query(`insert into cost_entries (org_id, work_order_id, cost_type, amount, description) values ($1,$2,'SUBCONTRACT',$3,$4)`, [s.org_id, s.work_order_id, s.cost, `${s.sc_number} ${s.process}`]);
    }
    if (status === 'RECONCILED' && s.work_order_id) {
      // a reconciled subcontract completes the subcontract operation on the routing
      await c.query(`update work_order_operations set status='DONE', completed_at=now() where work_order_id=$1 and is_subcontract and status<>'DONE'`, [s.work_order_id]);
      const pending = await c.one<{ n: number }>(`select count(*)::int n from work_order_operations where work_order_id=$1 and status<>'DONE'`, [s.work_order_id]);
      if (pending && pending.n === 0) await c.query(`update work_orders set status='COMPLETED', qty_completed = quantity - qty_scrapped where id=$1`, [s.work_order_id]);
    }
    await audit({ orgId: s.org_id, actorId: user.id, actorName: user.name, action: 'subcontract.update', entityType: 'subcontract', entityId: id, after: { status, returned, processed, scrapped } }, c);
  });
}

// ── Assembly & serial genealogy ──────────────────────────────────────────────
export async function createSerialUnit(user: AuthUser, input: { work_order_id: string; serial_number?: string; tag_number?: string; components: { component_name: string; lot_id?: string; subcontract_id?: string }[] }) {
  return tx(async (c) => {
    const wo = await c.one<any>(`select * from work_orders where id=$1 and org_id=any($2)`, [input.work_order_id, user.orgIds]);
    if (!wo) throw new AppError('Work order not found', 404, 'NOT_FOUND');
    for (const comp of input.components) {
      if (!comp.lot_id) continue;
      const lot = await c.one<any>(`select lot_number, status from material_lots where id=$1`, [comp.lot_id]);
      if (!lot) throw new AppError('Component lot not found', 404, 'NOT_FOUND');
      if (lot.status === 'QUARANTINE' || lot.status === 'REJECTED') throw new AppError(`Lot ${lot.lot_number} is ${lot.status} and cannot be assembled`, 422, 'LOT_NOT_RELEASED');
    }
    const rev = await c.one<any>(`select d.drawing_number, d.current_revision from drawings d where d.product_id=$1 and d.status='RELEASED' order by d.updated_at desc limit 1`, [wo.product_id]);
    const n = await c.one<{ n: number }>(`select count(*)::int n from serial_units where org_id=$1`, [wo.org_id]);
    const serial = input.serial_number || `PV-${new Date().getUTCFullYear()}-${String((n?.n ?? 0) + 1).padStart(5, '0')}`;
    const row = (await c.query<{ id: string }>(
      `insert into serial_units (org_id, serial_number, tag_number, product_id, work_order_id, sales_order_id, drawing_revision, status, as_built, assembly_checks)
       values ($1,$2,$3,$4,$5,$6,$7,'AWAITING_FINAL',$8,$9) returning id`,
      [wo.org_id, serial, input.tag_number || null, wo.product_id, wo.id, wo.sales_order_id, rev ? `${rev.drawing_number} Rev ${rev.current_revision}` : null,
        JSON.stringify({ assembled_by: user.name, assembled_at: new Date().toISOString() }),
        JSON.stringify([{ name: 'Torque check', ok: true }, { name: 'Stem travel / operation', ok: true }])]))[0]!;
    for (const comp of input.components) {
      await c.query(`insert into unit_components (serial_unit_id, component_name, lot_id, subcontract_id) values ($1,$2,$3,$4)`, [row.id, comp.component_name, comp.lot_id || null, comp.subcontract_id || null]);
    }
    await audit({ orgId: wo.org_id, actorId: user.id, actorName: user.name, action: 'serial.create', entityType: 'serial', entityId: row.id, after: { serial } }, c);
    return { id: row.id, serial_number: serial };
  });
}
