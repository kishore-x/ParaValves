import 'server-only';
import { redirect } from 'next/navigation';
import { getCurrentUser, type AuthUser } from './session';
import { assertCan } from './rbac';

/** For server actions & server components: require a logged-in user. */
export async function requireUser(): Promise<AuthUser> {
  const user = await getCurrentUser();
  if (!user) redirect('/login');
  return user;
}

export async function requirePermission(permission: string): Promise<AuthUser> {
  const user = await requireUser();
  assertCan(user, permission);
  return user;
}
