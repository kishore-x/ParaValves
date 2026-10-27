import 'server-only';
import { tx } from '@/server/db';
import { nextNumber } from '@/server/numbering/engine';
import { audit } from '@/server/audit';
import { AppError } from '@/server/http/errors';
import { can } from '@/server/auth/rbac';
import { applyDisposition } from './quality';
import type { AuthUser } from '@/server/auth/session';

/** Value above which a checker needs senior (approval.manage) authority. */
export const APPROVAL_LIMIT = 500_000;

// ── Maker-checker approvals ──────────────────────────────────────────────────
export async function requestApproval(user: AuthUser, input: { kind: string; entity_type: string; entity_id?: string; entity_label: string; amount?: number; reason?: string }) {
  return tx(async (c) => {
    const r = (await c.query<{ id: string }>(
      `insert into approval_requests (org_id, kind, entity_type, entity_id, entity_label, amount, reason, maker_id)
       values ($1,$2,$3,$4,$5,$6,$7,$8) returning id`,
      [user.currentOrgId, input.kind, input.entity_type, input.entity_id || null, input.entity_label, input.amount ?? null, input.reason ?? null, user.id]))[0]!;
    await audit({ orgId: user.currentOrgId, actorId: user.id, actorName: user.name, action: 'approval.request', entityType: 'approval', entityId: r.id, after: input as any }, c);
    return r;
  });
}

export async function decideApproval(user: AuthUser, id: string, approve: boolean, note?: string) {
  return tx(async (c) => {
    const a = await c.one<any>(`select * from approval_requests where id=$1 and org_id=any($2) for update`, [id, user.orgIds]);
    if (!a) throw new AppError('Approval not found', 404, 'NOT_FOUND');
    if (a.status !== 'PENDING') throw new AppError(`Already ${a.status}`, 422, 'INVALID_STATE');
    if (a.maker_id === user.id) throw new AppError('Maker-checker: you cannot approve your own request', 403, 'SELF_APPROVAL');
    if (a.amount && Number(a.amount) > APPROVAL_LIMIT && !can(user, 'approval.manage')) {
      throw new AppError(`Amount exceeds your approval limit (₹${APPROVAL_LIMIT.toLocaleString('en-IN')}) — needs senior approval`, 403, 'LIMIT_EXCEEDED');
    }
    await c.query(`update approval_requests set status=$1, checker_id=$2, decision_note=$3, decided_at=now() where id=$4`, [approve ? 'APPROVED' : 'REJECTED', user.id, note ?? null, id]);
    if (a.entity_type === 'ncr' && a.entity_id) {
      const n = await c.one<any>(`select * from nonconformances where id=$1`, [a.entity_id]);
      if (approve) {
        await c.query(`update nonconformances set status='APPROVED', approved_by=$1, approved_at=now() where id=$2`, [user.id, a.entity_id]);
        await applyDisposition(c, n, user.id);
      } else {
        await c.query(`update nonconformances set status='OPEN', disposition=null where id=$1`, [a.entity_id]);
      }
    }
    if (a.entity_type === 'ecn' && a.entity_id) {
      await c.query(`update engineering_changes set status=$1, checker_id=$2, decided_at=now() where id=$3`, [approve ? 'APPROVED' : 'REJECTED', user.id, a.entity_id]);
    }
    await audit({ orgId: a.org_id, actorId: user.id, actorName: user.name, action: approve ? 'approval.approve' : 'approval.reject', entityType: 'approval', entityId: id, metadata: { note } }, c);
  });
}

export async function closeNcr(user: AuthUser, id: string) {
  await tx(async (c) => {
    const n = await c.one<any>(`select * from nonconformances where id=$1 and org_id=any($2)`, [id, user.orgIds]);
    if (!n) throw new AppError('NCR not found', 404, 'NOT_FOUND');
    if (n.status !== 'APPROVED') throw new AppError('Only an approved disposition can be closed', 422, 'INVALID_STATE');
    await c.query(`update nonconformances set status='CLOSED', closed_at=now() where id=$1`, [id]);
  });
}

// ── Engineering change after release ─────────────────────────────────────────
export async function createEcn(user: AuthUser, input: { product_id: string; drawing_id?: string; title: string; reason?: string }) {
  return tx(async (c) => {
    const no = await nextNumber(c, user.currentOrgId, 'ECN');
    const r = (await c.query<{ id: string }>(
      `insert into engineering_changes (org_id, ecn_number, product_id, drawing_id, title, reason, maker_id) values ($1,$2,$3,$4,$5,$6,$7) returning id`,
      [user.currentOrgId, no, input.product_id, input.drawing_id || null, input.title, input.reason ?? null, user.id]))[0]!;
    return { id: r.id, ecn_number: no };
  });
}

