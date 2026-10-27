import Link from 'next/link';
import { notFound } from 'next/navigation';
import { requireUser } from '@/server/auth/action';
import { one } from '@/server/db';
import { LEAD } from '@/server/workflow/machines';
import { Card, CardHeader, StatusPill, PageHeader, Button, Field, inputCls } from '@/components/ui';
import { ActivityTimeline } from '@/components/timeline';
import { fmtDate } from '@/lib/format';
import { formatMoney } from '@/lib/money';
import { transitionLeadAction, convertLeadAction } from '../actions';

export default async function LeadDetail({ params }: { params: Promise<{ id: string }> }) {
  const user = await requireUser();
  const { id } = await params;
  const lead = await one<any>(
    `select l.*, u.name owner_name, c.company_number linked_number
     from leads l left join users u on u.id=l.owner_id left join companies c on c.id=l.company_id
     where l.id=$1 and l.org_id = any($2)`, [id, user.orgIds]);
  if (!lead) notFound();
  const nextStates = LEAD[lead.status] ?? [];

  return (
    <div>
      <PageHeader
        title={`${lead.lead_number}`}
        subtitle={lead.company_name}
        action={<div className="flex items-center gap-2"><StatusPill status={lead.status} />
          {!lead.company_id && lead.status !== 'LOST' && (
            <form action={convertLeadAction}><input type="hidden" name="id" value={lead.id} />
              <Button type="submit" size="sm">Convert to Customer</Button></form>
          )}
        </div>}
      />
      <div className="grid gap-5 lg:grid-cols-3">
        <div className="lg:col-span-2 space-y-5">
          <Card>
            <CardHeader title="Lead details" />
            <dl className="grid grid-cols-2 gap-x-6 gap-y-3 p-5 text-sm sm:grid-cols-3">
              <Info label="Contact" value={lead.contact_name} />
              <Info label="Email" value={lead.email} />
              <Info label="Phone" value={lead.phone} />
              <Info label="Country" value={lead.country} />
              <Info label="Source" value={lead.source} />
              <Info label="Priority" value={lead.priority} />
              <Info label="Product requirement" value={lead.product_requirement} />
              <Info label="Quantity" value={lead.quantity} />
              <Info label="Expected value" value={lead.expected_value ? formatMoney(lead.expected_value) : null} />
              <Info label="Expected close" value={lead.expected_close ? fmtDate(lead.expected_close) : null} />
              <Info label="Owner" value={lead.owner_name} />
              {lead.company_id && <Info label="Customer" value={<Link className="text-brand" href={`/companies/${lead.company_id}`}>{lead.linked_number}</Link>} />}
            </dl>
            {lead.description && <div className="border-t border-line p-5 text-sm"><p className="mb-1 text-xs font-medium text-muted">Description</p>{lead.description}</div>}
          </Card>

          {nextStates.length > 0 && (
            <Card>
              <CardHeader title="Move pipeline stage" subtitle={`Valid next stages from ${lead.status.replace(/_/g, ' ')}`} />
              <form action={transitionLeadAction} className="flex flex-wrap items-end gap-3 p-5">
                <input type="hidden" name="id" value={lead.id} />
                <input type="hidden" name="version" value={lead.version} />
                <div className="w-44"><Field label="Move to"><select name="to" className={inputCls}>{nextStates.map((s) => <option key={s} value={s}>{s.replace(/_/g, ' ')}</option>)}</select></Field></div>
                <div className="flex-1 min-w-40"><Field label="Reason (optional)"><input name="reason" className={inputCls} /></Field></div>
                <Button type="submit">Update stage</Button>
              </form>
            </Card>
          )}
        </div>
        <ActivityTimeline entityType="lead" entityId={lead.id} />
      </div>
    </div>
  );
}

function Info({ label, value }: { label: string; value: React.ReactNode }) {
  return (
    <div>
      <dt className="text-xs font-medium text-muted">{label}</dt>
      <dd className="mt-0.5 text-ink">{value || '—'}</dd>
    </div>
  );
}
