'use server';
import { redirect } from 'next/navigation';
import { revalidatePath } from 'next/cache';
import { requirePermission } from '@/server/auth/action';
import { AppError } from '@/server/http/errors';
import { query } from '@/server/db';
import { createInspection, decideInspection, manualNcr, proposeDisposition, recordTest, releaseUnit } from '@/server/domain/quality';
import { createWorkOrder, releaseWorkOrder, holdWorkOrder, issueMaterial, recordOperation, createSubcontract, updateSubcontract, createSerialUnit } from '@/server/domain/production';
import { createShipment, updateShipmentDocs, shipShipment } from '@/server/domain/shipping';
import { requestApproval, decideApproval, closeNcr, createEcn, assessEcnImpact, submitEcn, implementEcn, raiseException, resolveException, saveOrderReview, REVIEW_KEYS, retryIntegration, logIntegration } from '@/server/domain/governance';
import { newBomRevision, addBomLine, releaseBom } from '@/server/domain/bom';
import { INSPECTION_TEMPLATES } from '@/lib/templates';

/** Run a domain call; turn business-rule errors into a banner instead of a crash page. */
async function run(path: string, fn: () => Promise<string | void>) {
  let err: string | undefined, ok: string | undefined;
  try { ok = (await fn()) || undefined; }
  catch (e) {
    if (e instanceof AppError || (e as { status?: number })?.status === 403) err = (e as Error).message;
    else if ((e as { code?: string })?.code === '23505') err = 'That record already exists (duplicate prevented).';
    else if (e && typeof e === 'object' && 'message' in e && /immutable|append-only|violates/.test(String((e as Error).message))) err = (e as Error).message;
    else throw e;
  }
  revalidatePath(path);
  const sep = path.includes('?') ? '&' : '?';
  redirect(err ? `${path}${sep}error=${encodeURIComponent(err)}` : ok ? `${path}${sep}ok=${encodeURIComponent(ok)}` : path);
}
const s = (fd: FormData, k: string) => { const v = fd.get(k); const t = v == null ? '' : String(v).trim(); return t === '' ? undefined : t; };
const n = (fd: FormData, k: string) => Number(fd.get(k) || 0);

// ── Quality ──────────────────────────────────────────────────────────────────
export async function newInspectionAction(fd: FormData) {
  const user = await requirePermission('quality.create');
  const stage = String(fd.get('stage'));
  await run('/quality', async () => {
    const r = await createInspection(user, { stage, subject_type: String(fd.get('subject_type')), subject_id: String(fd.get('subject_id')), subject_label: s(fd, 'subject_label'), checks: (INSPECTION_TEMPLATES[stage] ?? []).map((name) => ({ name, ok: false })), equipment_id: s(fd, 'equipment_id') });
    return `Inspection ${r.inspection_no} opened`;
  });
}
export async function decideInspectionAction(fd: FormData) {
  const user = await requirePermission('quality.edit');
  const id = String(fd.get('id')); const stage = String(fd.get('stage'));
  const back = s(fd, 'back') || '/quality';
  const checks = (INSPECTION_TEMPLATES[stage] ?? []).map((name, i) => ({ name, measured: s(fd, `meas_${i}`), ok: fd.get(`chk_${i}`) === 'pass' }));
  await run(back, async () => {
    const r = await decideInspection(user, id, checks, s(fd, 'remarks'));
    return r.passed ? 'Inspection PASSED' : `Inspection FAILED — ${r.ncr?.ncr_number} raised and subject quarantined`;
  });
}
export async function newNcrAction(fd: FormData) {
  const user = await requirePermission('quality.create');
  await run('/quality/ncr', async () => `${(await manualNcr(user, { source_type: String(fd.get('source_type')), source_label: String(fd.get('source_label')), description: String(fd.get('description')), quantity: n(fd, 'quantity') || 1 })).ncr_number} raised`);
}
export async function proposeDispositionAction(fd: FormData) {
  const user = await requirePermission('quality.edit');
  await run('/quality/ncr', async () => { await proposeDisposition(user, String(fd.get('id')), String(fd.get('disposition')), s(fd, 'note')); return 'Disposition sent for approval (checker must be a different user)'; });
}
export async function closeNcrAction(fd: FormData) {
  const user = await requirePermission('quality.edit');
  await run('/quality/ncr', async () => { await closeNcr(user, String(fd.get('id'))); return 'NCR closed'; });
}
export async function recordTestAction(fd: FormData) {
  const user = await requirePermission('quality.create');
  const back = s(fd, 'back') || '/quality/tests';
  await run(back, async () => {
    const r = await recordTest(user, { serial_unit_id: String(fd.get('serial_unit_id')), test_type: String(fd.get('test_type')), test_pressure_bar: n(fd, 'test_pressure_bar') || undefined, hold_minutes: n(fd, 'hold_minutes') || undefined, allowable: s(fd, 'allowable'), measured: s(fd, 'measured'), result: fd.get('result') === 'PASS' ? 'PASS' : 'FAIL', equipment_id: s(fd, 'equipment_id'), evidence_ref: s(fd, 'evidence_ref'), retest_of: s(fd, 'retest_of') });
    return r.ncr ? `${r.test_number} FAILED — unit quarantined, ${r.ncr.ncr_number} raised (original result is preserved)` : `${r.test_number} recorded: PASS`;
  });
}
export async function releaseUnitAction(fd: FormData) {
  const user = await requirePermission('quality.approve');
  const id = String(fd.get('id'));
  await run(`/assembly/${id}`, async () => { await releaseUnit(user, id); return 'Unit released by quality'; });
}

