'use server';
import { redirect } from 'next/navigation';
import { revalidatePath } from 'next/cache';
import { requirePermission } from '@/server/auth/action';
import { createDrawing, transitionDrawing, newRevision } from '@/server/domain/engineering';

export async function newDrawingAction(formData: FormData) {
  const user = await requirePermission('drawing.create');
  const { id } = await createDrawing(user, {
    title: String(formData.get('title')),
    sales_order_id: strOrNull(formData, 'sales_order_id'),
    product_id: strOrNull(formData, 'product_id'),
  });
  redirect(`/engineering/${id}`);
}
export async function transitionDrawingAction(formData: FormData) {
  const user = await requirePermission('drawing.approve');
  const id = String(formData.get('id'));
  await transitionDrawing(user, id, String(formData.get('to')), Number(formData.get('version')));
  revalidatePath(`/engineering/${id}`);
}
export async function newRevisionAction(formData: FormData) {
  const user = await requirePermission('drawing.edit');
  const id = String(formData.get('id'));
  await newRevision(user, id);
  revalidatePath(`/engineering/${id}`);
}
function strOrNull(fd: FormData, k: string) { const v = fd.get(k); const t = v == null ? '' : String(v).trim(); return t === '' ? null : t; }
