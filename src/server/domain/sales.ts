import 'server-only';
import { tx } from '@/server/db';
import { nextNumber } from '@/server/numbering/engine';
import { audit, logActivity } from '@/server/audit';
import { computeTotals, type LineInput } from '@/lib/money';
import { canTransition, QUOTE, ORDER } from '@/server/workflow/machines';
import { AppError, Conflict } from '@/server/http/errors';
import { sendMail, templates } from '@/server/mail';
import { formatMoney } from '@/lib/money';
import type { AuthUser } from '@/server/auth/session';

export interface QuoteLineInput extends LineInput {
  product_id?: string | null;
  description: string;
}

export async function createQuote(
  user: AuthUser,
  input: { company_id: string; contact_id?: string | null; lead_id?: string | null; currency?: string; payment_terms?: string; delivery_terms?: string; valid_until?: string; notes?: string; lines: QuoteLineInput[] },
): Promise<{ id: string; quote_number: string }> {
  if (!input.lines.length) throw new AppError('A quotation needs at least one line', 422, 'NO_LINES');
  const totals = computeTotals(input.lines);
  return tx(async (c) => {
    const quoteNumber = await nextNumber(c, user.currentOrgId, 'QUO');
    const q = (await c.query<{ id: string }>(
      `insert into quotations (org_id, quote_number, company_id, contact_id, lead_id, currency, payment_terms, delivery_terms, valid_until, notes, subtotal, discount_total, tax_total, grand_total, created_by, updated_by)
       values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$15) returning id`,
      [user.currentOrgId, quoteNumber, input.company_id, input.contact_id ?? null, input.lead_id ?? null,
       input.currency ?? 'INR', input.payment_terms ?? 'NET30', input.delivery_terms ?? null, input.valid_until || null,
       input.notes ?? null, totals.subtotal, totals.discount_total, totals.tax_total, totals.grand_total, user.id]))[0]!;
    let n = 1;
    for (const line of input.lines) {
      const cl = totals.lines[n - 1]!;
      await c.query(
        `insert into quotation_lines (quotation_id, line_no, product_id, description, quantity, unit_price, discount_pct, tax_rate, line_total)
         values ($1,$2,$3,$4,$5,$6,$7,$8,$9)`,
        [q.id, n, line.product_id ?? null, line.description, line.quantity, line.unit_price, line.discount_pct ?? 0, line.tax_rate ?? 0, cl.total]);
      n++;
    }
    await logActivity(user.currentOrgId, 'quote', q.id, 'system', `Quotation ${quoteNumber} created`, user, c);
    await audit({ orgId: user.currentOrgId, actorId: user.id, actorName: user.name, action: 'quote.create', entityType: 'quote', entityId: q.id, after: { quoteNumber, total: totals.grand_total } }, c);
    return { id: q.id, quote_number: quoteNumber };
  });
}

export async function transitionQuote(user: AuthUser, id: string, to: string, version: number) {
  return tx(async (c) => {
    const q = await c.one<{ status: string; org_id: string }>(`select status, org_id from quotations where id=$1 and org_id=any($2)`, [id, user.orgIds]);
    if (!q) throw new AppError('Quote not found', 404, 'NOT_FOUND');
    if (!canTransition(QUOTE, q.status, to)) throw new AppError(`Cannot move quote from ${q.status} to ${to}`, 422, 'INVALID_TRANSITION');
    const upd = await c.query(`update quotations set status=$1, updated_by=$2 where id=$3 and version=$4 returning id`, [to, user.id, id, version]);
    if (upd.length === 0) throw Conflict();
    await c.query(`insert into status_transitions (org_id, entity_type, entity_id, from_status, to_status, actor_id, actor_name) values ($1,'quote',$2,$3,$4,$5,$6)`, [q.org_id, id, q.status, to, user.id, user.name]);
    await logActivity(q.org_id, 'quote', id, 'status', `Status ${q.status} → ${to}`, user, c);
    await audit({ orgId: q.org_id, actorId: user.id, actorName: user.name, action: 'quote.transition', entityType: 'quote', entityId: id, before: { status: q.status }, after: { status: to } }, c);
    if (to === 'SENT') {
      // retain a frozen version of the quote exactly as sent to the customer
      await c.query(
        `insert into quotation_versions (quotation_id, version_no, snapshot, note, created_by)
         select $1, coalesce(max(version_no),0)+1,
           (select jsonb_build_object('quote', to_jsonb(q.*), 'lines', coalesce((select jsonb_agg(to_jsonb(l.*) order by l.line_no) from quotation_lines l where l.quotation_id=q.id),'[]'::jsonb)) from quotations q where q.id=$1),
           'Sent to customer', $2 from quotation_versions where quotation_id=$1`, [id, user.id]);
      const taskNumber = await nextNumber(c, q.org_id, 'TASK');
      await c.query(
        `insert into tasks (org_id, task_number, title, entity_type, entity_id, assignee_id, due_at, source_key, created_by)
         values ($1,$2,$3,'quote',$4,$5, now() + interval '3 days', $6, $7) on conflict (org_id, source_key) do nothing`,
        [q.org_id, taskNumber, `Follow up on quotation`, id, user.id, `quote-followup-${id}`, user.id]);
      const meta = await c.one<{ quote_number: string; grand_total: string; currency: string; email: string | null; name: string }>(
        `select q.quote_number, q.grand_total, q.currency, coalesce(ct.email, '') email, co.name
         from quotations q join companies co on co.id=q.company_id left join contacts ct on ct.id=q.contact_id
         where q.id=$1`, [id]);
      if (meta) {
        const t = templates.quoteSent(meta.quote_number, meta.name, formatMoney(meta.grand_total, meta.currency));
        await sendMail({ orgId: q.org_id, to: meta.email || 'customer@example.com', subject: t.subject, event: 'quote.sent', body: t.body }, c);
      }
    }
  });
}

