import { requireUser } from '@/server/auth/action';
import { query } from '@/server/db';
import { PageHeader, Button } from '@/components/ui';
import { Board, type BoardLead } from './Board';

export default async function LeadsBoardPage() {
  const user = await requireUser();
  const leads = await query<BoardLead>(
    `select l.id, l.lead_number, l.company_name, l.status, l.priority, l.expected_value::text, u.name owner
     from leads l left join users u on u.id=l.owner_id
     where l.org_id=$1 order by l.created_at desc limit 200`, [user.currentOrgId]);
  return (
    <div>
      <PageHeader title="Pipeline" subtitle="Drag leads across stages" action={<><Button href="/leads" variant="ghost" size="sm">List view</Button><Button href="/leads/new" icon="plus" size="sm">New Lead</Button></>} />
      <Board initial={leads} />
    </div>
  );
}
