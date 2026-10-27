import Link from 'next/link';
import { notFound } from 'next/navigation';
import { requireUser } from '@/server/auth/action';
import { one, query } from '@/server/db';
import { Card, CardHeader, PageHeader, Table, Th, Td, StatusPill, EmptyState, Button, Field, inputCls } from '@/components/ui';
import { ActivityTimeline } from '@/components/timeline';
import { formatMoney } from '@/lib/money';
import { fmtDate } from '@/lib/format';
import { addContactAction } from '../actions';

export default async function CompanyDetail({ params }: { params: Promise<{ id: string }> }) {
  const user = await requireUser();
  const { id } = await params;
  const co = await one<any>(`select * from companies where id=$1 and org_id=any($2)`, [id, user.orgIds]);
  if (!co) notFound();

  const [contacts, quotes, orders, invoices, leads] = await Promise.all([
    query<any>(`select * from contacts where company_id=$1 order by is_primary desc, name`, [id]),
    query<any>(`select id, quote_number, status, grand_total, created_at from quotations where company_id=$1 order by created_at desc limit 10`, [id]),
    query<any>(`select id, order_number, status, grand_total, created_at from sales_orders where company_id=$1 order by created_at desc limit 10`, [id]),
    query<any>(`select id, invoice_number, status, grand_total, paid_amount, due_date from invoices where company_id=$1 order by created_at desc limit 10`, [id]),
    query<any>(`select id, lead_number, status from leads where company_id=$1 order by created_at desc limit 10`, [id]),
  ]);
  const outstanding = invoices.reduce((a, i) => a + (Number(i.grand_total) - Number(i.paid_amount)), 0);

  return (
    <div>
      <PageHeader title={co.name} subtitle={`${co.company_number} · ${[co.is_customer && 'Customer', co.is_supplier && 'Supplier'].filter(Boolean).join(' · ')}`} />
      <div className="mb-5 grid grid-cols-2 gap-3 sm:grid-cols-4">
        <Mini label="Leads" value={leads.length} />
        <Mini label="Quotes" value={quotes.length} />
        <Mini label="Orders" value={orders.length} />
        <Mini label="Outstanding" value={formatMoney(outstanding, co.currency)} />
      </div>

      <div className="grid gap-5 lg:grid-cols-3">
        <div className="space-y-5 lg:col-span-2">
          <Card>
            <CardHeader title="Profile" />
            <dl className="grid grid-cols-2 gap-x-6 gap-y-3 p-5 text-sm sm:grid-cols-3">
              <I label="Country" v={co.country} /><I label="State" v={co.state_code} /><I label="City" v={co.city} />
              <I label="GSTIN" v={co.gstin} /><I label="Tax" v={co.tax_treatment} /><I label="Currency" v={co.currency} />
              <I label="Payment terms" v={co.payment_terms} />
            </dl>
          </Card>

          <Card>
            <CardHeader title="Contacts" action={null} />
            {contacts.length === 0 ? <EmptyState title="No contacts" /> : (
              <Table>
                <thead><tr><Th>Name</Th><Th>Designation</Th><Th>Email</Th><Th>Phone</Th></tr></thead>
                <tbody>{contacts.map((ct) => (
                  <tr key={ct.id}><Td>{ct.name}{ct.is_primary && <span className="ml-1 text-2xs text-ok">(primary)</span>}</Td><Td>{ct.designation ?? '—'}</Td><Td>{ct.email ?? '—'}</Td><Td>{ct.phone ?? '—'}</Td></tr>
                ))}</tbody>
              </Table>
            )}
            <form action={addContactAction} className="grid gap-3 border-t border-line p-4 sm:grid-cols-4">
              <input type="hidden" name="company_id" value={co.id} />
              <input name="name" placeholder="Name" required className={inputCls} />
              <input name="designation" placeholder="Designation" className={inputCls} />
              <input name="email" placeholder="Email" className={inputCls} />
              <div className="flex gap-2"><input name="phone" placeholder="Phone" className={inputCls} /><Button type="submit" size="sm">Add</Button></div>
            </form>
          </Card>

          <RelatedTable title="Orders" rows={orders} base="/orders/" numKey="order_number" />
          <RelatedTable title="Quotations" rows={quotes} base="/quotes/" numKey="quote_number" />
          <RelatedTable title="Invoices" rows={invoices} base="/invoices/" numKey="invoice_number" />
        </div>
        <ActivityTimeline entityType="company" entityId={co.id} />
      </div>
    </div>
  );
}

function Mini({ label, value }: { label: string; value: React.ReactNode }) {
  return <Card className="p-3"><p className="text-xs text-muted">{label}</p><p className="mt-1 text-lg font-semibold text-ink">{value}</p></Card>;
}
function I({ label, v }: { label: string; v: React.ReactNode }) {
  return <div><dt className="text-xs font-medium text-muted">{label}</dt><dd className="mt-0.5 text-ink">{v || '—'}</dd></div>;
}
function RelatedTable({ title, rows, base, numKey }: { title: string; rows: any[]; base: string; numKey: string }) {
  return (
    <Card>
      <CardHeader title={title} />
      {rows.length === 0 ? <EmptyState title={`No ${title.toLowerCase()}`} /> : (
        <Table>
          <thead><tr><Th>Number</Th><Th>Status</Th><Th>Total</Th></tr></thead>
          <tbody>{rows.map((r) => (
            <tr key={r.id} className="hover:bg-bg">
              <Td><Link href={base + r.id} className="font-mono text-xs font-semibold text-brand">{r[numKey]}</Link></Td>
              <Td><StatusPill status={r.status} /></Td>
              <Td>{formatMoney(r.grand_total ?? 0)}</Td>
            </tr>
          ))}</tbody>
        </Table>
      )}
    </Card>
  );
}
