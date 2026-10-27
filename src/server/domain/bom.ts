import 'server-only';
import { tx } from '@/server/db';
import { audit } from '@/server/audit';
import { AppError } from '@/server/http/errors';
import type { AuthUser } from '@/server/auth/session';

/** Start a new BOM revision, copying lines from the latest revision (or empty for the first). */
export async function newBomRevision(user: AuthUser, productId: string) {
  return tx(async (c) => {
    const prev = await c.one<any>(`select * from boms where org_id=$1 and product_id=$2 order by revision desc limit 1`, [user.currentOrgId, productId]);
    if (prev?.status === 'DRAFT') throw new AppError('A draft revision already exists — edit or release it first', 422, 'DRAFT_EXISTS');
    const rev = (prev?.revision ?? 0) + 1;
    const b = (await c.query<{ id: string }>(`insert into boms (org_id, product_id, revision, created_by) values ($1,$2,$3,$4) returning id`, [user.currentOrgId, productId, rev, user.id]))[0]!;
    if (prev) await c.query(`insert into bom_lines (bom_id, component_id, quantity, uom, scrap_pct) select $1, component_id, quantity, uom, scrap_pct from bom_lines where bom_id=$2`, [b.id, prev.id]);
    await audit({ orgId: user.currentOrgId, actorId: user.id, actorName: user.name, action: 'bom.revise', entityType: 'bom', entityId: b.id, after: { rev } }, c);
    return { id: b.id, revision: rev };
  });
}

export async function addBomLine(user: AuthUser, bomId: string, componentId: string, quantity: number, scrapPct = 0) {
  if (!(quantity > 0)) throw new AppError('Quantity must be positive', 422, 'BAD_QTY');
  await tx(async (c) => {
    const b = await c.one<any>(`select * from boms where id=$1 and org_id=any($2)`, [bomId, user.orgIds]);
    if (!b) throw new AppError('BOM not found', 404, 'NOT_FOUND');
    if (b.status !== 'DRAFT') throw new AppError('Only a draft BOM can be edited — start a new revision', 422, 'NOT_DRAFT');
    if (b.product_id === componentId) throw new AppError('A product cannot be its own component', 422, 'CYCLE');
    await c.query(`insert into bom_lines (bom_id, component_id, quantity, scrap_pct) values ($1,$2,$3,$4)`, [bomId, componentId, quantity, scrapPct]);
  });
}

/** Release the draft: it becomes effective today and supersedes the previously released revision. */
export async function releaseBom(user: AuthUser, bomId: string) {
  await tx(async (c) => {
    const b = await c.one<any>(`select * from boms where id=$1 and org_id=any($2) for update`, [bomId, user.orgIds]);
    if (!b) throw new AppError('BOM not found', 404, 'NOT_FOUND');
    if (b.status !== 'DRAFT') throw new AppError(`BOM is ${b.status}`, 422, 'INVALID_STATE');
    const n = await c.one<{ n: number }>(`select count(*)::int n from bom_lines where bom_id=$1`, [bomId]);
    if (!n || n.n === 0) throw new AppError('Cannot release an empty BOM', 422, 'EMPTY');
    await c.query(`update boms set status='SUPERSEDED' where org_id=$1 and product_id=$2 and status='RELEASED'`, [b.org_id, b.product_id]);
    await c.query(`update boms set status='RELEASED', effective_date=current_date where id=$1`, [bomId]);
    await audit({ orgId: b.org_id, actorId: user.id, actorName: user.name, action: 'bom.release', entityType: 'bom', entityId: bomId, after: { revision: b.revision } }, c);
  });
}
