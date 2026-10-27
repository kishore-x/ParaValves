import { requireUser } from '@/server/auth/action';
import { query } from '@/server/db';
import { Card, CardHeader, Table, Th, Td, StatusPill, PageHeader, Button, Field, inputCls, EmptyState, Badge } from '@/components/ui';
import { Flash } from '@/components/flash';
import { fmtDate } from '@/lib/format';
import { newNcrAction, proposeDispositionAction, closeNcrAction } from '../../mfg-actions';

export default async function NcrPage({ searchParams }: { searchParams: Promise<{ error?: string; ok?: string }> }) {
  const sp = await searchParams;
  const user = await requireUser();
  const rows = await query<any>(
    `select n.*, r.name raised_name, a.name approver from nonconformances n left join users r on r.id=n.raised_by left join users a on a.id=n.approved_by
     where n.org_id=$1 order by case n.status when 'OPEN' then 0 when 'PENDING_APPROVAL' then 1 when 'APPROVED' then 2 else 3 end, n.created_at desc`, [user.currentOrgId]);
  return (
    <div className="space-y-6">
      <PageHeader title="Non-conformances" subtitle="Quarantine → disposition (rework / scrap / concession / retest) → maker-checker approval → close" action={<Button href="/approvals" variant="ghost">Approval queue</Button>} />
      <Flash error={sp.error} ok={sp.ok} />
      <Card>
        <CardHeader title={`NCR register (${rows.length})`} />
        {rows.length === 0 ? <EmptyState title="No non-conformances" hint="A failed inspection or test raises one automatically." /> : (
          <Table><thead><tr><Th>NCR</Th><Th>Source</Th><Th>Description</Th><Th>Status</Th><Th>Disposition</Th><Th>Action</Th></tr></thead>
            <tbody>{rows.map((n: any) => (
              <tr key={n.id} className="align-top">
                <Td className="font-medium">{n.ncr_number}<div className="text-2xs text-faint">{fmtDate(n.created_at)} · {n.raised_name}</div></Td>
                <Td><Badge>{n.source_type}</Badge><div className="mt-1 text-xs text-muted">{n.source_label}</div></Td>
                <Td className="max-w-sm text-xs">{n.description}</Td>
                <Td><StatusPill status={n.status} /></Td>
                <Td className="text-xs">{n.disposition ?? '—'}{n.approver && <div className="text-faint">approved by {n.approver}</div>}</Td>
                <Td>
                  {n.status === 'OPEN' && (
                    <form action={proposeDispositionAction} className="flex flex-col gap-1.5">
                      <input type="hidden" name="id" value={n.id} />
                      <select name="disposition" className={`${inputCls} !h-8`}><option>REWORK</option><option>SCRAP</option><option>CONCESSION</option><option>RETEST</option><option>RETURN_TO_SUPPLIER</option></select>
                      <input name="note" placeholder="Justification" className={`${inputCls} !h-8`} />
                      <Button type="submit" size="sm">Propose disposition</Button>
                    </form>)}
                  {n.status === 'PENDING_APPROVAL' && <span className="text-xs text-muted">Waiting for a checker in Approvals</span>}
                  {n.status === 'APPROVED' && <form action={closeNcrAction}><input type="hidden" name="id" value={n.id} /><Button type="submit" size="sm" variant="ghost">Close NCR</Button></form>}
                </Td>
              </tr>))}</tbody></Table>)}
      </Card>
      <Card>
        <CardHeader title="Raise a non-conformance manually" />
        <form action={newNcrAction} className="grid gap-3 p-5 md:grid-cols-4">
          <Field label="Source"><select name="source_type" className={inputCls}><option>LOT</option><option>WORK_ORDER</option><option>SERIAL</option></select></Field>
          <Field label="Reference"><input name="source_label" required placeholder="Lot / WO / serial" className={inputCls} /></Field>
          <Field label="Qty"><input name="quantity" type="number" min="1" defaultValue={1} className={inputCls} /></Field>
          <Field label="Description"><input name="description" required className={inputCls} /></Field>
          <div className="md:col-span-4"><Button type="submit" size="sm">Raise NCR</Button></div>
        </form>
      </Card>
    </div>
  );
}