// ── Production ───────────────────────────────────────────────────────────────
export async function newWorkOrderAction(fd: FormData) {
  const user = await requirePermission('production.create');
  let id = '';
  await run('/production', async () => { const r = await createWorkOrder(user, { sales_order_id: s(fd, 'sales_order_id'), product_id: String(fd.get('product_id')), quantity: n(fd, 'quantity'), due_date: s(fd, 'due_date') }); id = r.id; return `${r.wo_number} created`; });
}
export async function releaseWorkOrderAction(fd: FormData) {
  const user = await requirePermission('production.edit');
  const id = String(fd.get('id'));
  await run(`/production/${id}`, async () => { await releaseWorkOrder(user, id); return 'Released to shop floor'; });
}
export async function holdWorkOrderAction(fd: FormData) {
  const user = await requirePermission('production.edit');
  const id = String(fd.get('id'));
  await run(`/production/${id}`, async () => { await holdWorkOrder(user, id, String(fd.get('reason') || 'On hold')); return 'Work order placed on hold'; });
}
export async function issueMaterialAction(fd: FormData) {
  const user = await requirePermission('production.edit');
  const id = String(fd.get('id'));
  await run(`/production/${id}`, async () => { await issueMaterial(user, id, String(fd.get('lot_id')), n(fd, 'quantity')); return 'Material issued (lot traceability recorded)'; });
}
export async function recordOperationAction(fd: FormData) {
  const user = await requirePermission('production.edit');
  const id = String(fd.get('id'));
  await run(`/production/${id}`, async () => { await recordOperation(user, String(fd.get('op_id')), { hours: n(fd, 'hours'), scrap: n(fd, 'scrap'), rework: n(fd, 'rework'), downtime: n(fd, 'downtime'), operator: s(fd, 'operator'), done: fd.get('done') === 'on' }); return 'Operation progress recorded'; });
}
export async function newSubcontractAction(fd: FormData) {
  const user = await requirePermission('subcontract.create');
  await run('/subcontract', async () => `${(await createSubcontract(user, { work_order_id: s(fd, 'work_order_id'), supplier_id: String(fd.get('supplier_id')), product_id: s(fd, 'product_id'), process: String(fd.get('process')), qty_sent: n(fd, 'qty_sent'), cost: n(fd, 'cost'), due_date: s(fd, 'due_date') })).sc_number} sent to supplier`);
}
export async function updateSubcontractAction(fd: FormData) {
  const user = await requirePermission('subcontract.edit');
  await run('/subcontract', async () => { await updateSubcontract(user, String(fd.get('id')), { returned: n(fd, 'returned'), processed: n(fd, 'processed'), scrapped: n(fd, 'scrapped'), note: s(fd, 'note') }); return 'Reconciliation updated'; });
}
export async function newSerialAction(fd: FormData) {
  const user = await requirePermission('production.create');
  const comps: { component_name: string; lot_id?: string }[] = [];
  for (const k of ['body', 'stem', 'seat', 'bonnet']) { const lot = s(fd, `lot_${k}`); if (lot) comps.push({ component_name: k.charAt(0).toUpperCase() + k.slice(1), lot_id: lot }); }
  let go = '/assembly';
  await run('/assembly', async () => { const r = await createSerialUnit(user, { work_order_id: String(fd.get('work_order_id')), serial_number: s(fd, 'serial_number'), tag_number: s(fd, 'tag_number'), components: comps }); go = `/assembly/${r.id}`; return `${r.serial_number} assembled`; });
}

