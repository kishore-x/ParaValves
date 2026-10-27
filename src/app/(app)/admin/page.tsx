import { requirePermission } from '@/server/auth/action';
import { query } from '@/server/db';
import { Card, CardHeader, Table, Th, Td, PageHeader, StatTile, StatusPill } from '@/components/ui';
import { fmtDateTime } from '@/lib/format';

export default async function AdminPage() {
  const user = await requirePermission('admin.view');
  const [users, roles, orgs, seqs, audits, emails] = await Promise.all([
    query<any>(`select u.id, u.email, u.name, u.is_active, u.is_global, string_agg(r.name, ', ') roles
      from users u left join user_roles ur on ur.user_id=u.id left join roles r on r.id=ur.role_id group by u.id order by u.name`),
    query<any>(`select r.name, count(rp.permission_code)::text perms from roles r left join role_permissions rp on rp.role_id=r.id group by r.id order by r.name`),
    query<any>(`select code, name, country, currency from organizations order by code`),
    query<any>(`select doc_type, prefix, current_value, period_key from number_sequences where org_id=$1 order by doc_type`, [user.currentOrgId]),
    query<any>(`select actor_name, action, entity_type, created_at from audit_logs order by created_at desc limit 25`),
    query<any>(`select recipient, subject, event, status, created_at from email_log order by created_at desc limit 15`),
  ]);
  return (
    <div>
      <PageHeader title="Administration" subtitle="Users, roles, organizations, numbering and audit" />
      <div className="mb-5 grid grid-cols-2 gap-3 sm:grid-cols-4">
        <StatTile label="Users" value={users.length} />
        <StatTile label="Roles" value={roles.length} />
        <StatTile label="Organizations" value={orgs.length} />
        <StatTile label="Number sequences" value={seqs.length} />
      </div>
      <div className="grid gap-5 lg:grid-cols-2">
        <Card>
          <CardHeader title="Users" />
          <Table><thead><tr><Th>Name</Th><Th>Email</Th><Th>Roles</Th><Th>Scope</Th></tr></thead>
            <tbody>{users.map((u) => (
              <tr key={u.id}><Td>{u.name}</Td><Td className="text-muted">{u.email}</Td><Td>{u.roles ?? '—'}</Td><Td>{u.is_global ? 'Global' : 'Org'}</Td></tr>
            ))}</tbody></Table>
        </Card>
        <Card>
          <CardHeader title="Roles & permissions" />
          <Table><thead><tr><Th>Role</Th><Th>Permissions</Th></tr></thead>
            <tbody>{roles.map((r, i) => <tr key={i}><Td>{r.name}</Td><Td>{r.perms}</Td></tr>)}</tbody></Table>
        </Card>
        <Card>
          <CardHeader title="Numbering sequences" subtitle="Current org" />
          <Table><thead><tr><Th>Type</Th><Th>Prefix</Th><Th>Period</Th><Th>Current</Th></tr></thead>
            <tbody>{seqs.map((s, i) => <tr key={i}><Td>{s.doc_type}</Td><Td className="font-mono">{s.prefix}</Td><Td>{s.period_key}</Td><Td>{s.current_value}</Td></tr>)}</tbody></Table>
        </Card>
        <Card>
          <CardHeader title="Email Log" subtitle="Every outbound email is recorded" />
          <Table><thead><tr><Th>To</Th><Th>Subject</Th><Th>Status</Th></tr></thead>
            <tbody>{emails.length === 0 ? <tr><Td>No emails sent yet</Td><Td/><Td/></tr> : emails.map((e, i) => (
              <tr key={i}><Td className="text-muted">{e.recipient}</Td><Td>{e.subject}</Td><Td><StatusPill status={e.status === 'sent' ? 'DONE' : e.status === 'failed' ? 'CANCELLED' : 'WAITING'} /></Td></tr>
            ))}</tbody></Table>
        </Card>
        <Card>
          <CardHeader title="Recent audit log" subtitle="Append-only" />
          <Table><thead><tr><Th>Actor</Th><Th>Action</Th><Th>Entity</Th><Th>When</Th></tr></thead>
            <tbody>{audits.map((a, i) => <tr key={i}><Td>{a.actor_name ?? 'System'}</Td><Td className="font-mono text-xs">{a.action}</Td><Td>{a.entity_type}</Td><Td className="text-xs text-faint">{fmtDateTime(a.created_at)}</Td></tr>)}</tbody></Table>
        </Card>
      </div>
    </div>
  );
}
