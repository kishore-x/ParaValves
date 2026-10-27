import 'server-only';
import type { AuthUser } from './session';

export function can(user: AuthUser, permission: string): boolean {
  return user.permissions.has('*') || user.permissions.has(permission);
}

export function assertCan(user: AuthUser, permission: string): void {
  if (!can(user, permission)) {
    const err = new Error(`Forbidden: missing permission ${permission}`);
    (err as { status?: number }).status = 403;
    throw err;
  }
}

/** org ids this user may read/write; global users see all provided candidate orgs */
export function orgScope(user: AuthUser): string[] {
  return user.orgIds;
}