// ── Shipping ─────────────────────────────────────────────────────────────────
export async function newShipmentAction(fd: FormData) {
  const user = await requirePermission('shipment.create');
  const ids = fd.getAll('unit').map(String);
  if (!ids.length) return run('/shipments', async () => { throw new AppError('Select at least one unit to pack', 422, 'NO_UNITS'); });
  const r = await createShipment(user, { sales_order_id: String(fd.get('sales_order_id')), serial_unit_ids: ids }).catch((e) => e);
  if (r instanceof Error) return run('/shipments', async () => { throw r; });
  revalidatePath('/shipments'); redirect(`/shipments/${r.id}`);
}
export async function shipmentDocsAction(fd: FormData) {
  const user = await requirePermission('shipment.edit');
  const id = String(fd.get('id'));
  await run(`/shipments/${id}`, async () => { await updateShipmentDocs(user, id, { packing_list: fd.get('packing_list') === 'on', mtc: fd.get('mtc') === 'on', export_docs: fd.get('export_docs') === 'on' }, s(fd, 'carrier')); return 'Documents updated'; });
}
export async function shipAction(fd: FormData) {
  const user = await requirePermission('shipment.edit');
  const id = String(fd.get('id'));
  await run(`/shipments/${id}`, async () => {
    const r = await shipShipment(user, id);
    if (!r.shipped) throw new AppError(`Shipment blocked: ${r.blocked!.map((g) => g.label).join(', ')}`, 422, 'BLOCKED');
    return 'Shipment dispatched';
  });
}

