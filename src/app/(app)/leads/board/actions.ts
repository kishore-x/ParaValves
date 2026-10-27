'use server';
import { revalidatePath } from 'next/cache';
import { requirePermission } from '@/server/auth/action';
import { transitionLead } from '@/server/domain/crm';
import { one } from '@/server/db';

/** Move a lead to a new stage from the Kanban board. Returns ok/error for the UI. */
export async function moveLeadAction(id: string, to: string): Promise<{ ok: boolean; error?: string }> {
  try {
    const user = await requirePermission('lead.edit');
    const lead = await one<{ version: number }>('select version from leads where id=$1 and org_id=any($2)', [id, user.orgIds]);
    if (!lead) return { ok: false, error: 'Lead not found' };
    await transitionLead(user, id, to, lead.version);
    revalidatePath('/leads/board');
    return { ok: true };
  } catch (e) {
    return { ok: false, error: (e as Error).message };
  }
}
