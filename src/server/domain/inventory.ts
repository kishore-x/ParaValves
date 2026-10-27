import 'server-only';
import { tx } from '@/server/db';
import { audit } from '@/server/audit';
import { AppError } from '@/server/http/errors';
import type { AuthUser } from '@/server/auth/session';

/** Concurrency-safe reservation: locks the stock row, checks availability. */
export async function reserveStock(user: AuthUser, productId: string, warehouseId: string, qty: number, orderId?: string) {
  return tx(async (c) => {
    const si = await c.one<any>(
      `select * from stock_items where product_id=$1 and warehouse_id=$2 for update`, [productId, warehouseId]);
    if (!si) throw new AppError('No stock record for this product/warehouse', 404, 'NO_STOCK');
    const available = Number(si.on_hand) - Number(si.reserved);
    if (qty > available) {
      const prod = await c.one<{ name: string }>(`select name from products where id=$1`, [productId]);
      throw new AppError(
        `Unable to reserve ${qty} units of ${prod?.name ?? productId}: only ${available} available (${si.on_hand} on hand, ${si.reserved} reserved).`,
        422, 'INSUFFICIENT_STOCK', { available, onHand: Number(si.on_hand), reserved: Number(si.reserved) });
    }
    await c.query(`update stock_items set reserved = reserved + $1 where id=$2`, [qty, si.id]);
    if (orderId) await c.query(`insert into stock_reservations (org_id, product_id, warehouse_id, sales_order_id, quantity) values ($1,$2,$3,$4,$5)`, [si.org_id, productId, warehouseId, orderId, qty]);
    await c.query(`insert into stock_movements (org_id, product_id, warehouse_id, kind, quantity, balance_after, ref_type, ref_id, actor_id) values ($1,$2,$3,'RESERVE',$4,$5,'order',$6,$7)`,
      [si.org_id, productId, warehouseId, qty, Number(si.on_hand), orderId ?? null, user.id]);
    await audit({ orgId: si.org_id, actorId: user.id, actorName: user.name, action: 'inventory.reserve', entityType: 'stock', entityId: si.id, after: { qty, orderId } }, c);
  });
}

export async function adjustStock(user: AuthUser, productId: string, warehouseId: string, delta: number, reason: string) {
  return tx(async (c) => {
    let si = await c.one<any>(`select * from stock_items where product_id=$1 and warehouse_id=$2 for update`, [productId, warehouseId]);
    if (!si) {
      si = (await c.query<any>(`insert into stock_items (org_id, product_id, warehouse_id) select org_id,$1,$2 from products where id=$1 returning *`, [productId, warehouseId]))[0];
    }
    const newOnHand = Number(si.on_hand) + delta;
    if (newOnHand < 0) throw new AppError(`Adjustment would make stock negative (current ${si.on_hand}, delta ${delta})`, 422, 'NEGATIVE_STOCK');
    await c.query(`update stock_items set on_hand=$1 where id=$2`, [newOnHand, si.id]);
    await c.query(`insert into stock_movements (org_id, product_id, warehouse_id, kind, quantity, balance_after, reason, actor_id) values ($1,$2,$3,'ADJUST',$4,$5,$6,$7)`,
      [si.org_id, productId, warehouseId, delta, newOnHand, reason, user.id]);
    await audit({ orgId: si.org_id, actorId: user.id, actorName: user.name, action: 'inventory.adjust', entityType: 'stock', entityId: si.id, after: { delta, reason, newOnHand } }, c);
  });
}