// ── Governance ───────────────────────────────────────────────────────────────
export async function decideApprovalAction(fd: FormData) {
  const user = await requirePermission('approval.approve');
  await run('/approvals', async () => { const ok = fd.get('decision') === 'approve'; await decideApproval(user, String(fd.get('id')), ok, s(fd, 'note')); return ok ? 'Approved' : 'Rejected'; });
}
export async function requestApprovalAction(fd: FormData) {
  const user = await requirePermission('approval.create');
  await run('/approvals', async () => { await requestApproval(user, { kind: String(fd.get('kind')), entity_type: 'manual', entity_label: String(fd.get('entity_label')), amount: n(fd, 'amount') || undefined, reason: s(fd, 'reason') }); return 'Approval requested'; });
}
export async function newEcnAction(fd: FormData) {
  const user = await requirePermission('engineering.create');
  await run('/changes', async () => `${(await createEcn(user, { product_id: String(fd.get('product_id')), title: String(fd.get('title')), reason: s(fd, 'reason') })).ecn_number} opened`);
}
export async function assessEcnAction(fd: FormData) {
  const user = await requirePermission('engineering.edit');
  await run('/changes', async () => { await assessEcnImpact(user, String(fd.get('id'))); return 'Impact assessed across orders, purchasing, stock and WIP'; });
}
export async function submitEcnAction(fd: FormData) {
  const user = await requirePermission('engineering.edit');
  await run('/changes', async () => { await submitEcn(user, String(fd.get('id')), String(fd.get('disposition')), String(fd.get('effectivity'))); return 'Submitted for checker approval'; });
}
export async function implementEcnAction(fd: FormData) {
  const user = await requirePermission('engineering.approve');
  await run('/changes', async () => { await implementEcn(user, String(fd.get('id'))); return 'Change implemented; drawing revision raised'; });
}
export async function newExceptionAction(fd: FormData) {
  const user = await requirePermission('order.create');
  await run('/exceptions', async () => `${(await raiseException(user, { sales_order_id: s(fd, 'sales_order_id'), type: String(fd.get('type')), description: String(fd.get('description')) })).exception_no} raised`);
}
export async function resolveExceptionAction(fd: FormData) {
  const user = await requirePermission('order.edit');
  await run('/exceptions', async () => { await resolveException(user, String(fd.get('id')), { action_taken: String(fd.get('action_taken')), new_promise_date: s(fd, 'new_promise_date') }); return 'Exception resolved'; });
}
export async function orderReviewAction(fd: FormData) {
  const user = await requirePermission('order.edit');
  const id = String(fd.get('id'));
  const f: Record<string, boolean> = {}; for (const k of REVIEW_KEYS) f[k] = fd.get(k) === 'on';
  await run(`/orders/${id}/review`, async () => { await saveOrderReview(user, id, f, String(fd.get('differences') || ''), s(fd, 'promise_date'), fd.get('acknowledge') === 'on'); return fd.get('acknowledge') === 'on' ? 'Order acknowledgement issued' : 'Review saved'; });
}
export async function retryIntegrationAction(fd: FormData) {
  const user = await requirePermission('integration.edit');
  await run('/integrations', async () => { await retryIntegration(user, String(fd.get('id'))); return 'Retried safely — duplicate postings prevented by idempotency key'; });
}
export async function simulateIntegrationAction(fd: FormData) {
  const user = await requirePermission('integration.edit');
  const key = String(fd.get('key'));
  await run('/integrations', async () => {
    const r = await logIntegration(user.currentOrgId, { system: String(fd.get('system')), event_type: 'invoice.post', reference: key, idempotency_key: key, status: fd.get('fail') === 'on' ? 'FAILED' : 'OK', error: fd.get('fail') === 'on' ? 'Remote system timeout (HTTP 504)' : undefined, owner_id: user.id });
    if (r.duplicate) throw new AppError(`Duplicate prevented — an event with key "${key}" was already processed`, 409, 'DUPLICATE');
    return 'Event logged';
  });
}
export async function toggleSupplierAction(fd: FormData) {
  const user = await requirePermission('company.edit');
  await run('/suppliers', async () => { await query(`update companies set approval_status=$1 where id=$2 and org_id=any($3)`, [String(fd.get('status')), String(fd.get('id')), user.orgIds]); return 'Supplier status updated'; });
}

// ── Bill of material ─────────────────────────────────────────────────────────
export async function newBomRevisionAction(fd: FormData) {
  const user = await requirePermission('bom.create');
  await run('/bom', async () => { const r = await newBomRevision(user, String(fd.get('product_id'))); return `BOM revision ${r.revision} started`; });
}
export async function addBomLineAction(fd: FormData) {
  const user = await requirePermission('bom.edit');
  await run('/bom', async () => { await addBomLine(user, String(fd.get('bom_id')), String(fd.get('component_id')), n(fd, 'quantity'), n(fd, 'scrap_pct')); return 'Component added'; });
}
export async function releaseBomAction(fd: FormData) {
  const user = await requirePermission('bom.approve');
  await run('/bom', async () => { await releaseBom(user, String(fd.get('bom_id'))); return 'BOM released and effective from today'; });
}
