import 'server-only';
import { one } from '@/server/db';

/**
 * Simple DB-backed fixed-window rate limiter. Returns true if the action is
 * allowed (under the limit), false if it should be blocked.
 */
export async function rateLimit(bucket: string, key: string, limit: number, windowMinutes = 15): Promise<boolean> {
  const now = new Date();
  const windowKey = `${bucket}:${Math.floor(now.getTime() / (windowMinutes * 60000))}`;
  const row = await one<{ count: number }>(
    `insert into rate_limits (bucket, window_key, count) values ($1,$2,1)
     on conflict (bucket, window_key) do update set count = rate_limits.count + 1
     returning count`,
    [key, windowKey],
  );
  return (row?.count ?? 0) <= limit;
}
