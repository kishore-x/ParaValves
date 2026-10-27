import { type NextRequest } from 'next/server';
import { getCurrentUser } from '@/server/auth/session';
import { can } from '@/server/auth/rbac';
import { one, query } from '@/server/db';
import { buildPdf } from '@/server/pdf/documents';
import { audit } from '@/server/audit';

export async function GET(_req: NextRequest, seg: { params: Promise<{ id: string }> }) {
  const user = await getCurrentUser();
  if (!user) return new Response('Unauthorized', { status: 401 });
  if (!can(user, 'quote.view')) return new Response('Forbidden', { status: 403 });
  const { id } = await seg.params;

  const q = await one<any>(
    `select q.*, c.name party_name, c.gstin party_gstin, c.city, c.state_code, c.country,
            o.name org_name, o.gstin org_gstin, o.state_code org_state
     from quotations q join companies c on c.id=q.company_id join organizations o on o.id=q.org_id
     where q.id=$1 and q.org_id = any($2)`, [id, user.orgIds]);
  if (!q) return new Response('Not found', { status: 404 });
  const lines = await query<any>(`select * from quotation_lines where quotation_id=$1 order by line_no`, [id]);

  const pdf = await buildPdf({
    kind: 'QUOTATION', number: q.quote_number, date: q.created_at, validUntil: q.valid_until, currency: q.currency,
    org: { name: q.org_name, gstin: q.org_gstin, state_code: q.org_state },
    party: { name: q.party_name, gstin: q.party_gstin, city: q.city, state_code: q.state_code, country: q.country },
    lines, subtotal: q.subtotal, discountTotal: q.discount_total, taxTotal: q.tax_total, grandTotal: q.grand_total, notes: q.notes,
  });
  await audit({ orgId: q.org_id, actorId: user.id, actorName: user.name, action: 'quote.export_pdf', entityType: 'quote', entityId: id });
  return new Response(pdf as any, {
    headers: { 'Content-Type': 'application/pdf', 'Content-Disposition': `inline; filename="${q.quote_number}.pdf"` },
  });
}
