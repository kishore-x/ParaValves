import 'server-only';
import { tx } from '@/server/db';
import { nextNumber } from '@/server/numbering/engine';
import { audit, logActivity } from '@/server/audit';
import { AppError } from '@/server/http/errors';
import type { AuthUser } from '@/server/auth/session';

export interface Gate { key: string; label: string; ok: boolean; reason: string; owner: string }

/** Every prerequisite that must be true before goods may leave the building. */
export async function shipmentGates(c: any, shipmentId: string): Promise<Gate[]> {
  const s = await c.one(`select s.*, so.company_id, so.order_number, so.status order_status from shipments s join sales_orders so on so.id=s.sales_order_id where s.id=$1`, [shipmentId]);
  const co = await c.one(`select * from companies where id=$1`, [s.company_id]);
  const units = await c.query(`select u.* from shipment_lines l join serial_units u on u.id=l.serial_unit_id where l.shipment_id=$1`, [shipmentId]);
  const gates: Gate[] = [];

  gates.push({ key: 'units', label: 'Units selected', ok: units.length > 0, reason: units.length ? `${units.length} unit(s) packed` : 'No units on this shipment', owner: 'Dispatch' });

  const notReleased = units.filter((u: any) => u.status !== 'RELEASED' && u.status !== 'SHIPPED');
  gates.push({ key: 'quality', label: 'Quality release', ok: notReleased.length === 0 && units.length > 0,
    reason: notReleased.length ? `${notReleased.map((u: any) => `${u.serial_number} (${u.status})`).join(', ')} not quality-released` : 'All units accepted by final inspection & tests', owner: 'Quality' });

  const out = await c.one(`select coalesce(sum(grand_total - paid_amount),0) due from invoices where company_id=$1 and status not in ('PAID','CANCELLED','DRAFT')`, [s.company_id]);
  const overLimit = Number(co.credit_limit) > 0 && Number(out.due) > Number(co.credit_limit);
  gates.push({ key: 'credit', label: 'Credit check', ok: !co.credit_hold && !overLimit,
    reason: co.credit_hold ? `${co.name} is on credit hold` : overLimit ? `Receivables ${Math.round(Number(out.due)).toLocaleString('en-IN')} exceed credit limit` : 'Within credit terms', owner: 'Accounts' });

  const isExport = co.tax_treatment === 'EXPORT' || (co.country && co.country !== 'IN');
  const docs = s.docs ?? {};
  if (isExport) gates.push({ key: 'export', label: 'Export clearance', ok: !!co.export_cleared && !!docs.export_docs,
    reason: !co.export_cleared ? 'Customer not export-cleared (screening pending)' : !docs.export_docs ? 'Export documents (invoice, COO, shipping bill) missing' : 'Export cleared', owner: 'Logistics' });

  const missing = ['packing_list', 'mtc'].filter((k) => !docs[k]);
  gates.push({ key: 'documents', label: 'Customer documents', ok: missing.length === 0,
    reason: missing.length ? `Missing: ${missing.map((m) => (m === 'mtc' ? 'material/test certificates' : 'packing list')).join(', ')}` : 'Packing list & certificates attached', owner: 'Dispatch' });
  return gates;
}

export async function createShipment(user: AuthUser, input: { sales_order_id: string; serial_unit_ids: string[] }) {
  return tx(async (c) => {
    const so = await c.one<any>(`select * from sales_orders where id=$1 and org_id=any($2)`, [input.sales_order_id, user.orgIds]);
    if (!so) throw new AppError('Order not found', 404, 'NOT_FOUND');
    const no = await nextNumber(c, so.org_id, 'SHP');
    const ordered = await c.one<{ q: string }>(`select coalesce(sum(l.quantity),0)::text q from sales_order_lines l join products p on p.id=l.product_id where l.sales_order_id=$1 and p.is_manufactured`, [so.id]);
    const shippedBefore = await c.one<{ n: number }>(`select count(*)::int n from serial_units where sales_order_id=$1 and status='SHIPPED'`, [so.id]);
    const isPartial = (shippedBefore?.n ?? 0) + input.serial_unit_ids.length < Number(ordered?.q ?? 0);
    const row = (await c.query<{ id: string }>(`insert into shipments (org_id, shipment_number, sales_order_id, is_partial, created_by) values ($1,$2,$3,$4,$5) returning id`, [so.org_id, no, so.id, isPartial, user.id]))[0]!;
    for (const id of input.serial_unit_ids) {
      const u = await c.one<any>(`select * from serial_units where id=$1 and sales_order_id=$2`, [id, so.id]);
      if (!u) throw new AppError('Unit does not belong to this order', 422, 'BAD_UNIT');
      await c.query(`insert into shipment_lines (shipment_id, serial_unit_id) values ($1,$2)`, [row.id, id]);
    }
    await audit({ orgId: so.org_id, actorId: user.id, actorName: user.name, action: 'shipment.create', entityType: 'shipment', entityId: row.id, after: { no } }, c);
    return { id: row.id, shipment_number: no };
  });
}

