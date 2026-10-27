import Link from 'next/link';
import { requireUser } from '@/server/auth/action';
import { query, one } from '@/server/db';
import { Card, Table, Th, Td, StatusPill, PageHeader, EmptyState, StatTile } from '@/components/ui';
import { formatMoney } from '@/lib/money';
import { fmtDate } from '@/lib/format';

export default async function InvoicesPage() {
  const user = await requireUser();
  const org = user.currentOrgId;
  const rows = await query<any>(
    `select i.id, i.invoice_number, c.name company, i.status, i.grand_total, i.paid_amount, i.currency, i.due_date
     from invoices i join companies c on c.id=i.company_id where i.org_id=$1 order by i.created_at desc limit 100`, [org]);
  const totals = await one<any>(`select coalesce(sum(grand_total),0) billed, coalesce(sum(paid_amount),0) paid, coalesce(sum(grand_total-paid_amount),0) outstanding from invoices where org_id=$1 and status not in ('CANCELLED','DRAFT')`, [org]);
  return (
    <div>
      <PageHeader title="Invoices" subtitle="Tax invoices, receivables and payments" />
      <div className="mb-5 grid grid-cols-1 gap-3 sm:grid-cols-3">
        <StatTile label="Billed" value={formatMoney(totals?.billed ?? 0)} />
        <StatTile label="Collected" value={formatMoney(totals?.paid ?? 0)} tone="ok" />
        <StatTile label="Outstanding" value={formatMoney(totals?.outstanding ?? 0)} tone="warn" />
      </div>
      <Card>
        {rows.length === 0 ? <EmptyState title="No invoices yet" hint="Generate a tax invoice from a delivered order." /> : (
          <Table>
            <thead><tr><Th>Invoice #</Th><Th>Customer</Th><Th>Status</Th><Th>Total</Th><Th>Paid</Th><Th>Due</Th></tr></thead>
            <tbody>{rows.map((r) => (
              <tr key={r.id} className="hover:bg-bg">
                <Td><Link href={`/invoices/${r.id}`} className="font-medium text-brand">{r.invoice_number}</Link></Td>
                <Td>{r.company}</Td><Td><StatusPill status={r.status} /></Td>
                <Td>{formatMoney(r.grand_total, r.currency)}</Td><Td>{formatMoney(r.paid_amount, r.currency)}</Td>
                <Td className="text-xs text-faint">{fmtDate(r.due_date)}</Td>
              </tr>
            ))}</tbody>
          </Table>
        )}
      </Card>
    </div>
  );
}
