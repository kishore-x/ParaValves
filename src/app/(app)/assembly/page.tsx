import Link from 'next/link';
import { requireUser } from '@/server/auth/action';
import { query } from '@/server/db';
import { Card, CardHeader, Table, Th, Td, StatusPill, PageHeader, Field, Button, inputCls } from '@/components/ui';
import { Flash } from '@/components/flash';
import { newSerialAction } from '../mfg-actions';

export default async function AssemblyPage({ searchParams }: { searchParams: Promise<{ error?: string; ok?: string }> }) {
  const sp = await searchParams;
  const user = await requireUser();
  const org = user.currentOrgId;
  const [units, wos, lots] = await Promise.all([
    query<any>(`select u.*, p.name pname, so.order_number, w.wo_number from serial_units u join products p on p.id=u.product_id left join sales_orders so on so.id=u.sales_order_id left join work_orders w on w.id=u.work_order_id where u.org_id=$1 order by u.created_at desc limit 100`, [org]),
    query<any>(`select w.id, w.wo_number, p.name pname from work_orders w join products p on p.id=w.product_id where w.org_id=$1 and w.status in ('IN_PROGRESS','COMPLETED','RELEASED') order by w.wo_number`, [org]),
    query<any>(`select l.id, l.lot_number, p.name pname, l.status from material_lots l join products p on p.id=l.product_id where l.org_id=$1 and l.status in ('RELEASED','CONSUMED') order by l.lot_number`, [org]),
  ]);
  const lotSel = (name: string, label: string) => (
    <Field label={label} hint="Only released lots can be assembled"><select name={name} className={inputCls}><option value="">—</option>{lots.map((l: any) => <option key={l.id} value={l.id}>{l.lot_number} · {l.pname}</option>)}</select></Field>);
  return (
    <div className="space-y-6">
      <PageHeader title="Assembly & serials" subtitle="Assign serial/tag, capture critical-component genealogy and as-built revision" />
      <Flash error={sp.error} ok={sp.ok} />
      <Card>
        <CardHeader title="Assemble a valve" subtitle="Quarantined or rejected lots are rejected by the system" />
        <form action={newSerialAction} className="grid gap-3 p-5 md:grid-cols-4">
          <Field label="Work order"><select name="work_order_id" required className={inputCls}>{wos.map((w: any) => <option key={w.id} value={w.id}>{w.wo_number} · {w.pname}</option>)}</select></Field>
          <Field label="Serial (optional)"><input name="serial_number" placeholder="auto" className={inputCls} /></Field>
          <Field label="Customer tag"><input name="tag_number" className={inputCls} /></Field>
          <div />
          {lotSel('lot_body', 'Body lot')}{lotSel('lot_stem', 'Stem lot')}{lotSel('lot_seat', 'Seat lot')}{lotSel('lot_bonnet', 'Bonnet lot')}
          <div className="md:col-span-4"><Button type="submit">Assemble & assign serial</Button></div>
        </form>
      </Card>
      <Card>
        <CardHeader title={`Serialised units (${units.length})`} />
        <Table><thead><tr><Th>Serial</Th><Th>Tag</Th><Th>Product</Th><Th>WO</Th><Th>Order</Th><Th>As-built rev</Th><Th>Status</Th></tr></thead>
          <tbody>{units.map((u: any) => (
            <tr key={u.id} className="hover:bg-bg"><Td><Link href={`/assembly/${u.id}`} className="font-mono text-xs font-semibold text-brand">{u.serial_number}</Link></Td><Td>{u.tag_number ?? '—'}</Td><Td>{u.pname}</Td><Td>{u.wo_number ?? '—'}</Td><Td>{u.order_number ?? '—'}</Td><Td className="text-xs">{u.drawing_revision ?? '—'}</Td><Td><StatusPill status={u.status} /></Td></tr>))}</tbody></Table>
      </Card>
    </div>
  );
}
