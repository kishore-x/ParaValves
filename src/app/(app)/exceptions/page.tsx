import { requireUser } from '@/server/auth/action';
import { query } from '@/server/db';
import { Card, CardHeader, Table, Th, Td, StatusPill, PageHeader, Field, Button, inputCls, Badge, EmptyState } from '@/components/ui';
import { Flash } from '@/components/flash';
import { fmtDate } from '@/lib/format';
import { newExceptionAction, resolveExceptionAction } from '../mfg-actions';

const TYPES: Record<string, string> = { SPEC_CHANGE: 'Incomplete / changed specification', MATERIAL_SHORTAGE: 'Material shortage', LATE_SUPPLIER: 'Late supplier', SHIPMENT_BLOCK: 'Shipment block', OTHER: 'Other' };
const ACTIONS: Record<string, string[]> = {
  SPEC_CHANGE: ['CLARIFICATION', 'DATE_CHANGE'], MATERIAL_SHORTAGE: ['EXPEDITE', 'ALTERNATE', 'DATE_CHANGE'], LATE_SUPPLIER: ['EXPEDITE', 'ALTERNATE', 'DATE_CHANGE'], SHIPMENT_BLOCK: ['CLARIFICATION', 'DATE_CHANGE'], OTHER: ['OTHER'],
};

export default async function ExceptionsPage({ searchParams }: { searchParams: Promise<{ error?: string; ok?: string }> }) {
  const sp = await searchParams;
  const user = await requireUser();
  const org = user.currentOrgId;
  const [rows, orders, shortages, failedTests, mismatches] = await Promise.all([
    query<any>(`select e.*, so.order_number, u.name owner from order_exceptions e left join sales_orders so on so.id=e.sales_order_id left join users u on u.id=e.owner_id where e.org_id=$1 order by (e.status='RESOLVED'), e.created_at desc`, [org]),
    query<any>(`select id, order_number from sales_orders where org_id=$1 and status not in ('CLOSED','CANCELLED') order by order_number`, [org]),
    query<any>(`select m.shortage_qty, p.name pname, so.order_number, so.delivery_date from material_requirements m join products p on p.id=m.product_id left join sales_orders so on so.id=m.sales_order_id where m.org_id=$1 and m.status='OPEN' and m.shortage_qty>0 limit 8`, [org]),
    query<any>(`select count(*)::int n from nonconformances where org_id=$1 and status in ('OPEN','PENDING_APPROVAL')`, [org]),
    query<any>(`select count(*)::int n from subcontract_orders where org_id=$1 and status='MISMATCH'`, [org]),
  ]);
  const open = rows.filter((r: any) => r.status !== 'RESOLVED');
  return (
    <div className="space-y-6">
      <PageHeader title="Exceptions control tower" subtitle="Every exception has an owner, a reason and a controlled resolution" />
      <Flash error={sp.error} ok={sp.ok} />
      <div className="grid gap-3 md:grid-cols-4">
        <Card className="p-4"><p className="text-xs text-muted">Open exceptions</p><p className="text-2xl font-semibold">{open.length}</p></Card>
        <Card className="p-4"><p className="text-xs text-muted">Material shortages</p><p className="text-2xl font-semibold text-warn">{shortages.length}</p></Card>
        <Card className="p-4"><p className="text-xs text-muted">Open NCRs (failed inspection/test)</p><p className="text-2xl font-semibold text-danger">{failedTests[0].n}</p></Card>
        <Card className="p-4"><p className="text-xs text-muted">Subcontract mismatches</p><p className="text-2xl font-semibold text-danger">{mismatches[0].n}</p></Card>
      </div>
      {shortages.length > 0 && (
        <Card><CardHeader title="Material shortages affecting orders" subtitle="From planning — raise an exception to assign a buyer action" />
          <Table><thead><tr><Th>Order</Th><Th>Material</Th><Th>Shortfall</Th><Th>Due</Th></tr></thead><tbody>{shortages.map((s: any, i: number) => <tr key={i}><Td>{s.order_number ?? '—'}</Td><Td>{s.pname}</Td><Td className="font-semibold text-warn">{Number(s.shortage_qty)}</Td><Td className="text-xs">{fmtDate(s.delivery_date)}</Td></tr>)}</tbody></Table></Card>)}
      <Card>
        <CardHeader title={`Exceptions (${rows.length})`} />
        {rows.length === 0 ? <EmptyState title="No exceptions" /> : (
          <Table><thead><tr><Th>No.</Th><Th>Type</Th><Th>Order</Th><Th>Description</Th><Th>Owner</Th><Th>Status / resolution</Th></tr></thead>
            <tbody>{rows.map((e: any) => (
              <tr key={e.id} className="align-top"><Td className="font-medium">{e.exception_no}<div className="text-2xs text-faint">{fmtDate(e.created_at)}</div></Td><Td><Badge tone="warn">{TYPES[e.type] ?? e.type}</Badge></Td><Td>{e.order_number ?? '—'}</Td><Td className="max-w-md text-xs">{e.description}</Td><Td className="text-xs">{e.owner}</Td>
                <Td>{e.status === 'RESOLVED' ? <div className="text-xs"><StatusPill status="RESOLVED" /><div className="mt-1 text-muted">{e.action_taken}{e.new_promise_date && ` → new date ${fmtDate(e.new_promise_date)}`}</div></div> : (
                  <form action={resolveExceptionAction} className="flex flex-wrap items-center gap-1.5"><input type="hidden" name="id" value={e.id} />
                    <select name="action_taken" className={`${inputCls} !h-8 !w-36`}>{(ACTIONS[e.type] ?? ['OTHER']).map((a) => <option key={a}>{a}</option>)}</select><input name="new_promise_date" type="date" className={`${inputCls} !h-8 !w-36`} /><Button type="submit" size="sm">Resolve</Button></form>)}</Td></tr>))}</tbody></Table>)}
      </Card>
      <Card>
        <CardHeader title="Raise an exception" />
        <form action={newExceptionAction} className="grid gap-3 p-5 md:grid-cols-4">
          <Field label="Type"><select name="type" className={inputCls}>{Object.entries(TYPES).map(([k, v]) => <option key={k} value={k}>{v}</option>)}</select></Field>
          <Field label="Order"><select name="sales_order_id" className={inputCls}><option value="">—</option>{orders.map((o: any) => <option key={o.id} value={o.id}>{o.order_number}</option>)}</select></Field>
          <Field label="Description"><input name="description" required className={inputCls} /></Field>
          <div className="flex items-end"><Button type="submit">Raise</Button></div>
        </form>
      </Card>
    </div>
  );
}
