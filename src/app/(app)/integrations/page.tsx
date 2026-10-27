import { requireUser } from '@/server/auth/action';
import { query } from '@/server/db';
import { Card, CardHeader, Table, Th, Td, StatusPill, PageHeader, Field, Button, inputCls, Badge } from '@/components/ui';
import { Flash } from '@/components/flash';
import { fmtDateTime } from '@/lib/format';
import { retryIntegrationAction, simulateIntegrationAction } from '../mfg-actions';

export default async function IntegrationsPage({ searchParams }: { searchParams: Promise<{ error?: string; ok?: string }> }) {
  const sp = await searchParams;
  const user = await requireUser();
  const rows = await query<any>(`select e.*, u.name owner from integration_events e left join users u on u.id=e.owner_id where e.org_id=$1 order by (e.status='FAILED') desc, e.created_at desc limit 60`, [user.currentOrgId]);
  const failed = rows.filter((r: any) => r.status === 'FAILED').length;
  return (
    <div className="space-y-6">
      <PageHeader title="Interfaces" subtitle={`Every interface message carries an idempotency key — retries can never create duplicates. ${failed} failed event(s) need attention.`} />
      <Flash error={sp.error} ok={sp.ok} />
      <Card>
        <CardHeader title="Interface log" />
        <Table><thead><tr><Th>System</Th><Th>Event</Th><Th>Reference / key</Th><Th>Status</Th><Th>Attempts</Th><Th>Error</Th><Th>Owner</Th><Th>When</Th><Th /></tr></thead>
          <tbody>{rows.map((e: any) => (
            <tr key={e.id}><Td><Badge>{e.system}</Badge></Td><Td>{e.event_type}</Td><Td className="font-mono text-xs">{e.idempotency_key}</Td><Td><StatusPill status={e.status} /></Td><Td>{e.attempts}</Td><Td className="max-w-xs text-xs text-danger">{e.error}</Td><Td className="text-xs">{e.owner ?? <span className="text-warn">unassigned</span>}</Td><Td className="text-xs text-faint">{fmtDateTime(e.created_at)}</Td>
              <Td>{e.status === 'FAILED' && <form action={retryIntegrationAction}><input type="hidden" name="id" value={e.id} /><Button type="submit" size="sm">Safe retry</Button></form>}</Td></tr>))}</tbody></Table>
      </Card>
      <Card>
        <CardHeader title="Try it: post an event" subtitle="Submit the same key twice — the second is rejected as a duplicate" />
        <form action={simulateIntegrationAction} className="grid gap-3 p-5 md:grid-cols-5">
          <Field label="System"><select name="system" className={inputCls}><option>ACCOUNTING</option><option>WEBSITE</option><option>EMAIL</option><option>CUSTOMER_PORTAL</option><option>SUPPLIER_EDI</option></select></Field>
          <Field label="Idempotency key"><input name="key" required defaultValue={`INV-DEMO-${Date.now().toString().slice(-5)}`} className={inputCls} /></Field>
          <label className="flex items-end gap-2 pb-2 text-sm"><input type="checkbox" name="fail" />Simulate failure</label>
          <div className="flex items-end"><Button type="submit">Send event</Button></div>
        </form>
      </Card>
    </div>
  );
}
