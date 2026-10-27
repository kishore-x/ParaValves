import Link from 'next/link';
import { notFound } from 'next/navigation';
import { requireUser } from '@/server/auth/action';
import { one, query } from '@/server/db';
import { QUOTE } from '@/server/workflow/machines';
import { Card, CardHeader, PageHeader, StatusPill, Table, Th, Td, Button, Field, inputCls } from '@/components/ui';
import { ActivityTimeline } from '@/components/timeline';
import { formatMoney } from '@/lib/money';
import { fmtDate, num } from '@/lib/format';
import { transitionQuoteAction, convertQuoteAction } from '../actions';

export default async function QuoteDetail({ params }: { params: Promise<{ id: string }> }) {
  const user = await requireUser();
  const { id } = await params;
  const q = await one<any>(
    `select q.*, c.name company, c.id company_id from quotations q join companies c on c.id=q.company_id
     where q.id=$1 and q.org_id=any($2)`, [id, user.orgIds]);
  if (!q) notFound();
  const lines = await query<any>(`select * from quotation_lines where quotation_id=$1 order by line_no`, [id]);
  const order = await one<any>(`select id, order_number from sales_orders where quotation_id=$1`, [id]);
  const nextStates = QUOTE[q.status] ?? [];

  return (
    <div>
      <PageHeader title={q.quote_number} subtitle={<Link href={`/companies/${q.company_id}`} className="text-brand">{q.company}</Link>}
        action={<div className="flex items-center gap-2"><Button href={`/api/quotes/${q.id}/pdf`} variant="ghost" size="sm" icon="file">PDF</Button><StatusPill status={q.status} />
          {order ? <Button href={`/orders/${order.id}`} size="sm" variant="ghost">View {order.order_number}</Button>
            : (q.status === 'ACCEPTED' || q.status === 'SENT' || q.status === 'VIEWED' || q.status === 'NEGOTIATION') &&
              <form action={convertQuoteAction}><input type="hidden" name="id" value={q.id} /><Button type="submit" size="sm">Convert to Order</Button></form>}
        </div>} />

      <div className="grid gap-5 lg:grid-cols-3">
        <div className="space-y-5 lg:col-span-2">
          <Card>
            <CardHeader title="Line items" />
            <Table>
              <thead><tr><Th>#</Th><Th>Description</Th><Th>Qty</Th><Th>Unit</Th><Th>Disc%</Th><Th>Tax%</Th><Th className="text-right">Total</Th></tr></thead>
              <tbody>{lines.map((l) => (
                <tr key={l.id}><Td>{l.line_no}</Td><Td>{l.description}</Td><Td>{num(l.quantity)}</Td>
                  <Td>{formatMoney(l.unit_price, q.currency)}</Td><Td>{num(l.discount_pct)}</Td><Td>{num(l.tax_rate)}</Td>
                  <Td className="text-right font-medium">{formatMoney(l.line_total, q.currency)}</Td></tr>
              ))}</tbody>
            </Table>
            <div className="flex justify-end p-4">
              <div className="w-64 space-y-1 text-sm">
                <Row l="Subtotal" v={formatMoney(q.subtotal, q.currency)} />
                <Row l="Discount" v={`− ${formatMoney(q.discount_total, q.currency)}`} />
                <Row l="Tax" v={formatMoney(q.tax_total, q.currency)} />
                <div className="mt-1 flex justify-between border-t border-line pt-1 text-base font-semibold"><span>Grand total</span><span>{formatMoney(q.grand_total, q.currency)}</span></div>
              </div>
            </div>
          </Card>

          {nextStates.length > 0 && (
            <Card>
              <CardHeader title="Update status" subtitle={`Valid next states from ${q.status.replace(/_/g,' ')}`} />
              <form action={transitionQuoteAction} className="flex flex-wrap items-end gap-3 p-5">
                <input type="hidden" name="id" value={q.id} /><input type="hidden" name="version" value={q.version} />
                <div className="w-52"><Field label="Move to"><select name="to" className={inputCls}>{nextStates.map((s) => <option key={s} value={s}>{s.replace(/_/g,' ')}</option>)}</select></Field></div>
                <Button type="submit">Update</Button>
              </form>
            </Card>
          )}
        </div>
        <ActivityTimeline entityType="quote" entityId={q.id} />
      </div>
    </div>
  );
}
function Row({ l, v }: { l: string; v: string }) { return <div className="flex justify-between text-muted"><span>{l}</span><span className="text-ink">{v}</span></div>; }
