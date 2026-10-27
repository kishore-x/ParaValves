import 'server-only';
import { z } from 'zod';
import { tx, query } from '@/server/db';
import { nextNumber } from '@/server/numbering/engine';
import { audit } from '@/server/audit';
import type { AuthUser } from '@/server/auth/session';

export type ImportEntity = 'companies' | 'products' | 'contacts';

/** Minimal, dependency-free CSV parser (handles quoted fields + commas). */
export function parseCsv(text: string): string[][] {
  const rows: string[][] = [];
  let row: string[] = [], field = '', inQuotes = false;
  for (let i = 0; i < text.length; i++) {
    const ch = text[i]!;
    if (inQuotes) {
      if (ch === '"') { if (text[i + 1] === '"') { field += '"'; i++; } else inQuotes = false; }
      else field += ch;
    } else {
      if (ch === '"') inQuotes = true;
      else if (ch === ',') { row.push(field); field = ''; }
      else if (ch === '\n') { row.push(field); rows.push(row); row = []; field = ''; }
      else if (ch === '\r') { /* skip */ }
      else field += ch;
    }
  }
  if (field.length || row.length) { row.push(field); rows.push(row); }
  return rows.filter((r) => r.some((c) => c.trim() !== ''));
}

const schemas: Record<ImportEntity, z.ZodType<any>> = {
  companies: z.object({
    name: z.string().min(2), country: z.string().optional(), state_code: z.string().optional(),
    city: z.string().optional(), gstin: z.string().optional(),
    is_supplier: z.string().optional(), currency: z.string().optional(),
  }),
  products: z.object({
    product_code: z.string().min(1), name: z.string().min(2), uom: z.string().optional(),
    material: z.string().optional(), hsn_sac: z.string().optional(),
    tax_rate: z.string().optional(), selling_price: z.string().optional(), standard_cost: z.string().optional(),
  }),
  contacts: z.object({
    company_name: z.string().min(2), name: z.string().min(2), email: z.string().optional(),
    phone: z.string().optional(), designation: z.string().optional(),
  }),
};

export interface PreviewRow { row: number; data: Record<string, string>; ok: boolean; errors: string[]; duplicate: boolean; }
export interface PreviewResult { entity: ImportEntity; headers: string[]; rows: PreviewRow[]; okCount: number; errorCount: number; }

export async function previewImport(user: AuthUser, entity: ImportEntity, csv: string): Promise<PreviewResult> {
  const parsed = parseCsv(csv);
  if (parsed.length < 2) throw new Error('CSV must have a header row and at least one data row');
  const headers = parsed[0]!.map((h) => h.trim().toLowerCase().replace(/\s+/g, '_'));
  const schema = schemas[entity];
  const rows: PreviewRow[] = [];

  // preload existing keys for duplicate detection
  const existing = new Set<string>();
  if (entity === 'companies') (await query<{ name: string }>(`select lower(name) name from companies where org_id=$1`, [user.currentOrgId])).forEach((r) => existing.add(r.name));
  if (entity === 'products') (await query<{ product_code: string }>(`select lower(product_code) product_code from products where org_id=$1`, [user.currentOrgId])).forEach((r) => existing.add(r.product_code));

  for (let i = 1; i < parsed.length; i++) {
    const cells = parsed[i]!;
    const data: Record<string, string> = {};
    headers.forEach((h, idx) => { data[h] = (cells[idx] ?? '').trim(); });
    const parsedRow = schema.safeParse(data);
    const errors: string[] = [];
    if (!parsedRow.success) parsedRow.error.issues.forEach((e) => errors.push(`${e.path.join('.')}: ${e.message}`));
    let duplicate = false;
    if (entity === 'companies' && data.name) duplicate = existing.has(data.name.toLowerCase());
    if (entity === 'products' && data.product_code) duplicate = existing.has(data.product_code.toLowerCase());
    if (duplicate) errors.push('Duplicate — already exists');
    rows.push({ row: i, data, ok: errors.length === 0, errors, duplicate });
  }
  return { entity, headers, rows, okCount: rows.filter((r) => r.ok).length, errorCount: rows.filter((r) => !r.ok).length };
}

export async function commitImport(user: AuthUser, entity: ImportEntity, csv: string): Promise<{ imported: number; skipped: number; batchId: string }> {
  const preview = await previewImport(user, entity, csv);
  return tx(async (c) => {
    const batch = (await c.query<{ id: string }>(
      `insert into import_batches (org_id, entity, status, total_rows, ok_rows, error_rows, report, created_by)
       values ($1,$2,'IMPORTING',$3,$4,$5,$6,$7) returning id`,
      [user.currentOrgId, entity, preview.rows.length, preview.okCount, preview.errorCount, JSON.stringify(preview.rows.slice(0, 200)), user.id]))[0]!;
    let imported = 0;
    for (const r of preview.rows) {
      if (!r.ok) continue;
      const d = r.data;
      if (entity === 'companies') {
        const isSup = /^(y|yes|true|1)$/i.test(d.is_supplier ?? '');
        const num = await nextNumber(c, user.currentOrgId, isSup ? 'SUPP' : 'CUST');
        await c.query(
          `insert into companies (org_id, company_number, name, is_customer, is_supplier, country, state_code, city, gstin, currency, created_by, updated_by)
           values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$11)`,
          [user.currentOrgId, num, d.name, !isSup, isSup, d.country || 'IN', d.state_code || null, d.city || null, d.gstin || null, d.currency || 'INR', user.id]);
      } else if (entity === 'products') {
        await c.query(
          `insert into products (org_id, product_code, name, uom, material, hsn_sac, tax_rate, selling_price, standard_cost, created_by)
           values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)`,
          [user.currentOrgId, d.product_code, d.name, d.uom || 'NOS', d.material || null, d.hsn_sac || null,
           Number(d.tax_rate || 18), Number(d.selling_price || 0), Number(d.standard_cost || 0), user.id]);
      } else if (entity === 'contacts') {
        const comp = await c.one<{ id: string }>(`select id from companies where org_id=$1 and lower(name)=lower($2) limit 1`, [user.currentOrgId, d.company_name]);
        if (!comp) continue;
        await c.query(`insert into contacts (org_id, company_id, name, email, phone, designation, created_by) values ($1,$2,$3,$4,$5,$6,$7)`,
          [user.currentOrgId, comp.id, d.name, d.email || null, d.phone || null, d.designation || null, user.id]);
      }
      imported++;
    }
    await c.query(`update import_batches set status='DONE' where id=$1`, [batch.id]);
    await audit({ orgId: user.currentOrgId, actorId: user.id, actorName: user.name, action: 'import.commit', entityType: 'import', entityId: batch.id, after: { entity, imported } }, c);
    return { imported, skipped: preview.rows.length - imported, batchId: batch.id };
  });
}
