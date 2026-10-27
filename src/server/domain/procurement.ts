import 'server-only';
import { tx } from '@/server/db';
import { nextNumber } from '@/server/numbering/engine';
import { audit, logActivity } from '@/server/audit';
import { computeLine, round2 } from '@/lib/money';
import { AppError, Conflict } from '@/server/http/errors';
import { canTransition, PO } from '@/server/workflow/machines';
import { sendMail, templates } from '@/server/mail';
import Decimal from 'decimal.js';
import type { AuthUser } from '@/server/auth/session';

export interface POLine { product_id?: string | null; description: string; quantity: number; unit_price: number; tax_rate?: number }

export async function createPurchaseOrder(user: AuthUser, input: { supplier_id: string; expected_date?: string; notes?: string; lines: POLine[] }): Promise<{ id: string; po_number: string }> {
  if (!input.lines.length) throw new AppError('A purchase order needs at least one line', 422, 'NO_LINES');
  return tx(async (c) => {
    const poNumber = await nextNumber(c, user.currentOrgId, 'PO');
    let subtotal = new Decimal(0), tax = new Decimal(0);
    const po = (await c.query<{ id: string }>(
      `insert into purchase_orders (org_id, po_number, supplier_id, status, expected_date, notes, created_by, updated_by)
       values ($1,$2,$3,'DRAFT',$4,$5,$6,$6) returning id`,
      [user.currentOrgId, poNumber, input.supplier_id, input.expected_date || null, input.notes ?? null, user.id]))[0]!;
    let n = 1;
    for (const l of input.lines) {
      const cl = computeLine({ quantity: l.quantity, unit_price: l.unit_price, tax_rate: l.tax_rate ?? 18 });
      subtotal = subtotal.plus(cl.taxable); tax = tax.plus(cl.tax);
      await c.query(`insert into purchase_order_lines (purchase_order_id, line_no, product_id, description, quantity, unit_price, tax_rate, line_total) values ($1,$2,$3,$4,$5,$6,$7,$8)`,
        [po.id, n, l.product_id ?? null, l.description, l.quantity, l.unit_price, l.tax_rate ?? 18, cl.total]);
      n++;
    }
    await c.query(`update purchase_orders set subtotal=$1, tax_total=$2, grand_total=$3 where id=$4`, [round2(subtotal), round2(tax), round2(subtotal.plus(tax)), po.id]);
    await logActivity(user.currentOrgId, 'po', po.id, 'system', `Purchase order ${poNumber} created`, user, c);
    await audit({ orgId: user.currentOrgId, actorId: user.id, actorName: user.name, action: 'po.create', entityType: 'po', entityId: po.id, after: { poNumber } }, c);
    return { id: po.id, po_number: poNumber };
  });
}

export async function transitionPO(user: AuthUser, id: string, to: string, version: number) {
  return tx(async (c) => {
    const po = await c.one<any>(`select * from purchase_orders where id=$1 and org_id=any($2)`, [id, user.orgIds]);
    if (!po) throw new AppError('PO not found', 404, 'NOT_FOUND');
    if (!canTransition(PO, po.status, to)) throw new AppError(`Cannot move PO from ${po.status} to ${to}`, 422, 'INVALID_TRANSITION');
    const upd = await c.query(`update purchase_orders set status=$1, updated_by=$2 where id=$3 and version=$4 returning id`, [to, user.id, id, version]);
    if (upd.length === 0) throw Conflict();
    await c.query(`insert into status_transitions (org_id, entity_type, entity_id, from_status, to_status, actor_id, actor_name) values ($1,'po',$2,$3,$4,$5,$6)`, [po.org_id, id, po.status, to, user.id, user.name]);
    // incoming stock estimate when supplier confirms
    if (to === 'CONFIRMED') {
      const lines = await c.query<any>(`select product_id, quantity from purchase_order_lines where purchase_order_id=$1 and product_id is not null`, [id]);
      const wh = await c.one<{ id: string }>(`select id from warehouses where org_id=$1 and is_default=true limit 1`, [po.org_id]);
      for (const l of lines) {
        if (wh) await c.query(`insert into stock_items (org_id, product_id, warehouse_id, incoming) values ($1,$2,$3,$4) on conflict (product_id, warehouse_id) do update set incoming = stock_items.incoming + $4`, [po.org_id, l.product_id, wh.id, l.quantity]);
      }
    }
    if (to === 'SENT') {
      const sup = await c.one<{ email: string | null; name: string }>(`select coalesce(ct.email,'') email, co.name from companies co left join contacts ct on ct.company_id=co.id and ct.is_primary where co.id=$1 limit 1`, [po.supplier_id]);
      const t = templates.poSent(po.po_number, sup?.name ?? 'Supplier');
      await sendMail({ orgId: po.org_id, to: sup?.email || 'supplier@example.com', subject: t.subject, event: 'po.sent', body: t.body }, c);
    }
    await logActivity(po.org_id, 'po', id, 'status', `Status ${po.status} → ${to}`, user, c);
    await audit({ orgId: po.org_id, actorId: user.id, actorName: user.name, action: 'po.transition', entityType: 'po', entityId: id, before: { status: po.status }, after: { status: to } }, c);
  });
}

