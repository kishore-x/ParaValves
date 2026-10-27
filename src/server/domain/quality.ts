import 'server-only';
import { tx } from '@/server/db';
import { nextNumber } from '@/server/numbering/engine';
import { audit, logActivity } from '@/server/audit';
import { AppError } from '@/server/http/errors';
import type { AuthUser } from '@/server/auth/session';

export interface Check { name: string; spec?: string; measured?: string; ok: boolean }

/** Raise a non-conformance. Used directly and by failed inspections/tests. */
async function raiseNcr(c: any, user: AuthUser, orgId: string, src: { type: string; id?: string | null; label?: string; description: string; quantity?: number }) {
  const no = await nextNumber(c, orgId, 'NCR');
  const row = (await c.query(
    `insert into nonconformances (org_id, ncr_number, source_type, source_id, source_label, description, quantity, raised_by)
     values ($1,$2,$3,$4,$5,$6,$7,$8) returning id`,
    [orgId, no, src.type, src.id ?? null, src.label ?? null, src.description, src.quantity ?? 1, user.id]))[0];
  await audit({ orgId, actorId: user.id, actorName: user.name, action: 'ncr.raise', entityType: 'ncr', entityId: row.id, after: { no, ...src } }, c);
  return { id: row.id as string, ncr_number: no };
}

export async function createInspection(user: AuthUser, input: { stage: string; subject_type: string; subject_id: string; subject_label?: string; checks: Check[]; equipment_id?: string; retest_of?: string }) {
  return tx(async (c) => {
    const no = await nextNumber(c, user.currentOrgId, 'INS');
    const row = (await c.query<{ id: string }>(
      `insert into inspections (org_id, inspection_no, stage, subject_type, subject_id, subject_label, checks, equipment_id, retest_of, inspector_id)
       values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10) returning id`,
      [user.currentOrgId, no, input.stage, input.subject_type, input.subject_id, input.subject_label ?? null, JSON.stringify(input.checks), input.equipment_id || null, input.retest_of || null, user.id]))[0]!;
    return { id: row.id, inspection_no: no };
  });
}

/** Record the pass/fail decision. A failed result is preserved forever; failure quarantines the subject and raises an NCR. */
export async function decideInspection(user: AuthUser, id: string, checks: Check[], remarks?: string) {
  return tx(async (c) => {
    const ins = await c.one<any>(`select * from inspections where id=$1 and org_id=any($2) for update`, [id, user.orgIds]);
    if (!ins) throw new AppError('Inspection not found', 404, 'NOT_FOUND');
    if (ins.status !== 'PENDING') throw new AppError('This inspection is already decided. Record a retest instead.', 422, 'ALREADY_DECIDED');
    if (ins.equipment_id) {
      const eq = await c.one<any>(`select * from equipment where id=$1`, [ins.equipment_id]);
      if (eq && (eq.status !== 'ACTIVE' || (eq.calibration_due && new Date(eq.calibration_due) < new Date(new Date().toDateString())))) {
        throw new AppError(`Equipment ${eq.code} is out of calibration — choose valid equipment`, 422, 'OUT_OF_CALIBRATION');
      }
    }
    const passed = checks.length > 0 && checks.every((k) => k.ok);
    await c.query(`update inspections set status=$1, checks=$2, remarks=$3, decided_at=now(), inspector_id=$4 where id=$5`,
      [passed ? 'PASSED' : 'FAILED', JSON.stringify(checks), remarks ?? null, user.id, id]);

    let ncr: { id: string; ncr_number: string } | null = null;
    if (ins.subject_type === 'LOT') {
      await c.query(`update material_lots set status=$1 where id=$2 and status in ('QUARANTINE','RELEASED')`, [passed ? 'RELEASED' : 'QUARANTINE', ins.subject_id]);
    }
    if (ins.subject_type === 'SERIAL') {
      await c.query(`update serial_units set status=$1 where id=$2 and status in ('AWAITING_FINAL','IN_ASSEMBLY','QUARANTINE')`, [passed ? 'AWAITING_FINAL' : 'QUARANTINE', ins.subject_id]);
    }
    if (!passed) {
      const bad = checks.filter((k) => !k.ok).map((k) => k.name).join(', ') || 'checks failed';
      ncr = await raiseNcr(c, user, ins.org_id, { type: 'INSPECTION', id, label: ins.subject_label ?? ins.inspection_no, description: `${ins.stage} inspection ${ins.inspection_no} failed: ${bad}` });
    }
    await audit({ orgId: ins.org_id, actorId: user.id, actorName: user.name, action: 'inspection.decide', entityType: 'inspection', entityId: id, after: { passed } }, c);
    return { passed, ncr };
  });
}

