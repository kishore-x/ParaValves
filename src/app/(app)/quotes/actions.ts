'use server';
import { redirect } from 'next/navigation';
import { revalidatePath } from 'next/cache';
import { requirePermission } from '@/server/auth/action';
import { createQuote, transitionQuote, convertQuoteToOrder, type QuoteLineInput } from '@/server/domain/sales';

export async function newQuoteAction(formData: FormData) {
  const user = await requirePermission('quote.create');
  const linesJson = String(formData.get('lines') ?? '[]');
  const lines = JSON.parse(linesJson) as QuoteLineInput[];
  const { id } = await createQuote(user, {
    company_id: String(formData.get('company_id')),
    contact_id: strOrNull(formData, 'contact_id'),
    currency: String(formData.get('currency') ?? 'INR'),
    payment_terms: String(formData.get('payment_terms') ?? 'NET30'),
    delivery_terms: strOrNull(formData, 'delivery_terms') ?? undefined,
    valid_until: strOrNull(formData, 'valid_until') ?? undefined,
    notes: strOrNull(formData, 'notes') ?? undefined,
    lines: lines.filter((l) => l.description && Number(l.quantity) > 0),
  });
  redirect(`/quotes/${id}`);
}

export async function transitionQuoteAction(formData: FormData) {
  const user = await requirePermission('quote.edit');
  const id = String(formData.get('id'));
  await transitionQuote(user, id, String(formData.get('to')), Number(formData.get('version')));
  revalidatePath(`/quotes/${id}`);
}

export async function convertQuoteAction(formData: FormData) {
  const user = await requirePermission('order.create');
  const id = String(formData.get('id'));
  const { id: orderId } = await convertQuoteToOrder(user, id);
  redirect(`/orders/${orderId}`);
}

function strOrNull(fd: FormData, k: string): string | null {
  const v = fd.get(k); const t = v == null ? '' : String(v).trim(); return t === '' ? null : t;
}
