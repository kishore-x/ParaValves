import Link from 'next/link';
import { notFound } from 'next/navigation';
import { requireUser } from '@/server/auth/action';
import { one, query } from '@/server/db';
import { ORDER } from '@/server/workflow/machines';
import { Card, CardHeader, PageHeader, StatusPill, Table, Th, Td, Button, Field, inputCls, EmptyState } from '@/components/ui';
import { ActivityTimeline } from '@/components/timeline';
import { formatMoney } from '@/lib/money';
import { fmtDate, num } from '@/lib/format';
import { transitionOrderAction, createInvoiceAction } from '../actions';

export default async function OrderDetail({ params }: { params: Promise<{ id: string }> }) {
  const user = await requireUser();
  const { id } = await params;
  const o = await one<any>(
    `select o.*, c.name company, c.id company_id, q.quote_number
     from sales_orders o join companies c on c.id=o.company_id left join quotations q on q.id=o.quotation_id
     where o.id=$1 and o.org_id=any($2)`, [id, user.orgIds]);
  if (!o) notFound();

  const [lines, mrs, drawings, project, invoices, po] = await Promise.all([
    query<any>(`select * from sales_order_lines where sales_order_id=$1 order by line_no`, [id]),
    query<any>(`select m.*, p.name product from material_requirements m join products p on p.id=m.product_id where m.sales_order_id=$1`, [id]),
    query<any>(`select id, drawing_number, title, status from drawings where sales_order_id=$1`, [id]),
    one<any>(`select * from projects where sales_order_id=$1`, [id]),
    query<any>(`select id, invoice_number, status, grand_total, paid_amount from invoices where sales_order_id=$1`, [id]),
    query<any>(`select id, po_number, status from purchase_orders where id in (select distinct pol.purchase_order_id from purchase_order_lines pol) limit 5`, []),
  ]);
  const next = ORDER[o.status] ?? [];
  const totalShortage = mrs.reduce((a, m) => a + Number(m.shortage_qty), 0);
  const hasReleasedDrawing = drawings.some((d) => d.status === 'RELEASED');

  // 360 summary cells
  const cells = [
    { label: 'Customer', value: <Link href={`/companies/${o.company_id}`} className="text-brand">{o.company}</Link> },
    { label: 'Quote', value: o.quote_number ? <Link href={`/quotes/${o.quotation_id}`} className="text-brand">{o.quote_number}</Link> : '—' },
    { label: 'Order value', value: formatMoney(o.grand_total, o.currency) },
    { label: 'Engineering', value: o.requires_drawing_approval ? (hasReleasedDrawing ? '✓ Drawing released' : 'Pending drawing') : 'Not required' },
    { label: 'Material', value: totalShortage > 0 ? `⚠ ${totalShortage} short` : '✓ Covered' },
    { label: 'Project', value: project ? <Link href={`/projects/${project.id}`} className="text-brand">{num(project.progress_pct)}%</Link> : '—' },
    { label: 'Invoice', value: invoices.length ? <Link href={`/invoices/${invoices[0].id}`} className="text-brand">{invoices[0].invoice_number ?? 'View'}</Link> : 'Pending' },
    { label: 'Payment', value: invoices.length ? formatMoney(invoices.reduce((a, i) => a + Number(i.paid_amount), 0), o.currency) : 'Pending' },
  ];

  return (
    <div>
      <PageHeader title={o.order_number} subtitle="Order 360 — the whole situation on one screen"
        action={<div className="flex items-center gap-2"><Button href={`/orders/${o.id}/review`} variant="ghost" size="sm">Order review</Button><StatusPill status={o.status} /></div>} />

      {/* 360 grid */}
      <div className="mb-5 grid grid-cols-2 gap-3 sm:grid-cols-4">
        {cells.map((c) => (
          <Card key={c.label} className="p-3.5">
            <p className="text-xs font-medium text-muted">{c.label}</p>
            <p className="mt-1 text-sm font-semibold text-ink">{c.value}</p>
          </Card>
        ))}
      </div>

      <div className="grid gap-5 lg:grid-cols-3">
        <div className="space-y-5 lg:col-span-2">
          <Card>
            <CardHeader title="Line items" />
            <Table>
              <thead><tr><Th>#</Th><Th>Description</Th><Th>Qty</Th><Th>Unit</Th><Th className="text-right">Total</Th></tr></thead>
              <tbody>{lines.map((l) => (
                <tr key={l.id}><Td>{l.line_no}</Td><Td>{l.description}</Td><Td>{num(l.quantity)}</Td>
                  <Td>{formatMoney(l.unit_price, o.currency)}</Td><Td className="text-right font-medium">{formatMoney(l.line_total, o.currency)}</Td></tr>
              ))}</tbody>
            </Table>
          </Card>

          <Card>
            <CardHeader title="Material requirements (MRP)" subtitle="Understands stock, not just records it" />
            {mrs.length === 0 ? <EmptyState title="No material requirements" /> : (
              <Table>
                <thead><tr><Th>Product</Th><Th>Required</Th><Th>Available</Th><Th>Incoming</Th><Th>Shortage</Th><Th>Status</Th></tr></thead>
                <tbody>{mrs.map((m) => (
                  <tr key={m.id}>
                    <Td>{m.product}</Td><Td>{num(m.required_qty)}</Td><Td>{num(m.available_qty)}</Td>
                    <Td>{num(m.incoming_qty)}</Td>
                    <Td className={Number(m.shortage_qty) > 0 ? 'font-semibold text-danger' : 'text-ok'}>{num(m.shortage_qty)}</Td>
                    <Td><StatusPill status={m.status} /></Td>
                  </tr>
                ))}</tbody>
              </Table>
            )}
            {totalShortage > 0 && (
              <div className="border-t border-line p-4 text-sm">
                <p className="text-warn">⚠ {totalShortage} units short. <Link href="/procurement/new" className="font-medium text-brand">Raise a purchase order →</Link></p>
              </div>
            )}
          </Card>

          {drawings.length > 0 && (
            <Card>
              <CardHeader title="Drawings" />
              <Table><thead><tr><Th>Number</Th><Th>Title</Th><Th>Status</Th></tr></thead>
                <tbody>{drawings.map((d) => (
                  <tr key={d.id}><Td><Link href={`/engineering/${d.id}`} className="text-brand">{d.drawing_number}</Link></Td><Td>{d.title}</Td><Td><StatusPill status={d.status} /></Td></tr>
                ))}</tbody></Table>
            </Card>
          )}

          <Card>
            <CardHeader title="Workflow" subtitle={`Current stage: ${o.status.replace(/_/g,' ')}`} />
            <div className="space-y-3 p-5">
              {next.length > 0 ? (
                <form action={transitionOrderAction} className="flex flex-wrap items-end gap-3">
                  <input type="hidden" name="id" value={o.id} /><input type="hidden" name="version" value={o.version} />
                  <div className="w-52"><Field label="Advance to"><select name="to" className={inputCls}>{next.map((s) => <option key={s} value={s}>{s.replace(/_/g,' ')}</option>)}</select></Field></div>
                  <div className="flex-1 min-w-40"><Field label="Reason (optional)"><input name="reason" className={inputCls} /></Field></div>
                  <Button type="submit">Advance</Button>
                </form>
              ) : <p className="text-sm text-muted">This order is in a terminal state.</p>}
              {(o.status === 'DELIVERY' || o.status === 'INVOICING') && invoices.length === 0 && (
                <form action={createInvoiceAction}><input type="hidden" name="id" value={o.id} />
                  <Button type="submit" variant="ghost">Generate Tax Invoice</Button></form>
              )}
            </div>
          </Card>
        </div>
        <ActivityTimeline entityType="order" entityId={o.id} />
      </div>
    </div>
  );
}
