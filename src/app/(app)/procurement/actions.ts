'use server';
import { redirect } from 'next/navigation';
import { revalidatePath } from 'next/cache';
import { requirePermission } from '@/server/auth/action';
import { createPurchaseOrder, transitionPO, receiveGoods, type POLine } from '@/server/domain/procurement';

export async function newPOAction(formData: FormData) {
  const user = await requirePermission('procurement.create');
  const lines = JSON.parse(String(formData.get('lines') ?? '[]')) as POLine[];
  const { id } = await createPurchaseOrder(user, {
    supplier_id: String(formData.get('supplier_id')),
    expected_date: str(formData, 'expected_date'),
    notes: str(formData, 'notes'),
    lines: lines.filter((l) => l.description && Number(l.quantity) > 0),
  });
  redirect(`/procurement/${id}`);
}

export async function transitionPOAction(formData: FormData) {
  const user = await requirePermission('procurement.edit');
  const id = String(formData.get('id'));
  await transitionPO(user, id, String(formData.get('to')), Number(formData.get('version')));
  revalidatePath(`/procurement/${id}`);
}

export async function receiveGoodsAction(formData: FormData) {
  const user = await requirePermission('grn.create');
  const id = String(formData.get('id'));
  const receipts = JSON.parse(String(formData.get('receipts') ?? '[]'));
  await receiveGoods(user, id, receipts);
  revalidatePath(`/procurement/${id}`);
}

function str(fd: FormData, k: string): string | undefined {
  const v = fd.get(k); const t = v == null ? '' : String(v).trim(); return t === '' ? undefined : t;
}
