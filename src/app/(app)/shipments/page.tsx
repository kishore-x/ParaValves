import Link from 'next/link';
import { requireUser } from '@/server/auth/action';
import { query } from '@/server/db';
import { Card, CardHeader, Table, Th, Td, StatusPill, PageHeader, Field, Button, inputCls, Badge, EmptyState } from '@/components/ui';
import { Flash } from '@/components/flash';
import { fmtDate } from '@/lib/format';
import { newShipmentAction } from '../mfg-actions';

export default async function ShipmentsPage({ searchParams }: { searchParams: Promise<{ error?: string; ok?: string }> }) {
  const sp = await searchParams;
  const user = await requireUser();
  const org = user.currentOrgId;
  const [rows, avail] = await Promise.all([
    query<any>(`select s.*, so.order_number, co.name customer, (select count(*) from shipment_lines l where l.shipment_id=s.id)::int units from shipments s join sales_orders so on so.id=s.sales_order_id join companies co on co.id=so.company_id where s.org_id=$1 order by s.created_at desc`, [org]),
    query<any>(`select u.id, u.serial_number, u.status, so.id order_id, so.order_number, co.name customer from serial_units u join sales_orders so on so.id=u.sales_order_id join companies co on co.id=so.company_id
       where u.org_id=$1 and u.status in ('RELEASED','AWAITING_FINAL','QUARANTINE','IN_ASSEMBLY') and not exists (select 1 from shipment_lines l where l.serial_unit_id=u.id) order by so.order_number, u.serial_number`, [org]),
  ]);
  const byOrder = new Map<string, any[]>();
  for (const u of avail) { const k = `${u.order_id}|${u.order_number} · ${u.customer}`; byOrder.set(k, [...(byOrder.get(k) ?? []), u]); }
  return (
    <div className="space-y-6">
      <PageHeader title="Dispatch" subtitle="Pick & pack only quality-released units; credit, export and document gates are enforced" />
      <Flash error={sp.error} ok={sp.ok} />
      <Card>
        <CardHeader title={`Shipments (${rows.length})`} />
        {rows.length === 0 ? <EmptyState title="No shipments" /> : (
          <Table><thead><tr><Th>Shipment</Th><Th>Order</Th><Th>Customer</Th><Th>Units</Th><Th>Type</Th><Th>Status</Th><Th>Shipped</Th></tr></thead>
            <tbody>{rows.map((s: any) => (
              <tr key={s.id} className="hover:bg-bg align-top"><Td><Link href={`/shipments/${s.id}`} className="font-medium text-brand">{s.shipment_number}</Link></Td><Td>{s.order_number}</Td><Td>{s.customer}</Td><Td>{s.units}</Td>
                <Td>{s.is_partial ? <Badge tone="warn">partial</Badge> : <Badge>full</Badge>}</Td><Td><StatusPill status={s.status} />{s.block_reason && <div className="mt-1 max-w-md text-2xs text-danger">{s.block_reason}</div>}</Td><Td className="text-xs">{fmtDate(s.shipped_at)}</Td></tr>))}</tbody></Table>)}
      </Card>
      <Card>
        <CardHeader title="Pack a shipment" subtitle="Select units for one order. Units not yet released will block dispatch — shown so the owner can resolve it." />
        {byOrder.size === 0 ? <EmptyState title="No unshipped units" /> : [...byOrder.entries()].map(([k, units]) => { const [oid, label] = k.split('|'); return (
          <form key={k} action={newShipmentAction} className="border-b border-line px-5 py-4 last:border-0">
            <input type="hidden" name="sales_order_id" value={oid} />
            <p className="mb-2 text-sm font-medium">{label}</p>
            <div className="mb-3 flex flex-wrap gap-3">{units.map((u: any) => <label key={u.id} className="flex items-center gap-1.5 rounded-md border border-line px-2 py-1 text-xs"><input type="checkbox" name="unit" value={u.id} />{u.serial_number} <StatusPill status={u.status} /></label>)}</div>
            <Button type="submit" size="sm">Create shipment</Button>
          </form>); })}
      </Card>
    </div>
  );
}
