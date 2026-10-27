import Link from 'next/link';
import { requireUser } from '@/server/auth/action';
import { query } from '@/server/db';
import { Card, CardHeader, Table, Th, Td, StatusPill, PageHeader, Button, EmptyState, Field, inputCls } from '@/components/ui';
import { fmtDate } from '@/lib/format';
import { newDrawingAction } from './actions';

export default async function EngineeringPage() {
  const user = await requireUser();
  const drawings = await query<any>(`select id, drawing_number, title, status, current_revision, created_at from drawings where org_id=$1 order by created_at desc limit 100`, [user.currentOrgId]);
  const orders = await query<any>(`select id, order_number from sales_orders where org_id=$1 and status not in ('CLOSED','CANCELLED') order by created_at desc limit 50`, [user.currentOrgId]);
  return (
    <div>
      <PageHeader title="Engineering" subtitle="Drawings, revisions and approvals" />
      <div className="grid gap-5 lg:grid-cols-3">
        <div className="lg:col-span-2">
          <Card>
            <CardHeader title="Drawings" />
            {drawings.length === 0 ? <EmptyState title="No drawings yet" /> : (
              <Table>
                <thead><tr><Th>Drawing #</Th><Th>Title</Th><Th>Rev</Th><Th>Status</Th><Th>Created</Th></tr></thead>
                <tbody>{drawings.map((d) => (
                  <tr key={d.id} className="hover:bg-bg">
                    <Td><Link href={`/engineering/${d.id}`} className="font-medium text-brand">{d.drawing_number}</Link></Td>
                    <Td>{d.title}</Td><Td>R{d.current_revision}</Td><Td><StatusPill status={d.status} /></Td>
                    <Td className="text-xs text-faint">{fmtDate(d.created_at)}</Td>
                  </tr>
                ))}</tbody>
              </Table>
            )}
          </Card>
        </div>
        <Card>
          <CardHeader title="New drawing" />
          <form action={newDrawingAction} className="space-y-3 p-5">
            <Field label="Title" required><input name="title" required className={inputCls} /></Field>
            <Field label="Sales order (optional)">
              <select name="sales_order_id" className={inputCls}><option value="">—</option>{orders.map((o) => <option key={o.id} value={o.id}>{o.order_number}</option>)}</select>
            </Field>
            <Button type="submit">Create Drawing</Button>
          </form>
        </Card>
      </div>
    </div>
  );
}
