import { query } from '@/server/db';
import { fromNow } from '@/lib/format';
import { Card, CardHeader, EmptyState } from '@/components/ui';

export async function ActivityTimeline({ entityType, entityId }: { entityType: string; entityId: string }) {
  const rows = await query<{ id: string; kind: string; summary: string; actor_name: string | null; created_at: Date }>(
    `select id, kind, summary, actor_name, created_at from activities
     where entity_type=$1 and entity_id=$2 order by created_at desc limit 50`, [entityType, entityId]);
  return (
    <Card>
      <CardHeader title="Activity" subtitle="Complete history" />
      {rows.length === 0 ? (
        <EmptyState title="No activity yet" />
      ) : (
        <ul className="p-4">
          {rows.map((r) => (
            <li key={r.id} className="relative flex gap-3 pb-4 last:pb-0">
              <div className="mt-1 h-2 w-2 shrink-0 rounded-full bg-brand" />
              <div className="min-w-0">
                <p className="text-sm text-ink">{r.summary}</p>
                <p className="text-xs text-faint">{r.actor_name ?? 'System'} · {fromNow(r.created_at)}</p>
              </div>
            </li>
          ))}
        </ul>
      )}
    </Card>
  );
}