/** Goods receipt: accepted qty increases on_hand, reduces incoming, recomputes shortages. */
export async function receiveGoods(user: AuthUser, poId: string, receipts: { po_line_id: string; product_id: string; received: number; accepted: number; rejected: number; damaged: number; batch?: string }[]): Promise<{ id: string; grn_number: string }> {
  return tx(async (c) => {
    const po = await c.one<any>(`select * from purchase_orders where id=$1 and org_id=any($2)`, [poId, user.orgIds]);
    if (!po) throw new AppError('PO not found', 404, 'NOT_FOUND');
    const wh = await c.one<{ id: string }>(`select id from warehouses where org_id=$1 and is_default=true limit 1`, [po.org_id]);
    if (!wh) throw new AppError('No default warehouse', 422, 'NO_WAREHOUSE');
    const grnNumber = await nextNumber(c, po.org_id, 'GRN');
    const grn = (await c.query<{ id: string }>(
      `insert into goods_receipts (org_id, grn_number, purchase_order_id, supplier_id, warehouse_id, status, created_by)
       values ($1,$2,$3,$4,$5,'DONE',$6) returning id`, [po.org_id, grnNumber, poId, po.supplier_id, wh.id, user.id]))[0]!;

    for (const r of receipts) {
      if (r.received <= 0) continue;
      await c.query(`insert into goods_receipt_lines (goods_receipt_id, po_line_id, product_id, received_qty, accepted_qty, rejected_qty, damaged_qty, batch) values ($1,$2,$3,$4,$5,$6,$7,$8)`,
        [grn.id, r.po_line_id, r.product_id, r.received, r.accepted, r.rejected, r.damaged, r.batch ?? null]);
      await c.query(`update purchase_order_lines set received_qty = received_qty + $1 where id=$2`, [r.received, r.po_line_id]);
      // only accepted increases available stock
      const si = await c.one<any>(`select * from stock_items where product_id=$1 and warehouse_id=$2 for update`, [r.product_id, wh.id]);
      if (si) {
        const newOnHand = Number(si.on_hand) + r.accepted;
        const newIncoming = Math.max(0, Number(si.incoming) - r.received);
        await c.query(`update stock_items set on_hand=$1, incoming=$2, damaged = damaged + $3, rejected = rejected + $4 where id=$5`, [newOnHand, newIncoming, r.damaged, r.rejected, si.id]);
        await c.query(`insert into stock_movements (org_id, product_id, warehouse_id, kind, quantity, balance_after, ref_type, ref_id, actor_id) values ($1,$2,$3,'RECEIPT',$4,$5,'grn',$6,$7)`, [po.org_id, r.product_id, wh.id, r.accepted, newOnHand, grn.id, user.id]);
      } else {
        await c.query(`insert into stock_items (org_id, product_id, warehouse_id, on_hand) values ($1,$2,$3,$4)`, [po.org_id, r.product_id, wh.id, r.accepted]);
        await c.query(`insert into stock_movements (org_id, product_id, warehouse_id, kind, quantity, balance_after, ref_type, ref_id, actor_id) values ($1,$2,$3,'RECEIPT',$4,$4,'grn',$5,$6)`, [po.org_id, r.product_id, wh.id, r.accepted, grn.id, user.id]);
      }
      // each accepted receipt becomes a traceable lot, held in quarantine until incoming inspection passes
      if (r.accepted > 0) {
        const lotNo = r.batch || await nextNumber(c, po.org_id, 'LOT');
        await c.query(
          `insert into material_lots (org_id, lot_number, product_id, supplier_id, goods_receipt_id, heat_number, quantity, qty_available, status, created_by)
           values ($1,$2,$3,$4,$5,$6,$7,$7,'QUARANTINE',$8) on conflict (org_id, lot_number) do nothing`,
          [po.org_id, lotNo, r.product_id, po.supplier_id, grn.id, r.batch ?? null, r.accepted, user.id]);
      }
      // recompute shortages for open requirements of this product
      await recomputeShortage(c, po.org_id, r.product_id);
    }
    // PO status
    const remaining = await c.one<{ n: string }>(`select count(*)::text n from purchase_order_lines where purchase_order_id=$1 and received_qty < quantity`, [poId]);
    await c.query(`update purchase_orders set status=$1 where id=$2`, [Number(remaining?.n ?? 0) === 0 ? 'RECEIVED' : 'PARTIALLY_RECEIVED', poId]);
    await logActivity(po.org_id, 'po', poId, 'system', `Goods received: ${grnNumber}`, user, c);
    await audit({ orgId: po.org_id, actorId: user.id, actorName: user.name, action: 'grn.create', entityType: 'grn', entityId: grn.id, after: { grnNumber, poId } }, c);
    return { id: grn.id, grn_number: grnNumber };
  });
}

async function recomputeShortage(c: any, orgId: string, productId: string) {
  const reqs = await c.query(`select * from material_requirements where org_id=$1 and product_id=$2 and status='OPEN'`, [orgId, productId]);
  for (const r of reqs) {
    const stock = await c.one(`select coalesce(sum(on_hand),0) on_hand, coalesce(sum(reserved),0) reserved, coalesce(sum(incoming),0) incoming from stock_items where org_id=$1 and product_id=$2`, [orgId, productId]);
    const available = Number(stock.on_hand) - Number(stock.reserved);
    const shortage = Math.max(0, Number(r.required_qty) - available - Number(stock.incoming));
    await c.query(`update material_requirements set available_qty=$1, incoming_qty=$2, shortage_qty=$3, status=$4 where id=$5`,
      [Math.max(0, available), Number(stock.incoming), shortage, shortage > 0 ? 'OPEN' : 'COVERED', r.id]);
  }
}
