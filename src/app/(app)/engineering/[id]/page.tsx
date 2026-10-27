import Link from 'next/link';
import { notFound } from 'next/navigation';
import { requireUser } from '@/server/auth/action';
import { one, query } from '@/server/db';
import { DRAWING } from '@/server/workflow/machines';
import { Card, CardHeader, PageHeader, StatusPill, Table, Th, Td, Button, Field, inputCls } from '@/components/ui';
import { ActivityTimeline } from '@/components/timeline';
import { fmtDateTime } from '@/lib/format';
import { transitionDrawingAction, newRevisionAction } from '../actions';

export default async function DrawingDetail({ params }: { params: Promise<{ id: string }> }) {
  const user = await requireUser();
  const { id } = await params;
  const dr = await one<any>(`select d.*, so.order_number, so.id order_id from drawings d left join sales_orders so on so.id=d.sales_order_id where d.id=$1 and d.org_id=any($2)`, [id, user.orgIds]);
  if (!dr) notFound();
  const revs = await query<any>(`select r.*, u.name uploaded_name, a.name approved_name from drawing_revisions r left join users u on u.id=r.uploaded_by left join users a on a.id=r.approved_by where r.drawing_id=$1 order by revision desc`, [id]);
  const next = DRAWING[dr.status] ?? [];
  return (
    <div>
      <PageHeader title={dr.drawing_number} subtitle={dr.title} action={<StatusPill status={dr.status} />} />
      <div className="grid gap-5 lg:grid-cols-3">
        <div className="space-y-5 lg:col-span-2">
          <Card>
            <CardHeader title="Revision history" subtitle="Previous revisions are never destroyed" action={<form action={newRevisionAction}><input type="hidden" name="id" value={dr.id} /><Button type="submit" size="sm" variant="ghost">+ New revision</Button></form>} />
            <Table>
              <thead><tr><Th>Rev</Th><Th>Status</Th><Th>Uploaded by</Th><Th>Approved by</Th><Th>Approved at</Th></tr></thead>
              <tbody>{revs.map((r) => (
                <tr key={r.id}><Td>R{r.revision}</Td><Td><StatusPill status={r.status} /></Td>
                  <Td>{r.uploaded_name ?? '—'}</Td><Td>{r.approved_name ?? '—'}</Td><Td className="text-xs text-faint">{r.approved_at ? fmtDateTime(r.approved_at) : '—'}</Td></tr>
              ))}</tbody>
            </Table>
          </Card>
          {dr.order_id && <p className="text-sm text-muted">Linked order: <Link href={`/orders/${dr.order_id}`} className="text-brand">{dr.order_number}</Link></p>}
          {next.length > 0 && (
            <Card>
              <CardHeader title="Approval workflow" subtitle={`Current: ${dr.status.replace(/_/g,' ')}`} />
              <form action={transitionDrawingAction} className="flex items-end gap-3 p-5">
                <input type="hidden" name="id" value={dr.id} /><input type="hidden" name="version" value={dr.version} />
                <div className="w-60"><Field label="Move to"><select name="to" className={inputCls}>{next.map((s) => <option key={s} value={s}>{s.replace(/_/g,' ')}</option>)}</select></Field></div>
                <Button type="submit">Update</Button>
              </form>
            </Card>
          )}
        </div>
        <ActivityTimeline entityType="drawing" entityId={dr.id} />
      </div>
    </div>
  );
}
