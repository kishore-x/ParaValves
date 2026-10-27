import Link from 'next/link';
import { requireUser } from '@/server/auth/action';
import { query } from '@/server/db';
import { Card, Table, Th, Td, StatusPill, PageHeader, EmptyState } from '@/components/ui';
import { formatMoney } from '@/lib/money';
import { fmtDate } from '@/lib/format';

export default async function OrdersPage() {
  const user = await requireUser();
  const rows = await query<any>(
    `select o.id, o.order_number, c.name company, o.status, o.grand_total, o.currency, o.delivery_date, o.created_at
     from sales_orders o join companies c on c.id=o.company_id
     where o.org_id=$1 order by o.created_at desc limit 100`, [user.currentOrgId]);
  return (
    <div>
      <PageHeader title="Sales Orders" subtitle="From confirmed order to closure" />
      <Card>
        {rows.length === 0 ? <EmptyState title="No sales orders yet" hint="Accept a quotation and convert it to an order." /> : (
          <Table>
            <thead><tr><Th>Order #</Th><Th>Customer</Th><Th>Status</Th><Th>Total</Th><Th>Delivery</Th></tr></thead>
            <tbody>{rows.map((r) => (
              <tr key={r.id} className="hover:bg-bg">
                <Td><Link href={`/orders/${r.id}`} className="font-mono text-xs font-semibold text-brand">{r.order_number}</Link></Td>
                <Td>{r.company}</Td><Td><StatusPill status={r.status} /></Td>
                <Td>{formatMoney(r.grand_total, r.currency)}</Td><Td className="text-xs text-faint">{fmtDate(r.delivery_date)}</Td>
              </tr>
            ))}</tbody>
          </Table>
        )}
      </Card>
    </div>
  );
}
