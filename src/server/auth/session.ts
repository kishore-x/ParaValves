import 'server-only';
import { randomBytes, createHash } from 'node:crypto';
import { cookies } from 'next/headers';
import { query, one } from '../db';
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

export async function createSession(userId: string, ip?: string, ua?: string): Promise<string> {
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
  if (token) await query('delete from sessions where token_hash = $1', [hashToken(token)]);
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
  const row = await one<SessionRow>(
    `select s.user_id, s.expires_at, s.last_seen_at, u.email, u.name, u.is_global, u.is_active
     from sessions s join users u on u.id = s.user_id
     where s.token_hash = $1`,
    [hashToken(token)],
  );
  if (!row || !row.is_active) return null;
  if (new Date(row.expires_at).getTime() < Date.now()) return null;
  const idleMs = env.SESSION_IDLE_MIN * 60 * 1000;
  if (Date.now() - new Date(row.last_seen_at).getTime() > idleMs) return null;

  await query('update sessions set last_seen_at = now() where token_hash = $1', [hashToken(token)]);

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