export async function updateShipmentDocs(user: AuthUser, id: string, docs: Record<string, boolean>, carrier?: string) {
  await tx(async (c) => {
    const s = await c.one<any>(`select docs from shipments where id=$1 and org_id=any($2) and status<>'SHIPPED'`, [id, user.orgIds]);
    if (!s) throw new AppError('Shipment not found or already shipped', 404, 'NOT_FOUND');
    await c.query(`update shipments set docs=$1, carrier=coalesce($2,carrier) where id=$3`, [JSON.stringify({ ...(s.docs ?? {}), ...docs }), carrier || null, id]);
  });
}

/** Attempt to ship. If any gate fails the shipment is BLOCKED with an owner and reason — never silently shipped. */
export async function shipShipment(user: AuthUser, id: string): Promise<{ shipped: boolean; blocked?: Gate[] }> {
  return tx(async (c) => {
    const s = await c.one<any>(`select * from shipments where id=$1 and org_id=any($2) for update`, [id, user.orgIds]);
    if (!s) throw new AppError('Shipment not found', 404, 'NOT_FOUND');
    if (s.status === 'SHIPPED') throw new AppError('Already shipped', 422, 'INVALID_STATE');
    const gates = await shipmentGates(c, id);
    const failed = gates.filter((g) => !g.ok);
    if (failed.length) {
      await c.query(`update shipments set status='BLOCKED', block_reason=$1 where id=$2`, [failed.map((g) => `${g.label}: ${g.reason} [owner: ${g.owner}]`).join(' | '), id]);
      await c.query(
        `insert into order_exceptions (org_id, exception_no, sales_order_id, type, description, created_by)
         select $1, $2, $3, 'SHIPMENT_BLOCK', $4, $5 where not exists (select 1 from order_exceptions where sales_order_id=$3 and type='SHIPMENT_BLOCK' and status<>'RESOLVED')`,
        [s.org_id, await nextNumber(c, s.org_id, 'EXC'), s.sales_order_id, `Shipment ${s.shipment_number} blocked — ${failed.map((g) => g.label).join(', ')}`, user.id]);
      return { shipped: false, blocked: failed };
    }
    await c.query(`update shipments set status='SHIPPED', shipped_at=now(), block_reason=null where id=$1`, [id]);
    await c.query(`update serial_units set status='SHIPPED' where id in (select serial_unit_id from shipment_lines where shipment_id=$1)`, [id]);
    // delivered qty per order line (by product)
    const per = await c.query<any>(`select u.product_id, count(*)::int n from shipment_lines l join serial_units u on u.id=l.serial_unit_id where l.shipment_id=$1 group by u.product_id`, [id]);
    for (const p of per) {
      await c.query(`update sales_order_lines set delivered_qty = delivered_qty + $1 where id = (select id from sales_order_lines where sales_order_id=$2 and product_id=$3 order by line_no limit 1)`, [p.n, s.sales_order_id, p.product_id]);
    }
    await c.query(`update order_exceptions set status='RESOLVED', resolved_at=now() where sales_order_id=$1 and type='SHIPMENT_BLOCK' and status<>'RESOLVED'`, [s.sales_order_id]);
    await logActivity(s.org_id, 'order', s.sales_order_id, 'system', `Shipment ${s.shipment_number} dispatched`, user, c);
    await audit({ orgId: s.org_id, actorId: user.id, actorName: user.name, action: 'shipment.ship', entityType: 'shipment', entityId: id }, c);
    return { shipped: true };
  });
}
