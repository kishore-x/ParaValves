import Link from 'next/link';
import { requireUser } from '@/server/auth/action';
import { query } from '@/server/db';
import { Card, Table, Th, Td, StatusPill, PageHeader, Button, EmptyState } from '@/components/ui';
import { formatMoney } from '@/lib/money';
import { fmtDate } from '@/lib/format';

export default async function ProcurementPage() {
  const user = await requireUser();
  const rows = await query<any>(
    `select po.id, po.po_number, c.name supplier, po.status, po.grand_total, po.expected_date, po.created_at
     from purchase_orders po join companies c on c.id=po.supplier_id
     where po.org_id=$1 order by po.created_at desc limit 100`, [user.currentOrgId]);
  return (
    <div>
      <PageHeader title="Procurement" subtitle="Purchase orders and goods receipt" action={<Button href="/procurement/new">+ New Purchase Order</Button>} />
      <Card>
        {rows.length === 0 ? <EmptyState title="No purchase orders" hint="Raise a PO to cover material shortages." action={<Button href="/procurement/new">+ New Purchase Order</Button>} /> : (
          <Table>
            <thead><tr><Th>PO #</Th><Th>Supplier</Th><Th>Status</Th><Th>Total</Th><Th>Expected</Th></tr></thead>
            <tbody>{rows.map((r) => (
              <tr key={r.id} className="hover:bg-bg">
                <Td><Link href={`/procurement/${r.id}`} className="font-mono text-xs font-semibold text-brand">{r.po_number}</Link></Td>
                <Td>{r.supplier}</Td><Td><StatusPill status={r.status} /></Td>
                <Td>{formatMoney(r.grand_total)}</Td><Td className="text-xs text-faint">{fmtDate(r.expected_date)}</Td>
              </tr>
            ))}</tbody>
          </Table>
        )}
      </Card>
    </div>
  );
}