export async function manualNcr(user: AuthUser, input: { source_type: string; source_label: string; description: string; quantity?: number }) {
  return tx((c) => raiseNcr(c, user, user.currentOrgId, { type: input.source_type, label: input.source_label, description: input.description, quantity: input.quantity }));
}

/** Maker proposes a disposition; a different user (checker) must approve. */
export async function proposeDisposition(user: AuthUser, id: string, disposition: string, note?: string) {
  return tx(async (c) => {
    const n = await c.one<any>(`select * from nonconformances where id=$1 and org_id=any($2) for update`, [id, user.orgIds]);
    if (!n) throw new AppError('NCR not found', 404, 'NOT_FOUND');
    if (!['OPEN'].includes(n.status)) throw new AppError(`NCR is ${n.status}`, 422, 'INVALID_STATE');
    await c.query(`update nonconformances set status='PENDING_APPROVAL', disposition=$1, disposition_note=$2, raised_by=coalesce(raised_by,$3) where id=$4`, [disposition, note ?? null, user.id, id]);
    await c.query(
      `insert into approval_requests (org_id, kind, entity_type, entity_id, entity_label, reason, maker_id)
       values ($1,'NCR_DISPOSITION','ncr',$2,$3,$4,$5)`, [n.org_id, id, `${n.ncr_number} → ${disposition}`, note ?? null, user.id]);
    await audit({ orgId: n.org_id, actorId: user.id, actorName: user.name, action: 'ncr.propose', entityType: 'ncr', entityId: id, after: { disposition } }, c);
  });
}

/** Apply the effect of an approved disposition to the affected lot/unit. */
export async function applyDisposition(c: any, n: any, userId: string) {
  if (n.source_type === 'INSPECTION' && n.source_id) {
    const ins = await c.one(`select * from inspections where id=$1`, [n.source_id]);
    if (ins?.subject_type === 'LOT') {
      if (n.disposition === 'SCRAP' || n.disposition === 'RETURN_TO_SUPPLIER') await c.query(`update material_lots set status='REJECTED', qty_available=0 where id=$1`, [ins.subject_id]);
      if (n.disposition === 'CONCESSION') await c.query(`update material_lots set status='RELEASED' where id=$1`, [ins.subject_id]);
    }
    if (ins?.subject_type === 'SERIAL' && n.disposition === 'CONCESSION') {
      await c.query(`update serial_units set status='AWAITING_FINAL' where id=$1`, [ins.subject_id]);
    }
  }
  if (n.source_type === 'TEST' && n.source_id) {
    const t = await c.one(`select serial_unit_id from test_records where id=$1`, [n.source_id]);
    if (t && (n.disposition === 'REWORK' || n.disposition === 'RETEST')) await c.query(`update serial_units set status='IN_ASSEMBLY' where id=$1 and status='QUARANTINE'`, [t.serial_unit_id]);
  }
}

