import 'server-only';
import { tx } from '@/server/db';
import { nextNumber } from '@/server/numbering/engine';
import { audit, logActivity } from '@/server/audit';
import { canTransition, DRAWING } from '@/server/workflow/machines';
import { AppError, Conflict } from '@/server/http/errors';
import type { AuthUser } from '@/server/auth/session';

export async function createDrawing(user: AuthUser, input: { title: string; sales_order_id?: string | null; product_id?: string | null }): Promise<{ id: string; drawing_number: string }> {
  return tx(async (c) => {
    const drawingNumber = await nextNumber(c, user.currentOrgId, 'DRW');
    const dr = (await c.query<{ id: string }>(
      `insert into drawings (org_id, drawing_number, product_id, sales_order_id, title, status, created_by)
       values ($1,$2,$3,$4,$5,'DRAFT',$6) returning id`,
      [user.currentOrgId, drawingNumber, input.product_id ?? null, input.sales_order_id ?? null, input.title, user.id]))[0]!;
    await c.query(`insert into drawing_revisions (drawing_id, revision, status, uploaded_by) values ($1,1,'DRAFT',$2)`, [dr.id, user.id]);
    await logActivity(user.currentOrgId, 'drawing', dr.id, 'system', `Drawing ${drawingNumber} created`, user, c);
    if (input.sales_order_id) await logActivity(user.currentOrgId, 'order', input.sales_order_id, 'system', `Drawing ${drawingNumber} created`, user, c);
    await audit({ orgId: user.currentOrgId, actorId: user.id, actorName: user.name, action: 'drawing.create', entityType: 'drawing', entityId: dr.id, after: { drawingNumber } }, c);
    return { id: dr.id, drawing_number: drawingNumber };
  });
}

export async function transitionDrawing(user: AuthUser, id: string, to: string, version: number) {
  return tx(async (c) => {
    const dr = await c.one<any>(`select * from drawings where id=$1 and org_id=any($2)`, [id, user.orgIds]);
    if (!dr) throw new AppError('Drawing not found', 404, 'NOT_FOUND');
    if (!canTransition(DRAWING, dr.status, to)) throw new AppError(`Cannot move drawing from ${dr.status} to ${to}`, 422, 'INVALID_TRANSITION');
    const upd = await c.query(`update drawings set status=$1 where id=$2 and version=$3 returning id`, [to, id, version]);
    if (upd.length === 0) throw Conflict();
    await c.query(`update drawing_revisions set status=$1, approved_by = case when $1='RELEASED' then $2 else approved_by end, approved_at = case when $1='RELEASED' then now() else approved_at end where drawing_id=$3 and revision=$4`, [to, user.id, id, dr.current_revision]);
    await c.query(`insert into status_transitions (org_id, entity_type, entity_id, from_status, to_status, actor_id, actor_name) values ($1,'drawing',$2,$3,$4,$5,$6)`, [dr.org_id, id, dr.status, to, user.id, user.name]);
    await logActivity(dr.org_id, 'drawing', id, 'status', `Status ${dr.status} → ${to}`, user, c);
    if (to === 'RELEASED' && dr.sales_order_id) {
      await logActivity(dr.org_id, 'order', dr.sales_order_id, 'system', `Drawing ${dr.drawing_number} RELEASED — engineering gate cleared`, user, c);
    }
    await audit({ orgId: dr.org_id, actorId: user.id, actorName: user.name, action: 'drawing.transition', entityType: 'drawing', entityId: id, before: { status: dr.status }, after: { status: to } }, c);
  });
}

export async function newRevision(user: AuthUser, id: string): Promise<void> {
  return tx(async (c) => {
    const dr = await c.one<any>(`select * from drawings where id=$1 and org_id=any($2)`, [id, user.orgIds]);
    if (!dr) throw new AppError('Drawing not found', 404, 'NOT_FOUND');
    const rev = dr.current_revision + 1;
    await c.query(`update drawings set current_revision=$1, status='DRAFT' where id=$2`, [rev, id]);
    await c.query(`insert into drawing_revisions (drawing_id, revision, status, uploaded_by) values ($1,$2,'DRAFT',$3)`, [id, rev, user.id]);
    await logActivity(dr.org_id, 'drawing', id, 'system', `New revision ${rev} created`, user, c);
    await audit({ orgId: dr.org_id, actorId: user.id, actorName: user.name, action: 'drawing.revise', entityType: 'drawing', entityId: id, after: { revision: rev } }, c);
  });
}
