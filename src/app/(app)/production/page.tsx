import Link from 'next/link';
import { requireUser } from '@/server/auth/action';
import { query } from '@/server/db';
import { Card, CardHeader, Table, Th, Td, StatusPill, PageHeader, Field, Button, inputCls, EmptyState } from '@/components/ui';
import { Flash } from '@/components/flash';
import { fmtDate } from '@/lib/format';
import { newWorkOrderAction } from '../mfg-actions';

export default async function ProductionPage({ searchParams }: { searchParams: Promise<{ error?: string; ok?: string }> }) {
  const sp = await searchParams;
  const user = await requireUser();
  const org = user.currentOrgId;
  const [rows, products, orders] = await Promise.all([
    query<any>(`select w.*, p.name pname, so.order_number,
        (select count(*) filter (where status='DONE') from work_order_operations o where o.work_order_id=w.id)::int done_ops,
        (select count(*) from work_order_operations o where o.work_order_id=w.id)::int total_ops
      from work_orders w join products p on p.id=w.product_id left join sales_orders so on so.id=w.sales_order_id where w.org_id=$1 order by w.created_at desc`, [org]),
    query<any>(`select id, product_code, name from products where org_id=$1 and is_manufactured=true order by product_code`, [org]),
    query<any>(`select id, order_number from sales_orders where org_id=$1 and status not in ('CLOSED','CANCELLED') order by created_at desc`, [org]),
  ]);
  return (
    <div className="space-y-6">
      <PageHeader title="Production" subtitle="Controlled release, operation progress, material lots, scrap/rework and downtime" />
      <Flash error={sp.error} ok={sp.ok} />
      <Card>
        <CardHeader title={`Work orders (${rows.length})`} />
        {rows.length === 0 ? <EmptyState title="No work orders" hint="Create one below from a sales order." /> : (
          <Table><thead><tr><Th>WO</Th><Th>Product</Th><Th>Order</Th><Th>Qty</Th><Th>Progress</Th><Th>Due</Th><Th>Status</Th></tr></thead>
            <tbody>{rows.map((w: any) => (
              <tr key={w.id} className="hover:bg-bg"><Td><Link href={`/production/${w.id}`} className="font-medium text-brand">{w.wo_number}</Link></Td><Td>{w.pname}</Td><Td>{w.order_number ?? '—'}</Td><Td>{Number(w.quantity)}</Td>
                <Td><div className="flex items-center gap-2"><div className="h-1.5 w-24 rounded bg-bg ring-1 ring-line"><div className="h-full rounded bg-brand" style={{ width: `${w.total_ops ? (w.done_ops / w.total_ops) * 100 : 0}%` }} /></div><span className="text-2xs text-muted">{w.done_ops}/{w.total_ops} ops</span></div></Td>
                <Td className="text-xs">{fmtDate(w.due_date)}</Td><Td><StatusPill status={w.status} /></Td></tr>))}</tbody></Table>)}
      </Card>
      <Card>
        <CardHeader title="New work order" subtitle="Generates the standard valve routing, including the subcontract heat-treatment step" />
        <form action={newWorkOrderAction} className="grid gap-3 p-5 md:grid-cols-5">
          <Field label="Product"><select name="product_id" required className={inputCls}>{products.map((p: any) => <option key={p.id} value={p.id}>{p.product_code} · {p.name}</option>)}</select></Field>
          <Field label="Sales order"><select name="sales_order_id" className={inputCls}><option value="">— stock build —</option>{orders.map((o: any) => <option key={o.id} value={o.id}>{o.order_number}</option>)}</select></Field>
          <Field label="Quantity"><input name="quantity" type="number" min="1" defaultValue={5} required className={inputCls} /></Field>
          <Field label="Due date"><input name="due_date" type="date" className={inputCls} /></Field>
          <div className="flex items-end"><Button type="submit">Create</Button></div>
        </form>
      </Card>
    </div>
  );
}