/** One-click quote → sales order. Idempotent. Carries everything forward. */
export async function convertQuoteToOrder(user: AuthUser, quoteId: string): Promise<{ id: string; order_number: string; existed: boolean }> {
  return tx(async (c) => {
    const q = await c.one<any>(`select * from quotations where id=$1 and org_id=any($2)`, [quoteId, user.orgIds]);
    if (!q) throw new AppError('Quote not found', 404, 'NOT_FOUND');
    const existing = await c.one<{ id: string; order_number: string }>(`select id, order_number from sales_orders where quotation_id=$1`, [quoteId]);
    if (existing) return { ...existing, existed: true };
    if (q.status !== 'ACCEPTED') {
      if (!canTransition(QUOTE, q.status, 'ACCEPTED')) throw new AppError(`Quote must be ACCEPTED before conversion (currently ${q.status})`, 422, 'NOT_ACCEPTED');
      await c.query(`update quotations set status='ACCEPTED', updated_by=$1 where id=$2`, [user.id, quoteId]);
    }
    const orderNumber = await nextNumber(c, q.org_id, 'SO');
    const requiresDrawing = q.currency ? true : true; // valves are engineered-to-order → require drawing approval
    const so = (await c.query<{ id: string }>(
      `insert into sales_orders (org_id, order_number, company_id, contact_id, quotation_id, currency, exchange_rate, requires_drawing_approval, subtotal, discount_total, tax_total, grand_total, notes, created_by, updated_by)
       values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$14) returning id`,
      [q.org_id, orderNumber, q.company_id, q.contact_id, quoteId, q.currency, q.exchange_rate, requiresDrawing, q.subtotal, q.discount_total, q.tax_total, q.grand_total, q.notes, user.id]))[0]!;
    const lines = await c.query<any>(`select * from quotation_lines where quotation_id=$1 order by line_no`, [quoteId]);
    for (const l of lines) {
      await c.query(
        `insert into sales_order_lines (sales_order_id, line_no, product_id, description, quantity, unit_price, discount_pct, tax_rate, line_total)
         values ($1,$2,$3,$4,$5,$6,$7,$8,$9)`,
        [so.id, l.line_no, l.product_id, l.description, l.quantity, l.unit_price, l.discount_pct, l.tax_rate, l.line_total]);
    }
    // automation: project + engineering request + material requirements
    const projNumber = await nextNumber(c, q.org_id, 'PROJ');
    const company = await c.one<{ name: string }>(`select name from companies where id=$1`, [q.company_id]);
    const proj = (await c.query<{ id: string }>(
      `insert into projects (org_id, project_number, name, company_id, sales_order_id, status, created_by)
       values ($1,$2,$3,$4,$5,'PLANNING',$6) returning id`,
      [q.org_id, projNumber, `${orderNumber} — ${company?.name ?? 'Order'}`, q.company_id, so.id, user.id]))[0]!;
    for (const [i, ph] of ['Engineering', 'Drawing Approval', 'Procurement', 'Production', 'QC', 'Delivery'].entries()) {
      await c.query(`insert into project_tasks (project_id, name, phase, sort_order, is_mandatory_for_closure) values ($1,$2,$2,$3,$4)`,
        [proj.id, ph, i, ph === 'QC' || ph === 'Delivery']);
    }
    const erNumber = await nextNumber(c, q.org_id, 'ER');
    await c.query(`insert into engineering_requests (org_id, er_number, sales_order_id, title, created_by) values ($1,$2,$3,$4,$5)`,
      [q.org_id, erNumber, so.id, `Engineering for ${orderNumber}`, user.id]);

    // MRP for each manufactured / stocked product line
    await runMrpForOrder(c, q.org_id, so.id, user);

    await logActivity(q.org_id, 'quote', quoteId, 'system', `Converted to order ${orderNumber}`, user, c);
    await logActivity(q.org_id, 'order', so.id, 'system', `Order ${orderNumber} created from ${q.quote_number}`, user, c);
    await audit({ orgId: q.org_id, actorId: user.id, actorName: user.name, action: 'order.create_from_quote', entityType: 'order', entityId: so.id, after: { orderNumber, quoteId } }, c);
    return { id: so.id, order_number: orderNumber, existed: false };
  });
}

