import { notFound } from 'next/navigation';
import { requireUser } from '@/server/auth/action';
import { one, query } from '@/server/db';
import { shipmentGates } from '@/server/domain/shipping';
import { Card, CardHeader, Table, Th, Td, StatusPill, PageHeader, Button, inputCls, Badge } from '@/components/ui';
import { Flash } from '@/components/flash';
import { fmtDateTime } from '@/lib/format';
import { shipmentDocsAction, shipAction } from '../../mfg-actions';

export default async function ShipmentPage({ params, searchParams }: { params: Promise<{ id: string }>; searchParams: Promise<{ error?: string; ok?: string }> }) {
  const { id } = await params; const sp = await searchParams;
  const user = await requireUser();
  const s = await one<any>(`select s.*, so.order_number, so.id order_id, co.name customer from shipments s join sales_orders so on so.id=s.sales_order_id join companies co on co.id=so.company_id where s.id=$1 and s.org_id=any($2)`, [id, user.orgIds]);
  if (!s) notFound();
  const [units, gates, bal] = await Promise.all([
    query<any>(`select u.id, u.serial_number, u.tag_number, u.status, p.name pname from shipment_lines l join serial_units u on u.id=l.serial_unit_id join products p on p.id=u.product_id where l.shipment_id=$1`, [id]),
    shipmentGates({ one, query }, id),
    one<any>(`select (select coalesce(sum(quantity),0) from sales_order_lines where sales_order_id=$1) ordered, (select coalesce(sum(delivered_qty),0) from sales_order_lines where sales_order_id=$1) delivered`, [s.order_id]),
  ]);
  const docs = s.docs ?? {};
  const shipped = s.status === 'SHIPPED';
  return (
    <div className="space-y-6">
      <PageHeader title={`${s.shipment_number} · ${s.customer}`} subtitle={<span>Order {s.order_number} · {s.is_partial ? 'partial shipment' : 'complete shipment'} · <StatusPill status={s.status} /></span>}
        action={<div className="flex gap-2">{!shipped && <form action={shipAction}><input type="hidden" name="id" value={id} /><Button type="submit">Dispatch</Button></form>}<Button href="/shipments" variant="ghost">Back</Button></div>} />
      <Flash error={sp.error} ok={sp.ok} />
      <Card>
        <CardHeader title="Release gates" subtitle="Dispatch is blocked until every gate passes — each failure names its owner" />
        <Table><thead><tr><Th>Gate</Th><Th>Status</Th><Th>Detail</Th><Th>Owner</Th></tr></thead>
          <tbody>{gates.map((g) => <tr key={g.key}><Td className="font-medium">{g.label}</Td><Td><StatusPill status={g.ok ? 'PASSED' : 'BLOCKED'} /></Td><Td className="text-xs">{g.reason}</Td><Td>{g.ok ? '—' : <Badge tone="warn">{g.owner}</Badge>}</Td></tr>)}</tbody></Table>
      </Card>
      <div className="grid gap-6 lg:grid-cols-2">
        <Card>
          <CardHeader title="Units" subtitle={`Order balance: ${Number(bal.delivered)} delivered of ${Number(bal.ordered)} ordered`} />
          <Table><thead><tr><Th>Serial</Th><Th>Tag</Th><Th>Product</Th><Th>Status</Th></tr></thead>
            <tbody>{units.map((u: any) => <tr key={u.id}><Td className="font-medium">{u.serial_number}</Td><Td>{u.tag_number ?? '—'}</Td><Td>{u.pname}</Td><Td><StatusPill status={u.status} /></Td></tr>)}</tbody></Table>
        </Card>
        <Card>
          <CardHeader title="Documents & carrier" subtitle={shipped ? `Shipped ${fmtDateTime(s.shipped_at)}` : undefined} />
          <form action={shipmentDocsAction} className="space-y-3 p-5">
            <input type="hidden" name="id" value={id} />
            {([['packing_list', 'Packing list'], ['mtc', 'Material & test certificates attached'], ['export_docs', 'Export documents (commercial invoice, COO, shipping bill)']] as const).map(([k, label]) => (
              <label key={k} className="flex items-center gap-2 text-sm"><input type="checkbox" name={k} defaultChecked={!!docs[k]} disabled={shipped} />{label}</label>))}
            <input name="carrier" defaultValue={s.carrier ?? ''} placeholder="Carrier" className={inputCls} disabled={shipped} />
            {!shipped && <Button type="submit" size="sm" variant="ghost">Save documents</Button>}
          </form>
        </Card>
      </div>
    </div>
  );
}
