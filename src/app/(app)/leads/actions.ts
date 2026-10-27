'use server';
import { redirect } from 'next/navigation';
import { revalidatePath } from 'next/cache';
import { requirePermission } from '@/server/auth/action';
import { createLead, transitionLead, convertLead } from '@/server/domain/crm';

export async function newLeadAction(formData: FormData) {
  const user = await requirePermission('lead.create');
  const { id } = await createLead(user, {
    company_name: String(formData.get('company_name') ?? '').trim(),
    contact_name: str(formData, 'contact_name'),
    email: str(formData, 'email'),
    phone: str(formData, 'phone'),
    country: str(formData, 'country'),
    product_requirement: str(formData, 'product_requirement'),
    quantity: numOrU(formData, 'quantity'),
    description: str(formData, 'description'),
    source: str(formData, 'source') ?? 'MANUAL',
    priority: str(formData, 'priority') ?? 'NORMAL',
    expected_value: numOrU(formData, 'expected_value'),
    expected_close: str(formData, 'expected_close'),
  });
  redirect(`/leads/${id}`);
}

export async function transitionLeadAction(formData: FormData) {
  const user = await requirePermission('lead.edit');
  const id = String(formData.get('id'));
  await transitionLead(user, id, String(formData.get('to')), Number(formData.get('version')), str(formData, 'reason'));
  revalidatePath(`/leads/${id}`);
}

export async function convertLeadAction(formData: FormData) {
  const user = await requirePermission('lead.edit');
  const id = String(formData.get('id'));
  const { company_id } = await convertLead(user, id);
  redirect(`/companies/${company_id}`);
}

function str(fd: FormData, k: string): string | undefined {
  const v = fd.get(k);
  const s = v == null ? '' : String(v).trim();
  return s === '' ? undefined : s;
}
function numOrU(fd: FormData, k: string): number | undefined {
  const s = str(fd, k);
  return s === undefined ? undefined : Number(s);
}
