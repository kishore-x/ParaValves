import { type NextRequest } from 'next/server';
import { getCurrentUser } from '@/server/auth/session';
import { can } from '@/server/auth/rbac';
import { one, query } from '@/server/db';
import { buildPdf } from '@/server/pdf/documents';
import { audit } from '@/server/audit';

export async function GET(_req: NextRequest, seg: { params: Promise<{ id: string }> }) {
  const user = await getCurrentUser();
  if (!user) return new Response('Unauthorized', { status: 401 });
  if (!can(user, 'invoice.view')) return new Response('Forbidden', { status: 403 });
  const { id } = await seg.params;

  const inv = await one<any>(
    `select i.*, c.name party_name, c.gstin party_gstin, c.city, c.state_code, c.country,
            o.name org_name, o.gstin org_gstin, o.state_code org_state
     from invoices i join companies c on c.id=i.company_id join organizations o on o.id=i.org_id
     where i.id=$1 and i.org_id = any($2)`, [id, user.orgIds]);
  if (!inv) return new Response('Not found', { status: 404 });
  const lines = await query<any>(`select * from invoice_lines where invoice_id=$1 order by line_no`, [id]);

  const pdf = await buildPdf({
    kind: 'INVOICE', number: inv.invoice_number, date: inv.invoice_date, dueDate: inv.due_date,
    currency: inv.currency, isExport: inv.is_export, placeOfSupply: inv.place_of_supply,
    org: { name: inv.org_name, gstin: inv.org_gstin, state_code: inv.org_state },
    party: { name: inv.party_name, gstin: inv.party_gstin, city: inv.city, state_code: inv.state_code, country: inv.country },
    lines, subtotal: inv.subtotal, cgst: inv.cgst, sgst: inv.sgst, igst: inv.igst, roundOff: inv.round_off,
    grandTotal: inv.grand_total, paidAmount: inv.paid_amount, notes: inv.notes,
  });
  await audit({ orgId: inv.org_id, actorId: user.id, actorName: user.name, action: 'invoice.export_pdf', entityType: 'invoice', entityId: id });
  return new Response(pdf as any, {
    headers: { 'Content-Type': 'application/pdf', 'Content-Disposition': `inline; filename="${inv.invoice_number}.pdf"` },
  });
}
