import Link from 'next/link';
import { requireUser } from '@/server/auth/action';
import { query } from '@/server/db';
import { Card, Table, Th, Td, StatusPill, PageHeader, Button, EmptyState } from '@/components/ui';
import { fromNow, fmtDate } from '@/lib/format';
import { formatMoney } from '@/lib/money';

const PIPELINE = ['NEW', 'CONTACTED', 'QUALIFIED', 'MEETING', 'QUOTATION', 'NEGOTIATION', 'WON', 'LOST'];

export default async function LeadsPage({ searchParams }: { searchParams: Promise<{ status?: string; q?: string }> }) {
  const user = await requireUser();
  const { status, q } = await searchParams;
  const where: string[] = ['org_id = $1'];
  const params: unknown[] = [user.currentOrgId];
  if (status && PIPELINE.includes(status)) { params.push(status); where.push(`status = $${params.length}`); }
  if (q) { params.push(`%${q}%`); where.push(`(company_name ilike $${params.length} or lead_number ilike $${params.length})`); }

  const leads = await query<{ id: string; lead_number: string; company_name: string; status: string; priority: string; expected_value: string | null; created_at: Date; owner: string | null }>(
    `select l.id, l.lead_number, l.company_name, l.status, l.priority, l.expected_value, l.created_at, u.name owner
     from leads l left join users u on u.id=l.owner_id
     where ${where.join(' and ')} order by l.created_at desc limit 100`, params);

  const counts = await query<{ status: string; n: string }>(
    `select status, count(*)::text n from leads where org_id=$1 group by status`, [user.currentOrgId]);
  const countMap = Object.fromEntries(counts.map((c) => [c.status, c.n]));

  return (
    <div>
      <PageHeader title="Leads" subtitle="Incoming demand and sales pipeline" action={<><Button href="/leads/board" variant="ghost" icon="dashboard">Board</Button><Button href="/leads/new" icon="plus">New Lead</Button></>} />

      <div className="mb-4 flex flex-wrap gap-2">
        <Link href="/leads" className={`rounded-lg border px-3 py-1.5 text-xs ${!status ? 'border-brand bg-brand/10 text-brand' : 'border-line text-muted hover:text-ink'}`}>All</Link>
        {PIPELINE.map((s) => (
          <Link key={s} href={`/leads?status=${s}`} className={`rounded-lg border px-3 py-1.5 text-xs ${status === s ? 'border-brand bg-brand/10 text-brand' : 'border-line text-muted hover:text-ink'}`}>
            {s.replace(/_/g, ' ')} <span className="ml-1 opacity-60">{countMap[s] ?? 0}</span>
          </Link>
        ))}
      </div>

      <Card>
        {leads.length === 0 ? (
          <EmptyState title="No leads found" hint="Create a lead manually, or connect the website inquiry endpoint." action={<Button href="/leads/new">+ New Lead</Button>} />
        ) : (
          <Table>
            <thead>
              <tr><Th>Lead #</Th><Th>Company</Th><Th>Owner</Th><Th>Priority</Th><Th>Est. value</Th><Th>Status</Th><Th>Age</Th></tr>
            </thead>
            <tbody>
              {leads.map((l) => (
                <tr key={l.id} className="hover:bg-bg">
                  <Td><Link href={`/leads/${l.id}`} className="font-medium text-brand">{l.lead_number}</Link></Td>
                  <Td>{l.company_name}</Td>
                  <Td className="text-muted">{l.owner ?? 'Unassigned'}</Td>
                  <Td>{l.priority}</Td>
                  <Td>{l.expected_value ? formatMoney(l.expected_value) : '—'}</Td>
                  <Td><StatusPill status={l.status} /></Td>
                  <Td className="text-xs text-faint">{fromNow(l.created_at)}</Td>
                </tr>
              ))}
            </tbody>
          </Table>
        )}
      </Card>
    </div>
  );
}
