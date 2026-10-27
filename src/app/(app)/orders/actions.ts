'use server';
import { redirect } from 'next/navigation';
import { revalidatePath } from 'next/cache';
import { requirePermission } from '@/server/auth/action';
import { transitionOrder } from '@/server/domain/sales';
import { createInvoiceFromOrder } from '@/server/domain/finance';

export async function transitionOrderAction(formData: FormData) {
  const user = await requirePermission('order.edit');
  const id = String(formData.get('id'));
  await transitionOrder(user, id, String(formData.get('to')), Number(formData.get('version')), str(formData, 'reason'));
  revalidatePath(`/orders/${id}`);
}

export async function createInvoiceAction(formData: FormData) {
  const user = await requirePermission('invoice.create');
  const id = String(formData.get('id'));
  const { id: invId } = await createInvoiceFromOrder(user, id);
  redirect(`/invoices/${invId}`);
}

function str(fd: FormData, k: string): string | undefined {
  const v = fd.get(k); const t = v == null ? '' : String(v).trim(); return t === '' ? undefined : t;
}
