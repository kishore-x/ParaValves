import Link from 'next/link';
import { notFound } from 'next/navigation';
import { revalidatePath } from 'next/cache';
import { requireUser, requirePermission } from '@/server/auth/action';
import { one, query, tx } from '@/server/db';
import { Card, CardHeader, PageHeader, StatusPill, Button } from '@/components/ui';
import { ActivityTimeline } from '@/components/timeline';
import { Gantt, type GanttTask } from '@/components/gantt';
import { num } from '@/lib/format';

async function toggleTask(formData: FormData) {
  'use server';
  const user = await requirePermission('project.edit');
  const taskId = String(formData.get('task_id'));
  const projectId = String(formData.get('project_id'));
  await tx(async (c) => {
    const t = await c.one<any>(`select pt.* from project_tasks pt join projects p on p.id=pt.project_id where pt.id=$1 and p.org_id=any($2)`, [taskId, user.orgIds]);
    if (!t) return;
    const done = t.status !== 'DONE';
    await c.query(`update project_tasks set status=$1, progress_pct=$2 where id=$3`, [done ? 'DONE' : 'TODO', done ? 100 : 0, taskId]);
    const agg = await c.one<{ avg: string }>(`select coalesce(avg(progress_pct),0) avg from project_tasks where project_id=$1`, [projectId]);
    await c.query(`update projects set progress_pct=$1 where id=$2`, [Math.round(Number(agg?.avg ?? 0)), projectId]);
  });
  revalidatePath(`/projects/${projectId}`);
}

export default async function ProjectDetail({ params }: { params: Promise<{ id: string }> }) {
  const user = await requireUser();
  const { id } = await params;
  const p = await one<any>(`select p.*, c.name company, so.order_number, so.id order_id from projects p left join companies c on c.id=p.company_id left join sales_orders so on so.id=p.sales_order_id where p.id=$1 and p.org_id=any($2)`, [id, user.orgIds]);
  if (!p) notFound();
  const tasks = await query<any>(`select * from project_tasks where project_id=$1 order by sort_order`, [id]);
  // synthesize a schedule: use planned dates if present, else 1 week/phase from project start
  const base = p.start_date ? new Date(p.start_date) : new Date(p.created_at);
  const ganttTasks: GanttTask[] = tasks.map((t, i) => {
    const start = t.planned_start ? new Date(t.planned_start) : new Date(base.getTime() + i * 7 * 864e5);
    const end = t.planned_end ? new Date(t.planned_end) : new Date(start.getTime() + 7 * 864e5);
    return { name: t.name, start, end, progress: Math.round(Number(t.progress_pct)), done: t.status === 'DONE', gate: t.is_mandatory_for_closure };
  });
  return (
    <div>
      <PageHeader title={p.project_number} subtitle={p.name} action={<StatusPill status={p.status} />} />
      <div className="mb-5 grid grid-cols-2 gap-3 sm:grid-cols-4">
        <Card className="p-3"><p className="text-xs text-muted">Progress</p><p className="mt-1 text-lg font-semibold">{num(p.progress_pct)}%</p></Card>
        <Card className="p-3"><p className="text-xs text-muted">Customer</p><p className="mt-1 text-sm font-medium">{p.company ?? '—'}</p></Card>
        <Card className="p-3"><p className="text-xs text-muted">Order</p><p className="mt-1 text-sm font-medium">{p.order_id ? <Link href={`/orders/${p.order_id}`} className="text-brand">{p.order_number}</Link> : '—'}</p></Card>
        <Card className="p-3"><p className="text-xs text-muted">Status</p><p className="mt-1"><StatusPill status={p.status} /></p></Card>
      </div>
      <div className="grid gap-5 lg:grid-cols-3">
        <div className="lg:col-span-2">
          <Card>
            <CardHeader title="Timeline" subtitle="Gantt schedule · ◆ marks closure gates · red line is today" />
            <Gantt tasks={ganttTasks} />
          </Card>
          <Card>
            <CardHeader title="Phases" subtitle="Mark phases done — progress rolls up to the project" />
            <div className="space-y-3 p-5">
              {tasks.map((t) => (
                <div key={t.id} className="flex items-center gap-3">
                  <div className="w-40 shrink-0 text-sm">{t.name}{t.is_mandatory_for_closure && <span className="ml-1 text-2xs text-warn">(gate)</span>}</div>
                  <div className="h-3 flex-1 overflow-hidden rounded-full bg-line">
                    <div className={`h-full ${t.status === 'DONE' ? 'bg-ok' : 'bg-brand'}`} style={{ width: `${num(t.progress_pct)}%` }} />
                  </div>
                  <span className="w-12 text-right text-xs">{num(t.progress_pct)}%</span>
                  <form action={toggleTask}><input type="hidden" name="task_id" value={t.id} /><input type="hidden" name="project_id" value={p.id} />
                    <Button type="submit" size="sm" variant="ghost">{t.status === 'DONE' ? 'Undo' : 'Done'}</Button></form>
                </div>
              ))}
            </div>
          </Card>
        </div>
        <ActivityTimeline entityType="order" entityId={p.order_id ?? p.id} />
      </div>
    </div>
  );
}