/** What does this change touch? Open orders, open POs, stock, lots and WIP. */
export async function assessEcnImpact(user: AuthUser, id: string) {
  return tx(async (c) => {
    const e = await c.one<any>(`select * from engineering_changes where id=$1 and org_id=any($2) for update`, [id, user.orgIds]);
    if (!e) throw new AppError('ECN not found', 404, 'NOT_FOUND');
    const pid = e.product_id;
    const orders = await c.query<any>(`select distinct so.order_number, so.status, co.name customer, so.delivery_date from sales_order_lines l join sales_orders so on so.id=l.sales_order_id join companies co on co.id=so.company_id where l.product_id=$1 and so.status not in ('CLOSED','CANCELLED')`, [pid]);
    const pos = await c.query<any>(`select distinct po.po_number, po.status, sup.name supplier from purchase_order_lines l join purchase_orders po on po.id=l.purchase_order_id join companies sup on sup.id=po.supplier_id where l.product_id=$1 and po.status not in ('CLOSED','RECEIVED')`, [pid]);
    const stock = await c.one<any>(`select coalesce(sum(on_hand),0) on_hand, coalesce(sum(incoming),0) incoming from stock_items where product_id=$1`, [pid]);
    const lots = await c.query<any>(`select lot_number, status, qty_available from material_lots where product_id=$1 and qty_available>0`, [pid]);
    const wip = await c.query<any>(`select wo_number, status, quantity from work_orders where product_id=$1 and status in ('PLANNED','RELEASED','IN_PROGRESS','ON_HOLD')`, [pid]);
    const units = await c.one<any>(`select count(*)::int n from serial_units where product_id=$1 and status in ('IN_ASSEMBLY','AWAITING_FINAL','QUARANTINE')`, [pid]);
    const impact = { orders, pos, stock: { on_hand: Number(stock.on_hand), incoming: Number(stock.incoming), lots }, wip, units_in_process: units.n };
    await c.query(`update engineering_changes set impact=$1, status='IMPACT_ASSESSED' where id=$2 and status in ('DRAFT','IMPACT_ASSESSED')`, [JSON.stringify(impact), id]);
    return impact;
  });
}

export async function submitEcn(user: AuthUser, id: string, disposition: string, effectivity: string) {
  return tx(async (c) => {
    const e = await c.one<any>(`select * from engineering_changes where id=$1 and org_id=any($2) for update`, [id, user.orgIds]);
    if (!e) throw new AppError('ECN not found', 404, 'NOT_FOUND');
    if (e.status !== 'IMPACT_ASSESSED') throw new AppError('Assess impact before submitting for approval', 422, 'INVALID_STATE');
    await c.query(`update engineering_changes set disposition=$1, effectivity=$2, maker_id=$3 where id=$4`, [disposition, effectivity, user.id, id]);
    await c.query(`insert into approval_requests (org_id, kind, entity_type, entity_id, entity_label, reason, maker_id) values ($1,'ECN','ecn',$2,$3,$4,$5)`,
      [e.org_id, id, `${e.ecn_number} ${e.title}`, `${disposition} — effective ${effectivity}`, user.id]);
  });
}

export async function implementEcn(user: AuthUser, id: string) {
  await tx(async (c) => {
    const e = await c.one<any>(`select * from engineering_changes where id=$1 and org_id=any($2)`, [id, user.orgIds]);
    if (!e || e.status !== 'APPROVED') throw new AppError('Only an approved change can be implemented', 422, 'INVALID_STATE');
    await c.query(`update engineering_changes set status='IMPLEMENTED' where id=$1`, [id]);
    if (e.drawing_id) await c.query(`update drawings set current_revision = current_revision + 1, status='REVIEW' where id=$1`, [e.drawing_id]);
    await audit({ orgId: e.org_id, actorId: user.id, actorName: user.name, action: 'ecn.implement', entityType: 'ecn', entityId: id }, c);
  });
}

// ── Order exceptions ─────────────────────────────────────────────────────────
export async function raiseException(user: AuthUser, input: { sales_order_id?: string; type: string; description: string; owner_id?: string }) {
  return tx(async (c) => {
    const no = await nextNumber(c, user.currentOrgId, 'EXC');
    const r = (await c.query<{ id: string }>(
      `insert into order_exceptions (org_id, exception_no, sales_order_id, type, description, owner_id, created_by) values ($1,$2,$3,$4,$5,$6,$7) returning id`,
      [user.currentOrgId, no, input.sales_order_id || null, input.type, input.description, input.owner_id || user.id, user.id]))[0]!;
    return { id: r.id, exception_no: no };
  });
}

