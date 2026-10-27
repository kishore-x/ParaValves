'use server';
import { redirect } from 'next/navigation';
import { destroySession } from '@/server/auth/session';

/**
 * Sign out. This is deliberately a POST-only server action, never a GET route.
 *
 * A GET /logout endpoint behind a <Link> is silently triggered by Next.js's
 * automatic link prefetching (and by browser prefetchers, crawlers, and
 * antivirus link scanners), which destroys the user's session moments after
 * they sign in. State-changing operations must never be reachable by GET.
 */
export async function logoutAction(): Promise<void> {
  await destroySession();
  redirect('/login');
}