/** Compute material requirements for an order from stock levels. */
export async function runMrpForOrder(c: any, orgId: string, orderId: string, user: AuthUser): Promise<void> {
  const lines = await c.query(`select product_id, sum(quantity) qty from sales_order_lines where sales_order_id=$1 and product_id is not null group by product_id`, [orderId]);
  for (const l of lines) {
    const stock = await c.one(`select coalesce(sum(on_hand),0) on_hand, coalesce(sum(reserved),0) reserved, coalesce(sum(incoming),0) incoming from stock_items where org_id=$1 and product_id=$2`, [orgId, l.product_id]);
    const required = Number(l.qty);
    const available = Number(stock?.on_hand ?? 0) - Number(stock?.reserved ?? 0);
    const incoming = Number(stock?.incoming ?? 0);
    const shortage = Math.max(0, required - available - incoming);
    const mrNumber = await nextNumber(c, orgId, 'MR');
    await c.query(
      `insert into material_requirements (org_id, mr_number, sales_order_id, product_id, required_qty, available_qty, reserved_qty, incoming_qty, shortage_qty, status)
       values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)`,
      [orgId, mrNumber, orderId, l.product_id, required, Math.max(0, available), Number(stock?.reserved ?? 0), incoming, shortage, shortage > 0 ? 'OPEN' : 'COVERED']);
    if (shortage > 0) {
      const prod = await c.one(`select name from products where id=$1`, [l.product_id]);
      await c.query(`insert into notifications (org_id, user_id, category, title, body, link) values ($1,$2,'material_shortage',$3,$4,$5)`,
        [orgId, user.id, `Material shortage: ${prod?.name ?? ''}`, `${shortage} units short for order`, `/inventory`]);
    }
  }
}

export async function transitionOrder(user: AuthUser, id: string, to: string, version: number, reason?: string) {
  return tx(async (c) => {
    const o = await c.one<any>(`select * from sales_orders where id=$1 and org_id=any($2)`, [id, user.orgIds]);
    if (!o) throw new AppError('Order not found', 404, 'NOT_FOUND');
    if (!canTransition(ORDER, o.status, to)) throw new AppError(`Cannot move order from ${o.status} to ${to}`, 422, 'INVALID_TRANSITION');

    // --- GATES ---
    if (to === 'EXECUTION' && o.requires_drawing_approval) {
      const released = await c.one(`select 1 from drawings where sales_order_id=$1 and status='RELEASED' limit 1`, [id]);
      if (!released) throw new AppError('Blocked: this order requires an approved (RELEASED) drawing before execution.', 422, 'GATE_DRAWING');
    }
    if (to === 'READY') {
      const short = await c.one(`select coalesce(sum(shortage_qty),0) s from material_requirements where sales_order_id=$1 and status='OPEN'`, [id]);
      const shortQty = Number(short?.s ?? 0);
      if (shortQty > 0) throw new AppError(`Blocked: ${shortQty} units of material still short. Complete procurement before marking READY.`, 422, 'GATE_MATERIAL');
    }

    const upd = await c.query(`update sales_orders set status=$1, updated_by=$2 where id=$3 and version=$4 returning id`, [to, user.id, id, version]);
    if (upd.length === 0) throw Conflict();
    await c.query(`insert into status_transitions (org_id, entity_type, entity_id, from_status, to_status, actor_id, actor_name, reason) values ($1,'order',$2,$3,$4,$5,$6,$7)`, [o.org_id, id, o.status, to, user.id, user.name, reason ?? null]);
    await logActivity(o.org_id, 'order', id, 'status', `Status ${o.status} → ${to}`, user, c);
    await audit({ orgId: o.org_id, actorId: user.id, actorName: user.name, action: 'order.transition', entityType: 'order', entityId: id, before: { status: o.status }, after: { status: to } }, c);
    // reflect on project
    if (o.status === 'CONFIRMED' && to === 'ENGINEERING') await c.query(`update projects set status='ACTIVE' where sales_order_id=$1`, [id]);
    if (to === 'CLOSED') await c.query(`update projects set status='CLOSED', progress_pct=100 where sales_order_id=$1`, [id]);
  });
}
