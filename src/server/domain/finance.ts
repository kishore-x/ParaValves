import 'server-only';
import { tx } from '@/server/db';
import { nextNumber } from '@/server/numbering/engine';
import { audit, logActivity } from '@/server/audit';
import { computeLine, round2, d } from '@/lib/money';
import { AppError, Conflict } from '@/server/http/errors';
import { canTransition, INVOICE } from '@/server/workflow/machines';
import { sendMail, templates } from '@/server/mail';
import { formatMoney } from '@/lib/money';
import Decimal from 'decimal.js';
import type { AuthUser } from '@/server/auth/session';

/** Create a tax invoice from a delivered/executing sales order, with GST split. */
export async function createInvoiceFromOrder(user: AuthUser, orderId: string): Promise<{ id: string; invoice_number: string }> {
  return tx(async (c) => {
    const o = await c.one<any>(`select * from sales_orders where id=$1 and org_id=any($2)`, [orderId, user.orgIds]);
    if (!o) throw new AppError('Order not found', 404, 'NOT_FOUND');
    const co = await c.one<any>(`select * from companies where id=$1`, [o.company_id]);
    const org = await c.one<any>(`select * from organizations where id=$1`, [o.org_id]);
    const lines = await c.query<any>(`select * from sales_order_lines where sales_order_id=$1 order by line_no`, [orderId]);
    if (!lines.length) throw new AppError('Order has no lines', 422, 'NO_LINES');

    const isExport = !!(co?.tax_treatment === 'EXPORT' || (co?.country && co.country !== 'IN'));
    const intraState = !isExport && org?.state_code && co?.state_code && org.state_code === co.state_code;

    let subtotal = new Decimal(0), cgst = new Decimal(0), sgst = new Decimal(0), igst = new Decimal(0);
    const invNumber = await nextNumber(c, o.org_id, 'INV');
    const inv = (await c.query<{ id: string }>(
      `insert into invoices (org_id, invoice_number, company_id, sales_order_id, status, currency, invoice_date, due_date, place_of_supply, is_export, created_by, updated_by)
       values ($1,$2,$3,$4,'DRAFT',$5, current_date, current_date + interval '30 days', $6, $7, $8, $8) returning id`,
      [o.org_id, invNumber, o.company_id, orderId, o.currency, co?.state_code ?? null, isExport, user.id]))[0]!;

    let n = 1;
    for (const l of lines) {
      const cl = computeLine({ quantity: l.quantity, unit_price: l.unit_price, discount_pct: l.discount_pct, tax_rate: isExport ? 0 : l.tax_rate });
      subtotal = subtotal.plus(cl.taxable);
      const taxAmt = d(cl.tax);
      if (!isExport) {
        if (intraState) { cgst = cgst.plus(taxAmt.div(2)); sgst = sgst.plus(taxAmt.div(2)); }
        else igst = igst.plus(taxAmt);
      }
      await c.query(
        `insert into invoice_lines (invoice_id, line_no, product_id, description, hsn_sac, quantity, unit_price, tax_rate, taxable_value, tax_amount, line_total)
         values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)`,
        [inv.id, n, l.product_id, l.description, null, l.quantity, l.unit_price, isExport ? 0 : l.tax_rate, cl.taxable, cl.tax, cl.total]);
      n++;
    }
    const rawTotal = subtotal.plus(cgst).plus(sgst).plus(igst);
    const grand = rawTotal.toDecimalPlaces(0, Decimal.ROUND_HALF_UP);
    const roundOff = grand.minus(rawTotal);
    await c.query(
      `update invoices set subtotal=$1, cgst=$2, sgst=$3, igst=$4, round_off=$5, grand_total=$6 where id=$7`,
      [round2(subtotal), round2(cgst), round2(sgst), round2(igst), round2(roundOff), round2(grand), inv.id]);

    await logActivity(o.org_id, 'order', orderId, 'system', `Invoice ${invNumber} generated`, user, c);
    await logActivity(o.org_id, 'invoice', inv.id, 'system', `Invoice ${invNumber} created (${round2(grand)})`, user, c);
    await audit({ orgId: o.org_id, actorId: user.id, actorName: user.name, action: 'invoice.create', entityType: 'invoice', entityId: inv.id, after: { invNumber, grand: round2(grand) } }, c);
    return { id: inv.id, invoice_number: invNumber };
  });
}

