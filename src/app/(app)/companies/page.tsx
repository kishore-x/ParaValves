import Link from 'next/link';
import { requireUser } from '@/server/auth/action';
import { query } from '@/server/db';
import { Card, Table, Th, Td, PageHeader, Button, EmptyState } from '@/components/ui';

export default async function CompaniesPage({ searchParams }: { searchParams: Promise<{ q?: string }> }) {
  const user = await requireUser();
  const { q } = await searchParams;
  const params: unknown[] = [user.currentOrgId];
  let where = 'org_id=$1 and archived_at is null';
  if (q) { params.push(`%${q}%`); where += ` and (name ilike $2 or company_number ilike $2)`; }
  const rows = await query<any>(
    `select id, company_number, name, is_customer, is_supplier, city, state_code, gstin from companies where ${where} order by name limit 100`, params);
  return (
    <div>
      <PageHeader title="Companies" subtitle="Customers and suppliers" action={<Button href="/companies/new">+ New Company</Button>} />
      <Card>
        {rows.length === 0 ? <EmptyState title="No companies" action={<Button href="/companies/new">+ New Company</Button>} /> : (
          <Table>
            <thead><tr><Th>Number</Th><Th>Name</Th><Th>Type</Th><Th>City</Th><Th>GSTIN</Th></tr></thead>
            <tbody>
              {rows.map((r) => (
                <tr key={r.id} className="hover:bg-bg">
                  <Td><Link href={`/companies/${r.id}`} className="font-medium text-brand">{r.company_number}</Link></Td>
                  <Td>{r.name}</Td>
                  <Td className="text-muted">{[r.is_customer && 'Customer', r.is_supplier && 'Supplier'].filter(Boolean).join(', ')}</Td>
                  <Td>{r.city ?? '—'}</Td>
                  <Td className="font-mono text-xs">{r.gstin ?? '—'}</Td>
                </tr>
              ))}
            </tbody>
          </Table>
        )}
      </Card>
    </div>
  );
}
