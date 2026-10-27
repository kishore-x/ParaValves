import Link from 'next/link';
import { requireUser } from '@/server/auth/action';
import { query } from '@/server/db';
import { Card, CardHeader, Table, Th, Td, StatusPill, PageHeader, EmptyState, StatTile } from '@/components/ui';
import { num } from '@/lib/format';

export default async function InventoryPage() {
  const user = await requireUser();
  const org = user.currentOrgId;
  const rows = await query<any>(
    `select p.id, p.product_code, p.name, p.uom, p.min_stock, p.reorder_point,
       coalesce(s.on_hand,0) on_hand, coalesce(s.reserved,0) reserved, coalesce(s.incoming,0) incoming
     from products p left join stock_items s on s.product_id=p.id
     where p.org_id=$1 and p.archived_at is null order by p.product_code`, [org]);
  const shortages = await query<any>(
    `select m.mr_number, pr.name product, m.required_qty, m.available_qty, m.incoming_qty, m.shortage_qty, m.status, so.order_number
     from material_requirements m join products pr on pr.id=m.product_id
     left join sales_orders so on so.id=m.sales_order_id
     where m.org_id=$1 and m.shortage_qty>0 and m.status='OPEN' order by m.shortage_qty desc`, [org]);

  const lowStock = rows.filter((r) => Number(r.on_hand) - Number(r.reserved) <= Number(r.reorder_point));

  return (
    <div>
      <PageHeader title="Inventory" subtitle="Real stock, movements and material intelligence" />
      <div className="mb-5 grid grid-cols-2 gap-3 sm:grid-cols-4">
        <StatTile label="Products tracked" value={rows.length} />
        <StatTile label="Low stock" value={lowStock.length} tone={lowStock.length ? 'warn' : 'ok'} />
        <StatTile label="Open shortages" value={shortages.length} tone={shortages.length ? 'danger' : 'ok'} />
        <StatTile label="Incoming lines" value={rows.filter((r) => Number(r.incoming) > 0).length} />
      </div>

      {shortages.length > 0 && (
        <Card className="mb-5">
          <CardHeader title="Material shortages" subtitle="Auto-detected — needs procurement" />
          <Table>
            <thead><tr><Th>MR #</Th><Th>Product</Th><Th>Order</Th><Th>Required</Th><Th>Available</Th><Th>Incoming</Th><Th>Shortage</Th></tr></thead>
            <tbody>{shortages.map((s, i) => (
              <tr key={i}><Td className="font-mono text-xs">{s.mr_number}</Td><Td>{s.product}</Td>
                <Td className="text-muted">{s.order_number ?? '—'}</Td><Td>{num(s.required_qty)}</Td>
                <Td>{num(s.available_qty)}</Td><Td>{num(s.incoming_qty)}</Td>
                <Td className="font-semibold text-danger">{num(s.shortage_qty)}</Td></tr>
            ))}</tbody>
          </Table>
        </Card>
      )}

      <Card>
        <CardHeader title="Stock levels" subtitle="Available = on hand − reserved" />
        {rows.length === 0 ? <EmptyState title="No products" /> : (
          <Table>
            <thead><tr><Th>Code</Th><Th>Product</Th><Th>On hand</Th><Th>Reserved</Th><Th>Available</Th><Th>Incoming</Th><Th>Signal</Th></tr></thead>
            <tbody>{rows.map((r) => {
              const avail = Number(r.on_hand) - Number(r.reserved);
              const low = avail <= Number(r.reorder_point);
              return (
                <tr key={r.id} className="hover:bg-bg">
                  <Td><Link href={`/products/${r.id}`} className="font-mono text-brand">{r.product_code}</Link></Td>
                  <Td>{r.name}</Td><Td>{num(r.on_hand)}</Td><Td>{num(r.reserved)}</Td>
                  <Td className="font-medium">{num(avail)}</Td><Td>{num(r.incoming)}</Td>
                  <Td>{low ? <StatusPill status="OPEN" /> : <span className="text-xs text-ok">OK</span>}</Td>
                </tr>
              );
            })}</tbody>
          </Table>
        )}
      </Card>
    </div>
  );
}
