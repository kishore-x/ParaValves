import Link from 'next/link';
import { revalidatePath } from 'next/cache';
import { requireUser } from '@/server/auth/action';
import { query } from '@/server/db';
import { Card, CardHeader, PageHeader, EmptyState, Button } from '@/components/ui';
import { fromNow } from '@/lib/format';

async function markAllRead() {
  'use server';
  const user = await requireUser();
  await query(`update notifications set is_read=true where user_id=$1 and is_read=false`, [user.id]);
  revalidatePath('/notifications');
}

export default async function NotificationsPage() {
  const user = await requireUser();
  const rows = await query<any>(`select * from notifications where user_id=$1 order by created_at desc limit 100`, [user.id]);
  return (
    <div>
      <PageHeader title="Notifications" action={<form action={markAllRead}><Button type="submit" variant="ghost" size="sm">Mark all read</Button></form>} />
      <Card>
        {rows.length === 0 ? <EmptyState title="No notifications" /> : (
          <ul className="divide-y divide-line">
            {rows.map((n) => (
              <li key={n.id} className={`px-5 py-3 ${n.is_read ? '' : 'bg-brand/5'}`}>
                <div className="flex items-start justify-between gap-3">
                  <div>
                    <p className="text-sm font-medium text-ink">{n.title}</p>
                    {n.body && <p className="text-xs text-muted">{n.body}</p>}
                    <p className="text-xs text-faint">{fromNow(n.created_at)}</p>
                  </div>
                  {n.link && <Link href={n.link} className="text-xs text-brand">Open →</Link>}
                </div>
              </li>
            ))}
          </ul>
        )}
      </Card>
    </div>
  );
}
