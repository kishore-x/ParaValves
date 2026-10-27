import { requireUser } from '@/server/auth/action';
import { query } from '@/server/db';
import { APPROVAL_LIMIT } from '@/server/domain/governance';
import { can } from '@/server/auth/rbac';
import { Card, CardHeader, Table, Th, Td, StatusPill, PageHeader, Field, Button, inputCls, Badge, EmptyState } from '@/components/ui';
import { Flash } from '@/components/flash';
import { formatMoney } from '@/lib/money';
import { fmtDateTime } from '@/lib/format';
import { decideApprovalAction, requestApprovalAction } from '../mfg-actions';

export default async function ApprovalsPage({ searchParams }: { searchParams: Promise<{ error?: string; ok?: string }> }) {
  const sp = await searchParams;
  const user = await requireUser();
  const rows = await query<any>(`select a.*, m.name maker, c.name checker from approval_requests a join users m on m.id=a.maker_id left join users c on c.id=a.checker_id where a.org_id=$1 order by (a.status='PENDING') desc, a.created_at desc limit 80`, [user.currentOrgId]);
  const pending = rows.filter((r: any) => r.status === 'PENDING');
  return (
    <div className="space-y-6">
      <PageHeader title="Approvals" subtitle={`Maker-checker: nobody approves their own request. Items above ${formatMoney(APPROVAL_LIMIT)} need a senior approver.`} />
      <Flash error={sp.error} ok={sp.ok} />
      <Card>
        <CardHeader title={`Pending (${pending.length})`} />
        {pending.length === 0 ? <EmptyState title="Nothing awaiting approval" /> : (
          <Table><thead><tr><Th>Type</Th><Th>Item</Th><Th>Amount</Th><Th>Maker</Th><Th>Raised</Th><Th>Decision</Th></tr></thead>
            <tbody>{pending.map((a: any) => { const own = a.maker_id === user.id; return (
              <tr key={a.id} className="align-top"><Td><Badge tone="info">{a.kind.replace('_', ' ')}</Badge></Td><Td className="font-medium">{a.entity_label}{a.reason && <div className="text-xs font-normal text-muted">{a.reason}</div>}</Td><Td>{a.amount ? formatMoney(a.amount) : '—'}{a.amount && Number(a.amount) > APPROVAL_LIMIT && <div className="text-2xs text-warn">senior approval</div>}</Td><Td>{a.maker}</Td><Td className="text-xs text-faint">{fmtDateTime(a.created_at)}</Td>
                <Td>{own ? <span className="text-xs text-muted">You raised this — a different user must approve</span> : can(user, 'approval.approve') ? (
                  <form action={decideApprovalAction} className="flex flex-col gap-1.5"><input type="hidden" name="id" value={a.id} /><input name="note" placeholder="Note" className={`${inputCls} !h-8`} />
                    <div className="flex gap-1.5"><button name="decision" value="approve" className="h-8 rounded-lg bg-ok px-3 text-xs font-medium text-white">Approve</button><button name="decision" value="reject" className="h-8 rounded-lg bg-danger px-3 text-xs font-medium text-white">Reject</button></div></form>) : <span className="text-xs text-muted">No approval rights</span>}</Td></tr>); })}</tbody></Table>)}
      </Card>
      <Card>
        <CardHeader title="Decided" />
        <Table><thead><tr><Th>Type</Th><Th>Item</Th><Th>Status</Th><Th>Maker → Checker</Th><Th>Note</Th></tr></thead>
          <tbody>{rows.filter((r: any) => r.status !== 'PENDING').map((a: any) => <tr key={a.id}><Td>{a.kind.replace('_', ' ')}</Td><Td>{a.entity_label}</Td><Td><StatusPill status={a.status} /></Td><Td className="text-xs">{a.maker} → {a.checker}</Td><Td className="text-xs text-muted">{a.decision_note ?? ''}</Td></tr>)}</tbody></Table>
      </Card>
      <Card>
        <CardHeader title="Request an approval" subtitle="e.g. a discount beyond policy, or a credit override" />
        <form action={requestApprovalAction} className="grid gap-3 p-5 md:grid-cols-5">
          <Field label="Type"><select name="kind" className={inputCls}><option value="QUOTE_DISCOUNT">Quote discount</option><option value="PO_VALUE">PO value</option><option value="CREDIT_OVERRIDE">Credit override</option><option value="SHIPMENT_OVERRIDE">Shipment override</option></select></Field>
          <Field label="Reference"><input name="entity_label" required placeholder="e.g. QUO-2026-000004" className={inputCls} /></Field>
          <Field label="Amount (₹)"><input name="amount" type="number" className={inputCls} /></Field>
          <Field label="Reason"><input name="reason" className={inputCls} /></Field>
          <div className="flex items-end"><Button type="submit">Request</Button></div>
        </form>
      </Card>
    </div>
  );
}
