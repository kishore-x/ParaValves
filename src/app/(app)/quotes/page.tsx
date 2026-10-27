import Link from 'next/link';
import { requireUser } from '@/server/auth/action';
import { query } from '@/server/db';
import { Card, Table, Th, Td, StatusPill, PageHeader, Button, EmptyState } from '@/components/ui';
import { formatMoney } from '@/lib/money';
import { fmtDate } from '@/lib/format';

export default async function QuotesPage() {
  const user = await requireUser();
  const rows = await query<any>(
    `select q.id, q.quote_number, c.name company, q.status, q.grand_total, q.currency, q.created_at
     from quotations q join companies c on c.id=q.company_id
     where q.org_id=$1 order by q.created_at desc limit 100`, [user.currentOrgId]);
  return (
    <div>
      <PageHeader title="Quotations" subtitle="Create quotes without Excel" action={<Button href="/quotes/new">+ New Quotation</Button>} />
      <Card>
        {rows.length === 0 ? <EmptyState title="No quotations yet" hint="Create a quotation for a customer." action={<Button href="/quotes/new">+ New Quotation</Button>} /> : (
          <Table>
            <thead><tr><Th>Quote #</Th><Th>Customer</Th><Th>Status</Th><Th>Total</Th><Th>Created</Th></tr></thead>
            <tbody>{rows.map((r) => (
              <tr key={r.id} className="hover:bg-bg">
                <Td><Link href={`/quotes/${r.id}`} className="font-mono text-xs font-semibold text-brand">{r.quote_number}</Link></Td>
                <Td>{r.company}</Td><Td><StatusPill status={r.status} /></Td>
                <Td>{formatMoney(r.grand_total, r.currency)}</Td><Td className="text-xs text-faint">{fmtDate(r.created_at)}</Td>
              </tr>
            ))}</tbody>
          </Table>
        )}
      </Card>
    </div>
  );
}
