import Link from 'next/link';
import { requireUser } from '@/server/auth/action';
import { query } from '@/server/db';
import { Card, Table, Th, Td, StatusPill, PageHeader, EmptyState } from '@/components/ui';
import { num, fmtDate } from '@/lib/format';

export default async function ProjectsPage() {
  const user = await requireUser();
  const rows = await query<any>(
    `select p.id, p.project_number, p.name, c.name company, p.status, p.progress_pct, p.end_date
     from projects p left join companies c on c.id=p.company_id where p.org_id=$1 order by p.created_at desc limit 100`, [user.currentOrgId]);
  return (
    <div>
      <PageHeader title="Projects" subtitle="Execution tracking with progress and delays" />
      <Card>
        {rows.length === 0 ? <EmptyState title="No projects" hint="Projects are auto-created when an order is confirmed." /> : (
          <Table>
            <thead><tr><Th>Project #</Th><Th>Name</Th><Th>Customer</Th><Th>Progress</Th><Th>Status</Th><Th>Due</Th></tr></thead>
            <tbody>{rows.map((r) => (
              <tr key={r.id} className="hover:bg-bg">
                <Td><Link href={`/projects/${r.id}`} className="font-mono text-xs font-semibold text-brand">{r.project_number}</Link></Td>
                <Td>{r.name}</Td><Td className="text-muted">{r.company ?? '—'}</Td>
                <Td><div className="flex items-center gap-2"><div className="h-1.5 w-24 overflow-hidden rounded-full bg-line"><div className="h-full bg-brand" style={{ width: `${num(r.progress_pct)}%` }} /></div><span className="text-xs">{num(r.progress_pct)}%</span></div></Td>
                <Td><StatusPill status={r.status} /></Td><Td className="text-xs text-faint">{fmtDate(r.end_date)}</Td>
              </tr>
            ))}</tbody>
          </Table>
        )}
      </Card>
    </div>
  );
}
