import Link from 'next/link';
import { revalidatePath } from 'next/cache';
import { requireUser, requirePermission } from '@/server/auth/action';
import { query } from '@/server/db';
import { Card, CardHeader, PageHeader, EmptyState, Button, StatTile } from '@/components/ui';
import { fromNow } from '@/lib/format';

async function completeTask(formData: FormData) {
  'use server';
  const user = await requirePermission('task.edit');
  const id = String(formData.get('id'));
  await query(`update tasks set status='DONE' where id=$1 and org_id=any($2)`, [id, user.orgIds]);
  revalidatePath('/tasks');
}

const entityBase: Record<string, string> = { lead: '/leads/', quote: '/quotes/', order: '/orders/', po: '/procurement/', invoice: '/invoices/' };

export default async function TasksPage() {
  const user = await requireUser();
  const rows = await query<any>(
    `select id, task_number, title, entity_type, entity_id, due_at, status, priority
     from tasks where org_id=$1 and (assignee_id=$2 or assignee_id is null) order by due_at nulls last`, [user.currentOrgId, user.id]);
  const now = Date.now();
  const buckets = {
    Overdue: rows.filter((t) => t.status !== 'DONE' && t.due_at && new Date(t.due_at).getTime() < now),
    Today: rows.filter((t) => t.status !== 'DONE' && t.due_at && new Date(t.due_at).toDateString() === new Date().toDateString()),
    Upcoming: rows.filter((t) => t.status !== 'DONE' && (!t.due_at || new Date(t.due_at).getTime() > now) && new Date(t.due_at ?? 0).toDateString() !== new Date().toDateString()),
    Completed: rows.filter((t) => t.status === 'DONE'),
  };
  return (
    <div>
      <PageHeader title="My Tasks" subtitle="Work generated automatically from your workflows" />
      <div className="mb-5 grid grid-cols-2 gap-3 sm:grid-cols-4">
        <StatTile label="Overdue" value={buckets.Overdue.length} tone={buckets.Overdue.length ? 'danger' : 'ok'} />
        <StatTile label="Today" value={buckets.Today.length} />
        <StatTile label="Upcoming" value={buckets.Upcoming.length} />
        <StatTile label="Completed" value={buckets.Completed.length} tone="ok" />
      </div>
      <div className="space-y-5">
        {(['Overdue', 'Today', 'Upcoming', 'Completed'] as const).map((b) => (
          <Card key={b}>
            <CardHeader title={b} subtitle={`${buckets[b].length} task(s)`} />
            {buckets[b].length === 0 ? <EmptyState title={`Nothing ${b.toLowerCase()}`} /> : (
              <ul className="divide-y divide-line">
                {buckets[b].map((t) => (
                  <li key={t.id} className="flex items-center justify-between gap-3 px-5 py-3">
                    <div className="min-w-0">
                      <p className="text-sm text-ink">{t.title}</p>
                      <p className="text-xs text-faint">{t.task_number} · {t.due_at ? `due ${fromNow(t.due_at)}` : 'no due date'}
                        {t.entity_type && entityBase[t.entity_type] && <> · <Link href={entityBase[t.entity_type] + t.entity_id} className="text-brand">open</Link></>}</p>
                    </div>
                    {t.status !== 'DONE' && <form action={completeTask}><input type="hidden" name="id" value={t.id} /><Button type="submit" size="sm" variant="ghost">Done</Button></form>}
                  </li>
                ))}
              </ul>
            )}
          </Card>
        ))}
      </div>
    </div>
  );
}
