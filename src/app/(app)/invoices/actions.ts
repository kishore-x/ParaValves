'use server';
import { revalidatePath } from 'next/cache';
import { requirePermission } from '@/server/auth/action';
import { transitionInvoice, recordPayment } from '@/server/domain/finance';

export async function transitionInvoiceAction(formData: FormData) {
  const user = await requirePermission('invoice.edit');
  const id = String(formData.get('id'));
  await transitionInvoice(user, id, String(formData.get('to')), Number(formData.get('version')));
  revalidatePath(`/invoices/${id}`);
}

export async function recordPaymentAction(formData: FormData) {
  const user = await requirePermission('payment.create');
  const id = String(formData.get('id'));
  await recordPayment(user, id, Number(formData.get('amount')), str(formData, 'method'), str(formData, 'reference'));
  revalidatePath(`/invoices/${id}`);
}
function str(fd: FormData, k: string) { const v = fd.get(k); const t = v == null ? '' : String(v).trim(); return t === '' ? undefined : t; }
