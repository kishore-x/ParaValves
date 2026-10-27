'use server';
import { revalidatePath } from 'next/cache';
import { requirePermission } from '@/server/auth/action';
import { adjustStock } from '@/server/domain/inventory';
import { one } from '@/server/db';

export async function adjustStockAction(formData: FormData) {
  const user = await requirePermission('inventory.edit');
  const productId = String(formData.get('product_id'));
  const delta = Number(formData.get('delta'));
  const reason = String(formData.get('reason') ?? 'Manual adjustment');
  const wh = await one<{ id: string }>(`select id from warehouses where org_id=$1 and is_default=true limit 1`, [user.currentOrgId]);
  await adjustStock(user, productId, wh!.id, delta, reason);
  revalidatePath('/inventory');
}
