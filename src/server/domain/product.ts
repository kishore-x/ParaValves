import 'server-only';
import { tx, query } from '@/server/db';
import { nextNumber } from '@/server/numbering/engine';
import { audit } from '@/server/audit';
import { AppError } from '@/server/http/errors';
import type { AuthUser } from '@/server/auth/session';

export async function createProduct(user: AuthUser, input: Record<string, any>): Promise<string> {
  const code = String(input.product_code ?? '').trim();
  const name = String(input.name ?? '').trim();
  if (!code || !name) throw new AppError('Product code and name are required', 422, 'REQUIRED');
  const dupe = await query(`select 1 from products where org_id=$1 and lower(product_code)=lower($2)`, [user.currentOrgId, code]);
  if (dupe.length) throw new AppError(`Product code ${code} already exists`, 409, 'DUPLICATE');
  return tx(async (c) => {
    const r = await c.query<{ id: string }>(
      `insert into products (org_id, product_code, name, description, uom, material, dimensions, hsn_sac, tax_rate, standard_cost, selling_price, min_stock, reorder_point, is_manufactured, created_by)
       values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15) returning id`,
      [user.currentOrgId, code, name, input.description ?? null, input.uom ?? 'NOS', input.material ?? null,
       input.dimensions ?? null, input.hsn_sac ?? null, num(input.tax_rate, 18), num(input.standard_cost, 0),
       num(input.selling_price, 0), num(input.min_stock, 0), num(input.reorder_point, 0), !!input.is_manufactured, user.id]);
    await audit({ orgId: user.currentOrgId, actorId: user.id, actorName: user.name, action: 'product.create', entityType: 'product', entityId: r[0]!.id, after: { code, name } }, c);
    return r[0]!.id;
  });
}

/** Configurable part-number engine. Deterministic → unique → collision-safe. */
export async function generatePartNumber(
  user: AuthUser, productId: string, attrs: { family: string; size?: string; material?: string; config?: string },
): Promise<{ part_number: string; revision: number }> {
  return tx(async (c) => {
    const product = await c.one<{ id: string; org_id: string }>(`select id, org_id from products where id=$1 and org_id=any($2)`, [productId, user.orgIds]);
    if (!product) throw new AppError('Product not found', 404, 'NOT_FOUND');
    const family = (attrs.family || 'GEN').toUpperCase().slice(0, 4);
    const size = attrs.size ? String(attrs.size).padStart(3, '0') : null;
    const material = attrs.material ? attrs.material.toUpperCase().replace(/[^A-Z0-9]/g, '').slice(0, 6) : null;
    const config = attrs.config ? attrs.config.toUpperCase().replace(/[^A-Z0-9]/g, '').slice(0, 6) : null;
    const base = ['PV', family, size, material, config].filter(Boolean).join('-');

    // find latest revision for this base
    const existing = await c.query<{ revision: number }>(
      `select revision from part_numbers where org_id=$1 and part_number like $2 order by revision desc limit 1`,
      [product.org_id, `${base}-R%`]);
    const revision = (existing[0]?.revision ?? 0) + 1;
    const partNumber = `${base}-R${String(revision).padStart(2, '0')}`;

    // uniqueness guaranteed by table constraint; catch collision explicitly
    try {
      await c.query(
        `insert into part_numbers (org_id, part_number, product_id, attributes, revision, created_by)
         values ($1,$2,$3,$4,$5,$6)`,
        [product.org_id, partNumber, productId, JSON.stringify(attrs), revision, user.id]);
    } catch (e: any) {
      if (e?.code === '23505') throw new AppError(`Part number ${partNumber} already exists — refusing to overwrite`, 409, 'PART_COLLISION');
      throw e;
    }
    await audit({ orgId: product.org_id, actorId: user.id, actorName: user.name, action: 'partnumber.create', entityType: 'part_number', entityId: partNumber, after: { partNumber, revision } }, c);
    return { part_number: partNumber, revision };
  });
}

function num(v: any, dflt: number): number { const n = Number(v); return Number.isFinite(n) ? n : dflt; }
