import type { ReactNode } from 'react';
import { requireUser } from '@/server/auth/action';
import { one } from '@/server/db';
import { Shell } from '@/components/shell';

export default async function AppLayout({ children }: { children: ReactNode }) {
  const user = await requireUser();
  const org = await one<{ name: string }>('select name from organizations where id = $1', [user.currentOrgId]);
  const notif = await one<{ n: string }>(
    'select count(*)::text as n from notifications where user_id = $1 and is_read = false',
    [user.id],
  );
  return (
    <Shell userName={user.name} orgName={org?.name ?? '—'} notifCount={Number(notif?.n ?? 0)}>
      {children}
    </Shell>
  );
}
