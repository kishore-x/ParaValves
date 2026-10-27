import { requireUser } from '@/server/auth/action';
import { query } from '@/server/db';
import { Card, CardHeader, Table, Th, Td, StatusPill, PageHeader, Field, Button, inputCls } from '@/components/ui';
import { Flash } from '@/components/flash';
import { fmtDateTime } from '@/lib/format';
import { recordTestAction } from '../../mfg-actions';

export default async function TestsPage({ searchParams }: { searchParams: Promise<{ error?: string; ok?: string; unit?: string }> }) {
  const sp = await searchParams;
  const user = await requireUser();
  const org = user.currentOrgId;
  const [tests, units, equipment] = await Promise.all([
    query<any>(`select t.*, u.serial_number, e.code eq_code from test_records t join serial_units u on u.id=t.serial_unit_id left join equipment e on e.id=t.equipment_id where t.org_id=$1 order by t.performed_at desc limit 60`, [org]),
    query<any>(`select id, serial_number, status from serial_units where org_id=$1 and status in ('AWAITING_FINAL','IN_ASSEMBLY','QUARANTINE') order by serial_number`, [org]),
    query<any>(`select id, code, name from equipment where org_id=$1 and status='ACTIVE' and (calibration_due is null or calibration_due >= current_date) order by code`, [org]),
  ]);
  return (
    <div className="space-y-6">
      <PageHeader title="Valve tests" subtitle="Pressure shell, seat/leak and functional tests recorded against the finished serial — append-only, retests keep the original" />
      <Flash error={sp.error} ok={sp.ok} />
      <Card>
        <CardHeader title="Record a test" subtitle="A failed test quarantines the valve and raises an NCR automatically" />
        <form action={recordTestAction} className="grid gap-3 p-5 md:grid-cols-4">
          <Field label="Valve (serial)"><select name="serial_unit_id" defaultValue={sp.unit} required className={inputCls}>{units.map((u: any) => <option key={u.id} value={u.id}>{u.serial_number} · {u.status.replace('_', ' ')}</option>)}</select></Field>
          <Field label="Test"><select name="test_type" className={inputCls}><option value="SHELL_PRESSURE">Shell pressure</option><option value="SEAT_LEAK">Seat / leak</option><option value="FUNCTIONAL">Functional</option></select></Field>
          <Field label="Test pressure (bar)"><input name="test_pressure_bar" type="number" step="0.1" className={inputCls} /></Field>
          <Field label="Hold (min)"><input name="hold_minutes" type="number" className={inputCls} /></Field>
          <Field label="Allowable"><input name="allowable" placeholder="e.g. No visible leakage" className={inputCls} /></Field>
          <Field label="Measured"><input name="measured" placeholder="e.g. 0 drops / min" className={inputCls} /></Field>
          <Field label="Test equipment"><select name="equipment_id" className={inputCls}><option value="">—</option>{equipment.map((e: any) => <option key={e.id} value={e.id}>{e.code} · {e.name}</option>)}</select></Field>
          <Field label="Result"><select name="result" className={inputCls}><option value="PASS">PASS</option><option value="FAIL">FAIL</option></select></Field>
          <Field label="Evidence / certificate ref"><input name="evidence_ref" placeholder="Chart / cert no." className={inputCls} /></Field>
          <div className="flex items-end md:col-span-3"><Button type="submit">Record test</Button></div>
        </form>
      </Card>
      <Card>
        <CardHeader title="Test register" />
        <Table><thead><tr><Th>Test</Th><Th>Valve</Th><Th>Type</Th><Th>Pressure</Th><Th>Allowable / measured</Th><Th>Equip.</Th><Th>Result</Th><Th>When</Th></tr></thead>
          <tbody>{tests.map((t: any) => (
            <tr key={t.id}><Td className="font-medium">{t.test_number}{t.retest_of && <div className="text-2xs text-faint">retest</div>}</Td><Td>{t.serial_number}</Td><Td>{t.test_type.replace('_', ' ')}</Td>
              <Td>{t.test_pressure_bar ? `${Number(t.test_pressure_bar)} bar${t.hold_minutes ? ` / ${t.hold_minutes} min` : ''}` : '—'}</Td>
              <Td className="text-xs">{t.allowable ?? '—'} → {t.measured ?? '—'}</Td><Td className="text-xs">{t.eq_code ?? '—'}</Td><Td><StatusPill status={t.result} /></Td><Td className="text-xs text-faint">{fmtDateTime(t.performed_at)}</Td></tr>))}</tbody></Table>
      </Card>
    </div>
  );
}
