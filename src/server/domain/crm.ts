import 'server-only';
import { tx, query } from '@/server/db';
import { nextNumber } from '@/server/numbering/engine';
import { audit, logActivity } from '@/server/audit';
import { canTransition, LEAD } from '@/server/workflow/machines';
import { AppError, Conflict } from '@/server/http/errors';
import type { AuthUser } from '@/server/auth/session';

export async function createLead(
  user: AuthUser,
  input: {
    company_name: string; contact_name?: string; email?: string; phone?: string;
    country?: string; product_requirement?: string; quantity?: number; description?: string;
    source?: string; priority?: string; expected_value?: number; expected_close?: string;
  },
): Promise<{ id: string; lead_number: string }> {
  return tx(async (c) => {
    const leadNumber = await nextNumber(c, user.currentOrgId, 'LEAD');
    const row = (await c.query<{ id: string }>(
      `insert into leads (org_id, lead_number, company_name, contact_name, email, phone, country,
         product_requirement, quantity, description, source, priority, expected_value, expected_close, owner_id, created_by, updated_by)
       values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$16) returning id`,
      [user.currentOrgId, leadNumber, input.company_name, input.contact_name ?? null, input.email ?? null,
       input.phone ?? null, input.country ?? null, input.product_requirement ?? null, input.quantity ?? null,
       input.description ?? null, input.source ?? 'MANUAL', input.priority ?? 'NORMAL',
       input.expected_value ?? null, input.expected_close || null, user.id, user.id],
    ))[0]!;
    await logActivity(user.currentOrgId, 'lead', row.id, 'system', `Lead ${leadNumber} created`, user, c);
    await audit({ orgId: user.currentOrgId, actorId: user.id, actorName: user.name, action: 'lead.create', entityType: 'lead', entityId: row.id, after: input }, c);

    // automation: follow-up task (idempotent by source_key)
    const taskNumber = await nextNumber(c, user.currentOrgId, 'TASK');
    await c.query(
      `insert into tasks (org_id, task_number, title, entity_type, entity_id, assignee_id, due_at, source_key, created_by)
       values ($1,$2,$3,'lead',$4,$5, now() + interval '5 hours', $6, $7)
       on conflict (org_id, source_key) do nothing`,
      [user.currentOrgId, taskNumber, `Contact lead ${leadNumber} — ${input.company_name}`, row.id, user.id, `lead-followup-${row.id}`, user.id],
    );
    return { id: row.id, lead_number: leadNumber };
  });
}

export async function transitionLead(user: AuthUser, id: string, to: string, version: number, reason?: string) {
  return tx(async (c) => {
    const lead = await c.one<{ status: string; org_id: string; lead_number: string; company_name: string }>(
      `select status, org_id, lead_number, company_name from leads where id=$1 and org_id = any($2)`, [id, user.orgIds]);
    if (!lead) throw new AppError('Lead not found', 404, 'NOT_FOUND');
    if (!canTransition(LEAD, lead.status, to))
      throw new AppError(`Cannot move lead from ${lead.status} to ${to}`, 422, 'INVALID_TRANSITION');
    const upd = await c.query(
      `update leads set status=$1, updated_by=$2 where id=$3 and version=$4 returning id`,
      [to, user.id, id, version]);
    if (upd.length === 0) throw Conflict();
    await c.query(
      `insert into status_transitions (org_id, entity_type, entity_id, from_status, to_status, actor_id, actor_name, reason)
       values ($1,'lead',$2,$3,$4,$5,$6,$7)`,
      [lead.org_id, id, lead.status, to, user.id, user.name, reason ?? null]);
    await logActivity(lead.org_id, 'lead', id, 'status', `Status ${lead.status} → ${to}`, user, c);
    await audit({ orgId: lead.org_id, actorId: user.id, actorName: user.name, action: 'lead.transition', entityType: 'lead', entityId: id, before: { status: lead.status }, after: { status: to } }, c);
  });
}

/** Convert a lead to a customer company (reusing an existing company if matched). */
export async function convertLead(user: AuthUser, id: string): Promise<{ company_id: string }> {
  return tx(async (c) => {
    const lead = await c.one<{ id: string; org_id: string; company_name: string; contact_name: string | null; email: string | null; phone: string | null; country: string | null; company_id: string | null; lead_number: string }>(
      `select * from leads where id=$1 and org_id = any($2)`, [id, user.orgIds]);
    if (!lead) throw new AppError('Lead not found', 404, 'NOT_FOUND');
    if (lead.company_id) return { company_id: lead.company_id };

    // reuse existing company by name (no duplicate data)
    let company = await c.one<{ id: string }>(
      `select id from companies where org_id=$1 and lower(name)=lower($2) and archived_at is null limit 1`,
      [lead.org_id, lead.company_name]);
    if (!company) {
      const num = await nextNumber(c, lead.org_id, 'CUST');
      company = (await c.query<{ id: string }>(
        `insert into companies (org_id, company_number, name, is_customer, country, owner_id, created_by, updated_by)
         values ($1,$2,$3,true,$4,$5,$6,$6) returning id`,
        [lead.org_id, num, lead.company_name, lead.country ?? null, user.id, user.id]))[0]!;
    }
    // create contact if we have one
    if (lead.contact_name) {
      await c.query(
        `insert into contacts (org_id, company_id, name, email, phone, is_primary, created_by)
         values ($1,$2,$3,$4,$5,true,$6)`,
        [lead.org_id, company.id, lead.contact_name, lead.email ?? null, lead.phone ?? null, user.id]);
    }
    await c.query(`update leads set company_id=$1, converted_at=now(), status='WON', updated_by=$2 where id=$3`, [company.id, user.id, id]);
    await logActivity(lead.org_id, 'lead', id, 'system', `Converted to customer`, user, c);
    await audit({ orgId: lead.org_id, actorId: user.id, actorName: user.name, action: 'lead.convert', entityType: 'lead', entityId: id, after: { company_id: company.id } }, c);
    return { company_id: company.id };
  });
}

export async function findOrCreateCompanyByName(orgId: string, name: string, userId: string): Promise<string> {
  const existing = await query<{ id: string }>(
    `select id from companies where org_id=$1 and lower(name)=lower($2) and archived_at is null limit 1`, [orgId, name]);
  if (existing[0]) return existing[0].id;
  return tx(async (c) => {
    const num = await nextNumber(c, orgId, 'CUST');
    const r = await c.query<{ id: string }>(
      `insert into companies (org_id, company_number, name, is_customer, created_by, updated_by)
       values ($1,$2,$3,true,$4,$4) returning id`, [orgId, num, name, userId]);
    return r[0]!.id;
  });
}
