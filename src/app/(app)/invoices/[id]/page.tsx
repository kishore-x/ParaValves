import Link from 'next/link';
import { notFound } from 'next/navigation';
import { requireUser } from '@/server/auth/action';
import { one, query } from '@/server/db';
import { INVOICE } from '@/server/workflow/machines';
import { Card, CardHeader, PageHeader, StatusPill, Table, Th, Td, Button, Field, inputCls } from '@/components/ui';
import { formatMoney } from '@/lib/money';
import { fmtDate, num } from '@/lib/format';
import { transitionInvoiceAction, recordPaymentAction } from '../actions';

export default async function InvoiceDetail({ params }: { params: Promise<{ id: string }> }) {
  const user = await requireUser();
  const { id } = await params;
  const inv = await one<any>(`select i.*, c.name company, c.gstin, o.order_number, o.id order_id from invoices i join companies c on c.id=i.company_id left join sales_orders o on o.id=i.sales_order_id where i.id=$1 and i.org_id=any($2)`, [id, user.orgIds]);
  if (!inv) notFound();
  const lines = await query<any>(`select * from invoice_lines where invoice_id=$1 order by line_no`, [id]);
  const payments = await query<any>(`select p.payment_number, pa.amount, p.paid_at, p.method from payment_allocations pa join payments p on p.id=pa.payment_id where pa.invoice_id=$1 order by p.paid_at desc`, [id]);
  const next = INVOICE[inv.status] ?? [];
  const outstanding = Number(inv.grand_total) - Number(inv.paid_amount);

  return (
    <div>
      <PageHeader title={inv.invoice_number} subtitle={<Link href={`/companies/${inv.company_id}`} className="text-brand">{inv.company}</Link>}
        action={<><Button href={`/api/invoices/${inv.id}/pdf`} variant="ghost" size="sm" icon="file">PDF</Button><StatusPill status={inv.status} /></>} />
      <div className="grid gap-5 lg:grid-cols-3">
        <div className="space-y-5 lg:col-span-2">
          <Card>
            <CardHeader title="Tax invoice" subtitle={`${inv.is_export ? 'Export invoice' : 'GST invoice'}${inv.order_number ? ` · Order ${inv.order_number}` : ''}`} />
            <dl className="grid grid-cols-2 gap-x-6 gap-y-2 p-5 text-sm sm:grid-cols-4">
              <I l="Invoice date" v={fmtDate(inv.invoice_date)} /><I l="Due date" v={fmtDate(inv.due_date)} />
              <I l="GSTIN" v={inv.gstin} /><I l="Place of supply" v={inv.place_of_supply} />
            </dl>
            <Table>
              <thead><tr><Th>#</Th><Th>Description</Th><Th>Qty</Th><Th>Rate</Th><Th>Taxable</Th><Th>Tax</Th><Th className="text-right">Total</Th></tr></thead>
              <tbody>{lines.map((l) => (
                <tr key={l.id}><Td>{l.line_no}</Td><Td>{l.description}</Td><Td>{num(l.quantity)}</Td>
                  <Td>{formatMoney(l.unit_price, inv.currency)}</Td><Td>{formatMoney(l.taxable_value, inv.currency)}</Td>
                  <Td>{formatMoney(l.tax_amount, inv.currency)}</Td><Td className="text-right font-medium">{formatMoney(l.line_total, inv.currency)}</Td></tr>
              ))}</tbody>
            </Table>
            <div className="flex justify-end p-4">
              <div className="w-64 space-y-1 text-sm">
                <Row l="Taxable value" v={formatMoney(inv.subtotal, inv.currency)} />
                {Number(inv.cgst) > 0 && <Row l="CGST" v={formatMoney(inv.cgst, inv.currency)} />}
                {Number(inv.sgst) > 0 && <Row l="SGST" v={formatMoney(inv.sgst, inv.currency)} />}
                {Number(inv.igst) > 0 && <Row l="IGST" v={formatMoney(inv.igst, inv.currency)} />}
                {Number(inv.round_off) !== 0 && <Row l="Round off" v={formatMoney(inv.round_off, inv.currency)} />}
                <div className="mt-1 flex justify-between border-t border-line pt-1 text-base font-semibold"><span>Grand total</span><span>{formatMoney(inv.grand_total, inv.currency)}</span></div>
                <Row l="Paid" v={formatMoney(inv.paid_amount, inv.currency)} />
                <div className="flex justify-between font-medium text-warn"><span>Outstanding</span><span>{formatMoney(outstanding, inv.currency)}</span></div>
              </div>
            </div>
          </Card>

          {next.length > 0 && (
            <Card>
              <CardHeader title="Update status" />
              <form action={transitionInvoiceAction} className="flex items-end gap-3 p-5">
                <input type="hidden" name="id" value={inv.id} /><input type="hidden" name="version" value={inv.version} />
                <div className="w-56"><Field label="Move to"><select name="to" className={inputCls}>{next.map((s) => <option key={s} value={s}>{s.replace(/_/g,' ')}</option>)}</select></Field></div>
                <Button type="submit">Update</Button>
              </form>
            </Card>
          )}
        </div>

        <div className="space-y-5">
          {outstanding > 0.01 && inv.status !== 'DRAFT' && (
            <Card>
              <CardHeader title="Record payment" />
              <form action={recordPaymentAction} className="space-y-3 p-5">
                <input type="hidden" name="id" value={inv.id} />
                <Field label="Amount" required><input name="amount" type="number" step="any" max={outstanding} defaultValue={outstanding.toFixed(2)} className={inputCls} /></Field>
                <Field label="Method"><select name="method" className={inputCls}><option>BANK_TRANSFER</option><option>UPI</option><option>CHEQUE</option><option>CASH</option></select></Field>
                <Field label="Reference"><input name="reference" className={inputCls} /></Field>
                <Button type="submit">Record Payment</Button>
              </form>
            </Card>
          )}
          <Card>
            <CardHeader title="Payments" />
            {payments.length === 0 ? <p className="p-5 text-sm text-muted">No payments yet.</p> : (
              <Table><thead><tr><Th>Payment</Th><Th>Amount</Th><Th>Date</Th></tr></thead>
                <tbody>{payments.map((p, i) => <tr key={i}><Td className="font-mono">{p.payment_number}</Td><Td>{formatMoney(p.amount, inv.currency)}</Td><Td>{fmtDate(p.paid_at)}</Td></tr>)}</tbody></Table>
            )}
          </Card>
        </div>
      </div>
    </div>
  );
}
function I({ l, v }: { l: string; v: React.ReactNode }) { return <div><dt className="text-xs font-medium text-muted">{l}</dt><dd className="mt-0.5 text-ink">{v || '—'}</dd></div>; }
function Row({ l, v }: { l: string; v: string }) { return <div className="flex justify-between text-muted"><span>{l}</span><span className="text-ink">{v}</span></div>; }
