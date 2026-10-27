import { requireUser } from '@/server/auth/action';
import { one, query } from '@/server/db';
import { Card, CardHeader, PageHeader, Badge, Avatar } from '@/components/ui';
import { ThemeSelector } from '@/components/theme';
import { Icon } from '@/components/icons';

export default async function SettingsPage() {
  const user = await requireUser();
  const org = await one<{ name: string; code: string; country: string; currency: string }>(
    'select name, code, country, currency from organizations where id=$1', [user.currentOrgId]);
  const roles = await query<{ name: string }>(
    `select r.name from user_roles ur join roles r on r.id=ur.role_id where ur.user_id=$1 order by r.name`, [user.id]);
  const orgs = await query<{ name: string; code: string }>(
    `select o.name, o.code from user_organizations uo join organizations o on o.id=uo.org_id where uo.user_id=$1`, [user.id]);

  return (
    <div className="mx-auto max-w-3xl">
      <PageHeader title="Settings" subtitle="Personalize your workspace and review your account." />

      <div className="space-y-5">
        {/* Appearance */}
        <Card>
          <CardHeader title="Appearance" subtitle="Choose how Paravalves looks. Saved to this browser." />
          <div className="p-5">
            <ThemeSelector />
            <p className="mt-4 flex items-center gap-1.5 text-xs text-faint">
              <Icon name="alert" size={13} /> The coral brand color stays the same in every mode — only the background changes.
            </p>
          </div>
        </Card>

        {/* Account */}
        <Card>
          <CardHeader title="Account" />
          <div className="flex items-center gap-4 p-5">
            <Avatar name={user.name} size={48} />
            <div className="min-w-0">
              <p className="text-base font-semibold text-ink">{user.name}</p>
              <p className="text-sm text-muted">{user.email}</p>
            </div>
            {user.isGlobal && <Badge tone="brand">Global access</Badge>}
          </div>
          <dl className="grid grid-cols-2 gap-x-6 gap-y-4 border-t border-line p-5 text-sm sm:grid-cols-3">
            <div>
              <dt className="text-xs font-medium text-muted">Roles</dt>
              <dd className="mt-1 flex flex-wrap gap-1.5">{roles.length ? roles.map((r) => <Badge key={r.name}>{r.name}</Badge>) : '—'}</dd>
            </div>
            <div>
              <dt className="text-xs font-medium text-muted">Permissions</dt>
              <dd className="mt-1 text-ink">{user.permissions.has('*') ? 'All (Super Admin)' : `${user.permissions.size} granted`}</dd>
            </div>
            <div>
              <dt className="text-xs font-medium text-muted">Organizations</dt>
              <dd className="mt-1 flex flex-wrap gap-1.5">{orgs.map((o) => <Badge key={o.code} tone={o.code === org?.code ? 'ok' : 'muted'}>{o.name}</Badge>)}</dd>
            </div>
          </dl>
        </Card>

        {/* Organization */}
        <Card>
          <CardHeader title="Current Organization" subtitle="Data you see is scoped to this organization." />
          <dl className="grid grid-cols-2 gap-x-6 gap-y-4 p-5 text-sm sm:grid-cols-4">
            <Info label="Name" value={org?.name} />
            <Info label="Code" value={org?.code} />
            <Info label="Country" value={org?.country} />
            <Info label="Currency" value={org?.currency} />
          </dl>
        </Card>

        {/* Security */}
        <Card>
          <CardHeader title="Security" subtitle="Account protection" />
          <ul className="divide-y divide-line text-sm">
            <Row icon="check" label="Password" value="Set — scrypt hashed, never stored in plain text" tone="ok" />
            <Row icon="clock" label="Session" value="Server-side, HttpOnly cookie, 12h absolute + idle timeout" />
            <Row icon="admin" label="Audit" value="Every action you take is recorded in the audit log" />
          </ul>
        </Card>
      </div>
    </div>
  );
}

function Info({ label, value }: { label: string; value?: string | null }) {
  return <div><dt className="text-xs font-medium text-muted">{label}</dt><dd className="mt-1 text-ink">{value || '—'}</dd></div>;
}
function Row({ icon, label, value, tone }: { icon: string; label: string; value: string; tone?: 'ok' }) {
  return (
    <li className="flex items-start gap-3 px-5 py-3">
      <Icon name={icon} size={16} className={`mt-0.5 ${tone === 'ok' ? 'text-ok' : 'text-faint'}`} />
      <div><p className="font-medium text-ink">{label}</p><p className="text-xs text-muted">{value}</p></div>
    </li>
  );
}
