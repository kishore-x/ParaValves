import { requireUser } from '@/server/auth/action';
import { query } from '@/server/db';
import { Card, Table, Th, Td, PageHeader, EmptyState } from '@/components/ui';
import { formatMoney } from '@/lib/money';
import { fmtDate } from '@/lib/format';

export default async function PaymentsPage() {
  const user = await requireUser();
  const rows = await query<any>(
    `select p.payment_number, c.name company, p.amount, p.currency, p.method, p.reference, p.paid_at
     from payments p left join companies c on c.id=p.company_id where p.org_id=$1 order by p.created_at desc limit 100`, [user.currentOrgId]);
  return (
    <div>
      <PageHeader title="Payments" subtitle="Receipts recorded against invoices" />
      <Card>
        {rows.length === 0 ? <EmptyState title="No payments recorded" /> : (
          <Table>
            <thead><tr><Th>Payment #</Th><Th>Customer</Th><Th>Amount</Th><Th>Method</Th><Th>Reference</Th><Th>Date</Th></tr></thead>
            <tbody>{rows.map((r, i) => (
              <tr key={i}><Td className="font-mono text-brand">{r.payment_number}</Td><Td>{r.company ?? '—'}</Td>
                <Td className="font-medium">{formatMoney(r.amount, r.currency)}</Td><Td>{r.method ?? '—'}</Td>
                <Td>{r.reference ?? '—'}</Td><Td className="text-xs text-faint">{fmtDate(r.paid_at)}</Td></tr>
            ))}</tbody>
          </Table>
        )}
      </Card>
    </div>
  );
}
