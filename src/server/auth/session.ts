import 'server-only';
import { randomBytes, createHash, createHmac, timingSafeEqual } from 'node:crypto';
import { cookies } from 'next/headers';
import { query, one, isDemoDb } from '../db';
import { env } from '../env';

export const SESSION_COOKIE = 'pv_session';

function hashToken(token: string): string {
  return createHash('sha256').update(token).digest('hex');
}

export interface AuthUser {
  id: string;
  email: string;
  name: string;
  isGlobal: boolean;
  orgIds: string[];
  permissions: Set<string>;
  currentOrgId: string;
}

// Demo DB (in-memory, per serverless instance): a sessions row would only exist on the
// instance that created it, so every other instance would bounce the user to /login.
// Demo sessions are therefore stateless — `userId.expiryMs.hmac` — verifiable anywhere,
// since the seeded users are identical on every instance.
function demoSign(payload: string): string {
  return createHmac('sha256', env.SESSION_SECRET).update(payload).digest('hex');
}

function demoVerify(token: string): { userId: string; expires: number } | null {
  const [userId, exp, sig] = token.split('.');
  if (!userId || !exp || !sig) return null;
  const want = Buffer.from(demoSign(`${userId}.${exp}`));
  const got = Buffer.from(sig);
  if (want.length !== got.length || !timingSafeEqual(want, got)) return null;
  const expires = Number(exp);
  return Number.isFinite(expires) ? { userId, expires } : null;
}

export async function createSession(userId: string, ip?: string, ua?: string): Promise<string> {
  if (isDemoDb) {
    const payload = `${userId}.${Date.now() + env.SESSION_TTL_HOURS * 3600 * 1000}`;
    return `${payload}.${demoSign(payload)}`;
  }
  const token = randomBytes(32).toString('hex');
  const expires = new Date(Date.now() + env.SESSION_TTL_HOURS * 3600 * 1000);
  await query(
    `insert into sessions (user_id, token_hash, expires_at, ip, user_agent)
     values ($1,$2,$3,$4,$5)`,
    [userId, hashToken(token), expires, ip ?? null, ua ?? null],
  );
  return token;
}

export async function setSessionCookie(token: string): Promise<void> {
  const c = await cookies();
  c.set(SESSION_COOKIE, token, {
    httpOnly: true,
    sameSite: 'lax',
    secure: env.COOKIE_SECURE,
    path: '/',
    maxAge: env.SESSION_TTL_HOURS * 3600,
  });
}

export async function destroySession(): Promise<void> {
  const c = await cookies();
  const token = c.get(SESSION_COOKIE)?.value;
  if (token && !isDemoDb) await query('delete from sessions where token_hash = $1', [hashToken(token)]);
  c.delete(SESSION_COOKIE);
}

interface SessionRow {
  user_id: string;
  expires_at: Date;
  last_seen_at: Date;
  email: string;
  name: string;
  is_global: boolean;
  is_active: boolean;
}

export async function getCurrentUser(): Promise<AuthUser | null> {
  const c = await cookies();
  const token = c.get(SESSION_COOKIE)?.value;
  if (!token) return null;
  let row: SessionRow | null;
  if (isDemoDb) {
    const t = demoVerify(token);
    if (!t) return null;
    const u = await one<Omit<SessionRow, 'expires_at' | 'last_seen_at'>>(
      'select id as user_id, email, name, is_global, is_active from users where id = $1',
      [t.userId],
    );
    row = u && { ...u, expires_at: new Date(t.expires), last_seen_at: new Date() };
  } else {
    row = await one<SessionRow>(
      `select s.user_id, s.expires_at, s.last_seen_at, u.email, u.name, u.is_global, u.is_active
       from sessions s join users u on u.id = s.user_id
       where s.token_hash = $1`,
      [hashToken(token)],
    );
  }
  if (!row || !row.is_active) return null;
  if (new Date(row.expires_at).getTime() < Date.now()) return null;
  if (!isDemoDb) {
    const idleMs = env.SESSION_IDLE_MIN * 60 * 1000;
    if (Date.now() - new Date(row.last_seen_at).getTime() > idleMs) return null;
    await query('update sessions set last_seen_at = now() where token_hash = $1', [hashToken(token)]);
  }

  const orgs = await query<{ org_id: string }>(
    'select org_id from user_organizations where user_id = $1',
    [row.user_id],
  );
  const orgIds = orgs.map((o) => o.org_id);

  const perms = await query<{ permission_code: string }>(
    `select distinct rp.permission_code
     from user_roles ur join role_permissions rp on rp.role_id = ur.role_id
     where ur.user_id = $1`,
    [row.user_id],
  );

  const currentOrgId = c.get('pv_org')?.value && orgIds.includes(c.get('pv_org')!.value)
    ? c.get('pv_org')!.value
    : orgIds[0] ?? '';

  return {
    id: row.user_id,
    email: row.email,
    name: row.name,
    isGlobal: row.is_global,
    orgIds,
    permissions: new Set(perms.map((p) => p.permission_code)),
    currentOrgId,
  };
}

export function hashSessionToken(token: string): string {
  return hashToken(token);
}
