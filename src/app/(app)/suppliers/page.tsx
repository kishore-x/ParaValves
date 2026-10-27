import Link from 'next/link';
import { requireUser } from '@/server/auth/action';
import { query } from '@/server/db';
import { Card, CardHeader, Table, Th, Td, StatusPill, PageHeader, Button, inputCls } from '@/components/ui';
import { Flash } from '@/components/flash';
import { toggleSupplierAction } from '../mfg-actions';

export default async function SuppliersPage({ searchParams }: { searchParams: Promise<{ error?: string; ok?: string }> }) {
  const sp = await searchParams;
  const user = await requireUser();
  const rows = await query<any>(
    `select c.*, (select count(*) from purchase_orders po where po.supplier_id=c.id)::int pos,
       (select count(*) from material_lots l where l.supplier_id=c.id and l.status='REJECTED')::int rejected_lots,
       (select count(*) from material_lots l where l.supplier_id=c.id)::int lots
     from companies c where c.org_id=$1 and c.is_supplier order by c.name`, [user.currentOrgId]);
  return (
    <div className="space-y-6">
      <PageHeader title="Approved suppliers" subtitle="Only approved or conditional suppliers can receive POs and subcontract work" />
      <Flash error={sp.error} ok={sp.ok} />
      <Card>
        <CardHeader title={`Supplier register (${rows.length})`} />
        <Table><thead><tr><Th>Supplier</Th><Th>Location</Th><Th>Rating</Th><Th>POs</Th><Th>Lots (rejected)</Th><Th>Approval</Th><Th>Change</Th></tr></thead>
          <tbody>{rows.map((s: any) => (
            <tr key={s.id}><Td><Link href={`/companies/${s.id}`} className="font-medium text-brand">{s.name}</Link></Td><Td className="text-xs">{[s.city, s.country].filter(Boolean).join(', ')}</Td><Td>{s.supplier_rating ? `${Number(s.supplier_rating).toFixed(1)} / 5` : '—'}</Td><Td>{s.pos}</Td><Td>{s.lots} ({s.rejected_lots})</Td><Td><StatusPill status={s.approval_status} /></Td>
              <Td><form action={toggleSupplierAction} className="flex gap-1"><input type="hidden" name="id" value={s.id} /><select name="status" defaultValue={s.approval_status} className={`${inputCls} !h-8 !w-32`}><option>APPROVED</option><option>CONDITIONAL</option><option>BLOCKED</option></select><Button type="submit" size="sm" variant="ghost">Set</Button></form></Td></tr>))}</tbody></Table>
      </Card>
    </div>
  );
}
