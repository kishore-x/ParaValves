import { requireUser } from '@/server/auth/action';
import { query } from '@/server/db';
import { Card, CardHeader, Table, Th, Td, StatusPill, PageHeader, Button, Field, inputCls, EmptyState, Badge } from '@/components/ui';
import { Flash } from '@/components/flash';
import { fmtDate } from '@/lib/format';
import { INSPECTION_TEMPLATES } from '@/lib/templates';
import { newInspectionAction, decideInspectionAction } from '../mfg-actions';

export default async function QualityPage({ searchParams }: { searchParams: Promise<{ error?: string; ok?: string }> }) {
  const sp = await searchParams;
  const user = await requireUser();
  const org = user.currentOrgId;
  const [pending, recent, lots, units, equipment] = await Promise.all([
    query<any>(`select * from inspections where org_id=$1 and status='PENDING' order by created_at`, [org]),
    query<any>(`select i.*, u.name inspector from inspections i left join users u on u.id=i.inspector_id where i.org_id=$1 and i.status<>'PENDING' order by i.decided_at desc limit 30`, [org]),
    query<any>(`select l.id, l.lot_number, l.status, p.name pname, l.quantity from material_lots l join products p on p.id=l.product_id where l.org_id=$1 and l.status='QUARANTINE' and not exists (select 1 from inspections i where i.subject_id=l.id and i.status='PENDING') order by l.received_at desc`, [org]),
    query<any>(`select id, serial_number, status from serial_units where org_id=$1 and status in ('AWAITING_FINAL','IN_ASSEMBLY') and not exists (select 1 from inspections i where i.subject_id=serial_units.id and i.status='PENDING') order by created_at desc limit 40`, [org]),
    query<any>(`select id, code, name, calibration_due, status from equipment where org_id=$1 order by code`, [org]),
  ]);
  const today = new Date(new Date().toDateString());
  const eqOk = equipment.filter((e: any) => e.status === 'ACTIVE' && (!e.calibration_due || new Date(e.calibration_due) >= today));
  return (
    <div className="space-y-6">
      <PageHeader title="Inspections" subtitle="Incoming, in-process and final inspection — failed results are never overwritten" action={<div className="flex gap-2"><Button href="/quality/tests" variant="ghost">Valve tests</Button><Button href="/quality/ncr" variant="ghost">NCRs</Button></div>} />
      <Flash error={sp.error} ok={sp.ok} />

      <Card>
        <CardHeader title={`Awaiting inspection (${pending.length})`} subtitle="Record each check, then submit the decision" />
        {pending.length === 0 ? <EmptyState title="Nothing waiting" hint="Open an inspection below for a quarantined lot or an assembled unit." /> : pending.map((i: any) => (
          <form key={i.id} action={decideInspectionAction} className="border-b border-line px-5 py-4 last:border-0">
            <input type="hidden" name="id" value={i.id} /><input type="hidden" name="stage" value={i.stage} />
            <div className="mb-3 flex flex-wrap items-center gap-2 text-sm"><span className="font-medium">{i.inspection_no}</span><Badge tone="info">{i.stage.replace('_', ' ')}</Badge><span className="text-muted">{i.subject_label}</span></div>
            <div className="grid gap-2 md:grid-cols-2">
              {(INSPECTION_TEMPLATES[i.stage] ?? []).map((name, k) => (
                <div key={name} className="flex items-center gap-2 rounded-lg border border-line px-3 py-2">
                  <span className="flex-1 text-sm">{name}</span>
                  <input name={`meas_${k}`} placeholder="Measured" className={`${inputCls} !h-8 !w-28`} />
                  <select name={`chk_${k}`} defaultValue="pass" className={`${inputCls} !h-8 !w-20`}><option value="pass">Pass</option><option value="fail">Fail</option></select>
                </div>))}
            </div>
            <div className="mt-3 flex gap-2"><input name="remarks" placeholder="Remarks (optional)" className={inputCls} /><Button type="submit">Submit decision</Button></div>
          </form>))}
      </Card>

      <div className="grid gap-6 lg:grid-cols-2">
        <Card>
          <CardHeader title="Open an inspection" />
          <div className="space-y-4 p-5">
            <form action={newInspectionAction} className="space-y-3">
              <input type="hidden" name="stage" value="INCOMING" /><input type="hidden" name="subject_type" value="LOT" />
              <Field label="Incoming — quarantined lot">
                <select name="subject_id" required className={inputCls}>{lots.length === 0 && <option value="">No quarantined lots</option>}{lots.map((l: any) => <option key={l.id} value={l.id}>{l.lot_number} · {l.pname} · {Number(l.quantity)}</option>)}</select>
              </Field>
              <input type="hidden" name="subject_label" value="Incoming lot" />
              <Field label="Equipment"><select name="equipment_id" className={inputCls}><option value="">— none —</option>{eqOk.map((e: any) => <option key={e.id} value={e.id}>{e.code} · {e.name}</option>)}</select></Field>
              <Button type="submit" size="sm" disabled={lots.length === 0}>Open incoming inspection</Button>
            </form>
            <form action={newInspectionAction} className="space-y-3 border-t border-line pt-4">
              <input type="hidden" name="stage" value="FINAL" /><input type="hidden" name="subject_type" value="SERIAL" />
              <Field label="Final — assembled valve">
                <select name="subject_id" required className={inputCls}>{units.length === 0 && <option value="">No units awaiting</option>}{units.map((u: any) => <option key={u.id} value={u.id}>{u.serial_number} · {u.status.replace('_', ' ')}</option>)}</select>
              </Field>
              <input type="hidden" name="subject_label" value="Final inspection" />
              <Button type="submit" size="sm" disabled={units.length === 0}>Open final inspection</Button>
            </form>
          </div>
        </Card>
        <Card>
          <CardHeader title="Equipment & calibration" subtitle="Out-of-calibration equipment is blocked from recording results" />
          <Table><thead><tr><Th>Code</Th><Th>Equipment</Th><Th>Cal. due</Th><Th>Status</Th></tr></thead>
            <tbody>{equipment.map((e: any) => { const expired = e.status !== 'ACTIVE' || (e.calibration_due && new Date(e.calibration_due) < today); return (
              <tr key={e.id}><Td className="font-medium">{e.code}</Td><Td>{e.name}</Td><Td className="text-xs">{fmtDate(e.calibration_due)}</Td><Td><StatusPill status={expired ? 'OUT_OF_CALIBRATION' : 'ACTIVE'} /></Td></tr>); })}</tbody></Table>
        </Card>
      </div>

      <Card>
        <CardHeader title="Inspection history" subtitle="Immutable once decided" />
        <Table><thead><tr><Th>No.</Th><Th>Stage</Th><Th>Subject</Th><Th>Result</Th><Th>Failed checks</Th><Th>By</Th><Th>When</Th></tr></thead>
          <tbody>{recent.map((i: any) => (
            <tr key={i.id}><Td className="font-medium">{i.inspection_no}</Td><Td>{i.stage}</Td><Td>{i.subject_label}</Td><Td><StatusPill status={i.status} /></Td>
              <Td className="text-xs text-muted">{(i.checks as any[]).filter((c) => !c.ok).map((c) => c.name).join(', ') || '—'}</Td><Td className="text-xs">{i.inspector}</Td><Td className="text-xs text-faint">{fmtDate(i.decided_at)}</Td></tr>))}</tbody></Table>
      </Card>
    </div>
  );
}
