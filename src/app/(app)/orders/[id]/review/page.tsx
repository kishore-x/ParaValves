import { notFound } from 'next/navigation';
import { requireUser } from '@/server/auth/action';
import { one } from '@/server/db';
import { REVIEW_KEYS } from '@/server/domain/governance';
import { Card, CardHeader, PageHeader, Button, Field, inputCls, Badge } from '@/components/ui';
import { Flash } from '@/components/flash';
import { fmtDateTime } from '@/lib/format';
import { orderReviewAction } from '../../../mfg-actions';

const LABELS: Record<string, string> = { po_ok: 'Customer PO received & matches', spec_ok: 'Specification complete & technically feasible', price_ok: 'Price matches quotation', terms_ok: 'Commercial terms agreed', credit_ok: 'Credit check passed', capacity_ok: 'Capacity & material available', date_ok: 'Requested delivery date achievable' };

export default async function OrderReview({ params, searchParams }: { params: Promise<{ id: string }>; searchParams: Promise<{ error?: string; ok?: string }> }) {
  const { id } = await params; const sp = await searchParams;
  const user = await requireUser();
  const o = await one<any>(`select so.*, co.name customer from sales_orders so join companies co on co.id=so.company_id where so.id=$1 and so.org_id=any($2)`, [id, user.orgIds]);
  if (!o) notFound();
  const r = (await one<any>(`select * from order_reviews where sales_order_id=$1`, [id])) ?? {};
  return (
    <div className="space-y-6">
      <PageHeader title={`Order review · ${o.order_number}`} subtitle={`${o.customer} · customer PO ${o.customer_po_ref ?? '—'}`} action={<Button href={`/orders/${id}`} variant="ghost">Back to order</Button>} />
      <Flash error={sp.error} ok={sp.ok} />
      <Card>
        <CardHeader title="Validation checklist" subtitle="All items must be validated before an acknowledgement is issued to the customer" action={r.acknowledged_at ? <Badge tone="ok">Acknowledged {fmtDateTime(r.acknowledged_at)}</Badge> : <Badge tone="warn">Not acknowledged</Badge>} />
        <form action={orderReviewAction} className="space-y-4 p-5">
          <input type="hidden" name="id" value={id} />
          <div className="grid gap-2 md:grid-cols-2">{REVIEW_KEYS.map((k) => <label key={k} className="flex items-center gap-2 rounded-lg border border-line px-3 py-2 text-sm"><input type="checkbox" name={k} defaultChecked={!!r[k]} />{LABELS[k]}</label>)}</div>
          <Field label="Differences vs PO / quotation (if any)"><textarea name="differences" defaultValue={r.differences ?? ''} rows={2} className={`${inputCls} !h-auto py-2`} /></Field>
          <div className="flex flex-wrap items-end gap-3">
            <Field label="Confirmed promise date"><input name="promise_date" type="date" defaultValue={r.promise_date ? new Date(r.promise_date).toISOString().slice(0, 10) : ''} className={inputCls} /></Field>
            <label className="flex items-center gap-2 pb-2 text-sm"><input type="checkbox" name="acknowledge" />Issue order acknowledgement</label>
            <Button type="submit">Save review</Button>
          </div>
        </form>
      </Card>
    </div>
  );
}
