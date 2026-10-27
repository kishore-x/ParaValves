'use server';
import { redirect } from 'next/navigation';
import { revalidatePath } from 'next/cache';
import { requirePermission } from '@/server/auth/action';
import { tx } from '@/server/db';
import { nextNumber } from '@/server/numbering/engine';
import { audit } from '@/server/audit';

export async function newCompanyAction(formData: FormData) {
  const user = await requirePermission('company.create');
  const isSupplier = formData.get('is_supplier') === 'on';
  const id = await tx(async (c) => {
    const num = await nextNumber(c, user.currentOrgId, isSupplier ? 'SUPP' : 'CUST');
    const r = await c.query<{ id: string }>(
      `insert into companies (org_id, company_number, name, is_customer, is_supplier, country, state_code, city, address, postal_code, gstin, tax_treatment, currency, payment_terms, owner_id, created_by, updated_by)
       values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$15,$15) returning id`,
      [user.currentOrgId, num, s(formData, 'name'), !isSupplier, isSupplier, s(formData, 'country') ?? 'IN',
       s(formData, 'state_code'), s(formData, 'city'), s(formData, 'address'), s(formData, 'postal_code'),
       s(formData, 'gstin'), s(formData, 'tax_treatment') ?? 'DOMESTIC', s(formData, 'currency') ?? 'INR',
       s(formData, 'payment_terms') ?? 'NET30', user.id]);
    await audit({ orgId: user.currentOrgId, actorId: user.id, actorName: user.name, action: 'company.create', entityType: 'company', entityId: r[0]!.id, after: { name: s(formData, 'name') } }, c);
    return r[0]!.id;
  });
  redirect(`/companies/${id}`);
}

export async function addContactAction(formData: FormData) {
  const user = await requirePermission('contact.create');
  const companyId = String(formData.get('company_id'));
  await tx(async (c) => {
    await c.query(
      `insert into contacts (org_id, company_id, name, designation, email, phone, whatsapp, is_primary, created_by)
       values ($1,$2,$3,$4,$5,$6,$7,$8,$9)`,
      [user.currentOrgId, companyId, s(formData, 'name'), s(formData, 'designation'), s(formData, 'email'),
       s(formData, 'phone'), s(formData, 'whatsapp'), formData.get('is_primary') === 'on', user.id]);
  });
  revalidatePath(`/companies/${companyId}`);
}

function s(fd: FormData, k: string): string | null {
  const v = fd.get(k); const t = v == null ? '' : String(v).trim(); return t === '' ? null : t;
}