export async function resolveException(user: AuthUser, id: string, input: { action_taken: string; new_promise_date?: string }) {
  await tx(async (c) => {
    const upd = await c.query(`update order_exceptions set status='RESOLVED', action_taken=$1, new_promise_date=$2, resolved_at=now() where id=$3 and org_id=any($4) returning id`,
      [input.action_taken, input.new_promise_date || null, id, user.orgIds]);
    if (!upd.length) throw new AppError('Exception not found', 404, 'NOT_FOUND');
    if (input.new_promise_date) {
      const e = await c.one<any>(`select sales_order_id from order_exceptions where id=$1`, [id]);
      if (e?.sales_order_id) await c.query(`update sales_orders set delivery_date=$1 where id=$2`, [input.new_promise_date, e.sales_order_id]);
    }
  });
}

// ── Sales order review ───────────────────────────────────────────────────────
export const REVIEW_KEYS = ['po_ok', 'spec_ok', 'price_ok', 'terms_ok', 'credit_ok', 'capacity_ok', 'date_ok'] as const;

export async function saveOrderReview(user: AuthUser, orderId: string, f: Record<string, boolean>, differences: string, promiseDate: string | undefined, acknowledge: boolean) {
  await tx(async (c) => {
    const o = await c.one<any>(`select * from sales_orders where id=$1 and org_id=any($2)`, [orderId, user.orgIds]);
    if (!o) throw new AppError('Order not found', 404, 'NOT_FOUND');
    const allOk = REVIEW_KEYS.every((k) => f[k]);
    if (acknowledge && !allOk) throw new AppError('Every review item must be validated before the acknowledgement can be issued', 422, 'REVIEW_INCOMPLETE');
    await c.query(
      `insert into order_reviews (org_id, sales_order_id, po_ok, spec_ok, price_ok, terms_ok, credit_ok, capacity_ok, date_ok, differences, promise_date, acknowledged_at, reviewed_by)
       values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13)
       on conflict (sales_order_id) do update set po_ok=$3, spec_ok=$4, price_ok=$5, terms_ok=$6, credit_ok=$7, capacity_ok=$8, date_ok=$9,
         differences=$10, promise_date=$11, acknowledged_at=case when $14 then now() else order_reviews.acknowledged_at end, reviewed_by=$13, updated_at=now()`,
      [o.org_id, orderId, !!f.po_ok, !!f.spec_ok, !!f.price_ok, !!f.terms_ok, !!f.credit_ok, !!f.capacity_ok, !!f.date_ok, differences || null, promiseDate || null, acknowledge ? new Date() : null, user.id, acknowledge]);
    if (promiseDate) await c.query(`update sales_orders set delivery_date=$1 where id=$2`, [promiseDate, orderId]);
    await audit({ orgId: o.org_id, actorId: user.id, actorName: user.name, action: acknowledge ? 'order.acknowledge' : 'order.review', entityType: 'order', entityId: orderId }, c);
  });
}

// ── Interfaces with idempotency ──────────────────────────────────────────────
export async function logIntegration(orgId: string, e: { system: string; event_type: string; reference?: string; idempotency_key: string; payload?: any; status?: string; error?: string; owner_id?: string }) {
  return tx(async (c) => {
    const r = await c.query(
      `insert into integration_events (org_id, system, event_type, reference, idempotency_key, payload, status, error, owner_id)
       values ($1,$2,$3,$4,$5,$6,$7,$8,$9) on conflict (org_id, idempotency_key) do nothing returning id`,
      [orgId, e.system, e.event_type, e.reference ?? null, e.idempotency_key, JSON.stringify(e.payload ?? {}), e.status ?? 'OK', e.error ?? null, e.owner_id ?? null]);
    return { created: r.length > 0, duplicate: r.length === 0 };
  });
}

/** Safe retry: re-processing a failed event never creates a second posting because the idempotency key is unique. */
export async function retryIntegration(user: AuthUser, id: string) {
  await tx(async (c) => {
    const e = await c.one<any>(`select * from integration_events where id=$1 and org_id=any($2) for update`, [id, user.orgIds]);
    if (!e) throw new AppError('Event not found', 404, 'NOT_FOUND');
    if (e.status !== 'FAILED') throw new AppError('Only failed events can be retried', 422, 'INVALID_STATE');
    await c.query(`update integration_events set status='RETRIED', attempts=attempts+1, error=null, updated_at=now(), owner_id=$1 where id=$2`, [user.id, id]);
    await audit({ orgId: e.org_id, actorId: user.id, actorName: user.name, action: 'integration.retry', entityType: 'integration', entityId: id, metadata: { key: e.idempotency_key } }, c);
  });
}