export async function transitionInvoice(user: AuthUser, id: string, to: string, version: number) {
  return tx(async (c) => {
    const inv = await c.one<any>(`select * from invoices where id=$1 and org_id=any($2)`, [id, user.orgIds]);
    if (!inv) throw new AppError('Invoice not found', 404, 'NOT_FOUND');
    if (!canTransition(INVOICE, inv.status, to)) throw new AppError(`Cannot move invoice from ${inv.status} to ${to}`, 422, 'INVALID_TRANSITION');
    const upd = await c.query(`update invoices set status=$1, updated_by=$2 where id=$3 and version=$4 returning id`, [to, user.id, id, version]);
    if (upd.length === 0) throw Conflict();
    await c.query(`insert into status_transitions (org_id, entity_type, entity_id, from_status, to_status, actor_id, actor_name) values ($1,'invoice',$2,$3,$4,$5,$6)`, [inv.org_id, id, inv.status, to, user.id, user.name]);
    await logActivity(inv.org_id, 'invoice', id, 'status', `Status ${inv.status} → ${to}`, user, c);
    await audit({ orgId: inv.org_id, actorId: user.id, actorName: user.name, action: 'invoice.transition', entityType: 'invoice', entityId: id, before: { status: inv.status }, after: { status: to } }, c);
    if (to === 'ISSUED') {
      const meta = await c.one<{ email: string | null; name: string }>(`select coalesce(ct.email,'') email, co.name from companies co left join contacts ct on ct.company_id=co.id and ct.is_primary where co.id=$1 limit 1`, [inv.company_id]);
      const t = templates.invoiceIssued(inv.invoice_number, meta?.name ?? 'Customer', formatMoney(inv.grand_total, inv.currency), inv.due_date ? new Date(inv.due_date).toLocaleDateString('en-GB') : '');
      await sendMail({ orgId: inv.org_id, to: meta?.email || 'customer@example.com', subject: t.subject, event: 'invoice.issued', body: t.body }, c);
    }
  });
}

/** Record a payment and allocate to an invoice; updates paid_amount and status. */
export async function recordPayment(user: AuthUser, invoiceId: string, amount: number, method?: string, reference?: string): Promise<{ id: string; payment_number: string }> {
  if (amount <= 0) throw new AppError('Amount must be positive', 422, 'BAD_AMOUNT');
  return tx(async (c) => {
    const inv = await c.one<any>(`select * from invoices where id=$1 and org_id=any($2) for update`, [invoiceId, user.orgIds]);
    if (!inv) throw new AppError('Invoice not found', 404, 'NOT_FOUND');
    const outstanding = Number(inv.grand_total) - Number(inv.paid_amount);
    if (amount > outstanding + 0.01) throw new AppError(`Payment ${amount} exceeds outstanding ${outstanding.toFixed(2)}`, 422, 'OVERPAY');

    const payNumber = await nextNumber(c, inv.org_id, 'PAY');
    const pay = (await c.query<{ id: string }>(
      `insert into payments (org_id, payment_number, company_id, amount, currency, method, reference, created_by)
       values ($1,$2,$3,$4,$5,$6,$7,$8) returning id`,
      [inv.org_id, payNumber, inv.company_id, amount, inv.currency, method ?? null, reference ?? null, user.id]))[0]!;
    await c.query(`insert into payment_allocations (payment_id, invoice_id, amount) values ($1,$2,$3)`, [pay.id, invoiceId, amount]);

    const newPaid = Number(inv.paid_amount) + amount;
    const newStatus = newPaid >= Number(inv.grand_total) - 0.01 ? 'PAID' : 'PARTIALLY_PAID';
    await c.query(`update invoices set paid_amount=$1, status=$2, updated_by=$3 where id=$4`, [newPaid, newStatus, user.id, invoiceId]);
    await logActivity(inv.org_id, 'invoice', invoiceId, 'system', `Payment ${payNumber} recorded: ${amount}`, user, c);
    await audit({ orgId: inv.org_id, actorId: user.id, actorName: user.name, action: 'payment.create', entityType: 'payment', entityId: pay.id, after: { amount, invoiceId } }, c);
    return { id: pay.id, payment_number: payNumber };
  });
}
