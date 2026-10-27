import { redirect } from 'next/navigation';
import { headers } from 'next/headers';
import { one } from '@/server/db';
import { verifyPassword } from '@/server/auth/password';
import { createSession, setSessionCookie, getCurrentUser } from '@/server/auth/session';
import { audit } from '@/server/audit';
import { rateLimit } from '@/server/auth/ratelimit';
import { inputCls } from '@/components/ui';
import { Icon } from '@/components/icons';
import { Wordmark } from '@/components/logo';

async function login(formData: FormData) {
  'use server';
  const email = String(formData.get('email') ?? '').trim().toLowerCase();
  const password = String(formData.get('password') ?? '');
  const row = await one<{ id: string; password_hash: string; is_active: boolean; name: string }>(
    'select id, password_hash, is_active, name from users where email = $1', [email]);
  const ip = (await headers()).get('x-forwarded-for') ?? undefined;
  // rate limit: max 10 attempts / 15 min per IP+email
  const allowed = await rateLimit('login', `login:${ip ?? 'unknown'}:${email}`, 10, 15);
  if (!allowed) {
    await audit({ action: 'auth.login_rate_limited', entityType: 'user', entityId: email, ip });
    redirect('/login?error=2');
  }
  if (!row || !row.is_active || !(await verifyPassword(password, row.password_hash))) {
    await audit({ action: 'auth.login_failed', entityType: 'user', entityId: email, ip });
    redirect('/login?error=1');
  }
  const token = await createSession(row.id, ip);
  await setSessionCookie(token);
  await audit({ actorId: row.id, actorName: row.name, action: 'auth.login', entityType: 'user', entityId: row.id, ip });
  redirect('/dashboard');
}

const HIGHLIGHTS = [
  ['Order 360', 'The whole order — engineering, material, project, invoice — on one screen.'],
  ['Material intelligence', 'Required vs available vs incoming, with automatic shortage detection.'],
  ['One source of truth', 'From website inquiry to payment, no re-keying, fully audited.'],
];

export default async function LoginPage({ searchParams }: { searchParams: Promise<{ error?: string }> }) {
  if (await getCurrentUser()) redirect('/dashboard');
  const { error } = await searchParams;
  return (
    <div className="grid min-h-screen lg:grid-cols-[1.1fr_1fr]">
      {/* brand panel — mirrors paravalves.com: near-black, coral accent */}
      <div className="relative hidden flex-col justify-between overflow-hidden bg-[#1a1c1e] p-12 text-white lg:flex">
        {/* subtle industrial texture + coral edge, like the site's red sidebar */}
        <div className="absolute inset-y-0 right-0 w-1.5 bg-brand" />
        <div className="absolute -left-32 top-1/3 h-[28rem] w-[28rem] rounded-full bg-brand/10 blur-3xl" />
        <div className="absolute bottom-10 right-10 opacity-[0.06]">
          <span className="brandmark text-[10rem] font-semibold leading-none text-white">v</span>
        </div>

        <div className="relative"><Wordmark size="lg" onDark /></div>

        <div className="relative max-w-md">
          <p className="text-sm font-medium uppercase tracking-[0.2em] text-brand">Flowing innovation</p>
          <h2 className="mt-4 text-3xl font-semibold leading-tight tracking-tight">
            The operating system for the Paravalves business.
          </h2>
          <p className="mt-4 text-sm leading-relaxed text-white/60">
            CRM, quotations, engineering, inventory, procurement, projects and finance —
            one connected platform. Because when everything flows, everything works.
          </p>
          <div className="mt-9 space-y-4">
            {HIGHLIGHTS.map(([t, d]) => (
              <div key={t} className="flex gap-3">
                <div className="mt-0.5 flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-brand/15 text-brand"><Icon name="check" size={14} /></div>
                <div><p className="text-sm font-medium">{t}</p><p className="text-xs text-white/50">{d}</p></div>
              </div>
            ))}
          </div>
        </div>
        <p className="relative text-xs text-white/40">© {new Date().getFullYear()} Paravalves · Industrial valve manufacturers · India & Spain</p>
      </div>

      {/* form panel */}
      <div className="flex items-center justify-center bg-bg px-6 py-12">
        <div className="w-full max-w-sm">
          <div className="mb-8 lg:hidden"><Wordmark size="lg" /></div>
          <h1 className="text-xl font-semibold tracking-tight text-ink">Sign in</h1>
          <p className="mt-1 text-sm text-muted">Welcome back. Enter your credentials to continue.</p>
          <form action={login} className="mt-7 space-y-4">
            {error && (
              <div className="flex items-center gap-2 rounded-lg bg-danger-wash px-3 py-2.5 text-sm text-danger ring-1 ring-inset ring-danger/20">
                <Icon name="alert" size={16} /> {error === '2' ? 'Too many attempts. Try again in a few minutes.' : 'Invalid email or password.'}
              </div>
            )}
            <label className="block">
              <span className="mb-1.5 block text-xs font-medium text-muted">Email address</span>
              <input name="email" type="email" required autoFocus defaultValue="admin@paravalves.com" className={inputCls} />
            </label>
            <label className="block">
              <span className="mb-1.5 block text-xs font-medium text-muted">Password</span>
              <input name="password" type="password" required defaultValue="admin123" className={inputCls} />
            </label>
            <button type="submit" className="mt-2 flex h-10 w-full items-center justify-center gap-2 rounded-lg bg-brand text-sm font-semibold text-brand-ink shadow-sm transition-all hover:bg-brand-strong active:scale-[.99]">
              Sign in <Icon name="arrowRight" size={16} />
            </button>
          </form>
          <div className="mt-6 rounded-lg border border-line bg-surface p-3 text-xs text-muted">
            <p className="font-medium text-ink">Demo accounts</p>
            <p className="mt-1">admin@paravalves.com · admin123 <span className="text-faint">(Super Admin)</span></p>
            <p>sales@paravalves.com · sales123 <span className="text-faint">(Sales)</span></p>
          </div>
        </div>
      </div>
    </div>
  );
}
