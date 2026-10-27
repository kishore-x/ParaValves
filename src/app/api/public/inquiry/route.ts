import { NextResponse, type NextRequest } from 'next/server';
import { z } from 'zod';
import { query, one, tx } from '@/server/db';
import { nextNumber } from '@/server/numbering/engine';
import { logActivity } from '@/server/audit';
import { env } from '@/server/env';

const schema = z.object({
  company_name: z.string().min(2).max(200),
  contact_name: z.string().max(120).optional(),
  email: z.string().email().max(160),
  phone: z.string().max(40).optional(),
  country: z.string().max(60).optional(),
  product_requirement: z.string().max(500).optional(),
  quantity: z.coerce.number().positive().optional(),
  message: z.string().max(2000).optional(),
  website: z.string().max(0).optional(), // honeypot — must be empty
});

async function rateOk(ip: string): Promise<boolean> {
  const windowKey = `${new Date().toISOString().slice(0, 13)}`; // hourly
  const row = await one<{ count: number }>(
    `insert into rate_limits (bucket, window_key, count) values ($1,$2,1)
     on conflict (bucket, window_key) do update set count = rate_limits.count + 1 returning count`,
    [`inquiry:${ip}`, windowKey]);
  return (row?.count ?? 0) <= env.WEBSITE_RATE_PER_HOUR;
}

export async function POST(req: NextRequest) {
  // shared-secret check
  const key = req.headers.get('x-paravalves-key');
  if (!env.WEBSITE_INQUIRY_API_KEY || key !== env.WEBSITE_INQUIRY_API_KEY) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }
  const ip = req.headers.get('x-forwarded-for')?.split(',')[0]?.trim() ?? 'unknown';
  if (!(await rateOk(ip))) return NextResponse.json({ error: 'Rate limit exceeded' }, { status: 429 });

  let body: unknown;
  try { body = await req.json(); } catch { return NextResponse.json({ error: 'Invalid JSON' }, { status: 400 }); }
  const parsed = schema.safeParse(body);
  if (!parsed.success) return NextResponse.json({ error: 'Validation failed', details: parsed.error.flatten() }, { status: 422 });
  const data = parsed.data;
  if (data.website) return NextResponse.json({ ok: true }, { status: 200 }); // silently drop bots

  // route to India org by default
  const org = await one<{ id: string }>(`select id from organizations where code='IN' limit 1`);
  if (!org) return NextResponse.json({ error: 'No organization configured' }, { status: 500 });

  // duplicate detection: same email in last 72h
  const dupe = await one<{ id: string }>(
    `select id from leads where org_id=$1 and email=$2 and created_at > now() - interval '72 hours' limit 1`,
    [org.id, data.email]);

  const result = await tx(async (c) => {
    if (dupe) {
      await c.query(`insert into inquiry_submissions (org_id, payload, ip, lead_id, is_duplicate) values ($1,$2,$3,$4,true)`,
        [org.id, JSON.stringify(data), ip, dupe.id]);
      return { lead_id: dupe.id, duplicate: true };
    }
    const leadNumber = await nextNumber(c, org.id, 'LEAD');
    // round-robin assign to a sales user in this org
    const owner = await c.one<{ id: string }>(
      `select u.id from users u join user_organizations uo on uo.user_id=u.id
       join user_roles ur on ur.user_id=u.id join roles r on r.id=ur.role_id
       where uo.org_id=$1 and r.code='sales' and u.is_active order by random() limit 1`, [org.id]);
    const lead = (await c.query<{ id: string }>(
      `insert into leads (org_id, lead_number, company_name, contact_name, email, phone, country, product_requirement, quantity, description, source, owner_id)
       values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,'WEBSITE',$11) returning id`,
      [org.id, leadNumber, data.company_name, data.contact_name ?? null, data.email, data.phone ?? null, data.country ?? null, data.product_requirement ?? null, data.quantity ?? null, data.message ?? null, owner?.id ?? null]))[0]!;
    await c.query(`insert into inquiry_submissions (org_id, payload, ip, lead_id) values ($1,$2,$3,$4)`, [org.id, JSON.stringify(data), ip, lead.id]);
    await logActivity(org.id, 'lead', lead.id, 'system', `Website inquiry received from ${data.company_name}`, undefined, c);
    // follow-up task
    const taskNumber = await nextNumber(c, org.id, 'TASK');
    await c.query(`insert into tasks (org_id, task_number, title, entity_type, entity_id, assignee_id, due_at, source_key) values ($1,$2,$3,'lead',$4,$5, now() + interval '5 hours',$6) on conflict (org_id, source_key) do nothing`,
      [org.id, taskNumber, `Contact website lead ${leadNumber}`, lead.id, owner?.id ?? null, `lead-followup-${lead.id}`]);
    if (owner) await c.query(`insert into notifications (org_id, user_id, category, title, body, link) values ($1,$2,'new_lead',$3,$4,$5)`,
      [org.id, owner.id, `New website lead: ${data.company_name}`, `${leadNumber} · follow up within 5 hours`, `/leads/${lead.id}`]);
    return { lead_id: lead.id, lead_number: leadNumber, duplicate: false };
  });

  return NextResponse.json({ ok: true, ...result }, { status: 201 });
}