export async function recordTest(user: AuthUser, input: { serial_unit_id: string; test_type: string; test_pressure_bar?: number; hold_minutes?: number; allowable?: string; measured?: string; result: 'PASS' | 'FAIL'; equipment_id?: string; evidence_ref?: string; retest_of?: string }) {
  return tx(async (c) => {
    const unit = await c.one<any>(`select * from serial_units where id=$1 and org_id=any($2) for update`, [input.serial_unit_id, user.orgIds]);
    if (!unit) throw new AppError('Serial unit not found', 404, 'NOT_FOUND');
    if (input.equipment_id) {
      const eq = await c.one<any>(`select * from equipment where id=$1`, [input.equipment_id]);
      if (eq && (eq.status !== 'ACTIVE' || (eq.calibration_due && new Date(eq.calibration_due) < new Date(new Date().toDateString())))) {
        throw new AppError(`Test equipment ${eq.code} is out of calibration`, 422, 'OUT_OF_CALIBRATION');
      }
    }
    const no = await nextNumber(c, unit.org_id, 'TST');
    const row = (await c.query<{ id: string }>(
      `insert into test_records (org_id, test_number, serial_unit_id, test_type, test_pressure_bar, hold_minutes, allowable, measured, result, equipment_id, evidence_ref, retest_of, performed_by)
       values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13) returning id`,
      [unit.org_id, no, unit.id, input.test_type, input.test_pressure_bar ?? null, input.hold_minutes ?? null, input.allowable ?? null, input.measured ?? null, input.result, input.equipment_id || null, input.evidence_ref ?? null, input.retest_of || null, user.id]))[0]!;
    let ncr = null;
    if (input.result === 'FAIL') {
      await c.query(`update serial_units set status='QUARANTINE' where id=$1`, [unit.id]);
      ncr = await raiseNcr(c, user, unit.org_id, { type: 'TEST', id: row.id, label: unit.serial_number, description: `${input.test_type} test ${no} failed on ${unit.serial_number} (allowable ${input.allowable ?? '-'}, measured ${input.measured ?? '-'})` });
    }
    await audit({ orgId: unit.org_id, actorId: user.id, actorName: user.name, action: 'test.record', entityType: 'test', entityId: row.id, after: { no, result: input.result } }, c);
    return { id: row.id, test_number: no, ncr };
  });
}

export const REQUIRED_TESTS = ['SHELL_PRESSURE', 'SEAT_LEAK', 'FUNCTIONAL'];

/** Release gate for a finished valve: final inspection passed + all required tests passed + no open NCR. */
export async function releaseGate(c: any, unitId: string): Promise<{ ok: boolean; reasons: string[] }> {
  const reasons: string[] = [];
  const fin = await c.one(`select status from inspections where subject_type='SERIAL' and subject_id=$1 and stage='FINAL' order by created_at desc limit 1`, [unitId]);
  if (!fin || fin.status !== 'PASSED') reasons.push('Final inspection not passed');
  for (const t of REQUIRED_TESTS) {
    const r = await c.one(`select result from test_records where serial_unit_id=$1 and test_type=$2 order by performed_at desc, test_number desc limit 1`, [unitId, t]);
    if (!r) reasons.push(`${t.replace('_', ' ').toLowerCase()} test not recorded`);
    else if (r.result !== 'PASS') reasons.push(`${t.replace('_', ' ').toLowerCase()} test failed`);
  }
  const ncr = await c.one(`select count(*)::int n from nonconformances where status in ('OPEN','PENDING_APPROVAL') and ((source_type='TEST' and source_id in (select id from test_records where serial_unit_id=$1)) or (source_type='INSPECTION' and source_id in (select id from inspections where subject_id=$1)))`, [unitId]);
  if (ncr && ncr.n > 0) reasons.push('Open non-conformance on this unit');
  return { ok: reasons.length === 0, reasons };
}

export async function releaseUnit(user: AuthUser, unitId: string) {
  return tx(async (c) => {
    const u = await c.one<any>(`select * from serial_units where id=$1 and org_id=any($2) for update`, [unitId, user.orgIds]);
    if (!u) throw new AppError('Unit not found', 404, 'NOT_FOUND');
    const g = await releaseGate(c, unitId);
    if (!g.ok) throw new AppError(`Cannot release ${u.serial_number}: ${g.reasons.join('; ')}`, 422, 'QUALITY_GATE');
    await c.query(`update serial_units set status='RELEASED', released_at=now() where id=$1`, [unitId]);
    await logActivity(u.org_id, 'serial', unitId, 'status', `Unit ${u.serial_number} released by quality`, user, c);
    await audit({ orgId: u.org_id, actorId: user.id, actorName: user.name, action: 'unit.release', entityType: 'serial', entityId: unitId }, c);
  });
}
