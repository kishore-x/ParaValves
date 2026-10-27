import { notFound } from 'next/navigation';
import { requireUser } from '@/server/auth/action';
import { one, query } from '@/server/db';
import { Card, CardHeader, PageHeader, Table, Th, Td, EmptyState, Button, Field, inputCls } from '@/components/ui';
import { formatMoney } from '@/lib/money';
import { num, fmtDate } from '@/lib/format';
import { genPartNumberAction } from '../actions';

export default async function ProductDetail({ params }: { params: Promise<{ id: string }> }) {
  const user = await requireUser();
  const { id } = await params;
  const p = await one<any>(`select * from products where id=$1 and org_id=any($2)`, [id, user.orgIds]);
  if (!p) notFound();
  const [stock, parts] = await Promise.all([
    query<any>(`select w.name warehouse, s.on_hand, s.reserved, s.incoming from stock_items s join warehouses w on w.id=s.warehouse_id where s.product_id=$1`, [id]),
    query<any>(`select part_number, revision, created_at from part_numbers where product_id=$1 order by revision desc`, [id]),
  ]);
  return (
    <div>
      <PageHeader title={`${p.product_code}`} subtitle={p.name} />
      <div className="grid gap-5 lg:grid-cols-3">
        <div className="space-y-5 lg:col-span-2">
          <Card>
            <CardHeader title="Specifications" />
            <dl className="grid grid-cols-2 gap-x-6 gap-y-3 p-5 text-sm sm:grid-cols-3">
              <I l="Material" v={p.material} /><I l="Dimensions" v={p.dimensions} /><I l="UOM" v={p.uom} />
              <I l="HSN/SAC" v={p.hsn_sac} /><I l="Tax rate" v={`${num(p.tax_rate)}%`} /><I l="Type" v={p.is_manufactured ? 'Manufactured' : 'Purchased'} />
              <I l="Standard cost" v={formatMoney(p.standard_cost)} /><I l="Selling price" v={formatMoney(p.selling_price)} />
              <I l="Min stock" v={num(p.min_stock)} /><I l="Reorder point" v={num(p.reorder_point)} />
            </dl>
          </Card>
          <Card>
            <CardHeader title="Stock by warehouse" />
            {stock.length === 0 ? <EmptyState title="No stock records" /> : (
              <Table><thead><tr><Th>Warehouse</Th><Th>On hand</Th><Th>Reserved</Th><Th>Available</Th><Th>Incoming</Th></tr></thead>
                <tbody>{stock.map((s, i) => (
                  <tr key={i}><Td>{s.warehouse}</Td><Td>{num(s.on_hand)}</Td><Td>{num(s.reserved)}</Td><Td className="font-medium">{num(Number(s.on_hand) - Number(s.reserved))}</Td><Td>{num(s.incoming)}</Td></tr>
                ))}</tbody></Table>
            )}
          </Card>
        </div>
        <Card>
          <CardHeader title="Part Numbers" subtitle="Auto-generated, revision-controlled" />
          {parts.length === 0 ? <EmptyState title="No part numbers yet" /> : (
            <ul className="border-b border-line p-4">
              {parts.map((pt) => (
                <li key={pt.part_number} className="flex items-center justify-between py-1 text-sm">
                  <span className="font-mono text-ink">{pt.part_number}</span>
                  <span className="text-xs text-faint">Rev {pt.revision} · {fmtDate(pt.created_at)}</span>
                </li>
              ))}
            </ul>
          )}
          <form action={genPartNumberAction} className="grid gap-3 p-4">
            <input type="hidden" name="product_id" value={p.id} />
            <Field label="Family"><input name="family" placeholder="e.g. BV" defaultValue={p.name.split(' ')[0]?.slice(0,3).toUpperCase()} className={inputCls} /></Field>
            <div className="grid grid-cols-2 gap-3">
              <Field label="Size"><input name="size" placeholder="50" className={inputCls} /></Field>
              <Field label="Material"><input name="material" defaultValue={p.material ?? ''} className={inputCls} /></Field>
            </div>
            <Field label="Config"><input name="config" placeholder="optional" className={inputCls} /></Field>
            <Button type="submit" size="sm">Generate Part Number</Button>
          </form>
        </Card>
      </div>
    </div>
  );
}
function I({ l, v }: { l: string; v: React.ReactNode }) {
  return <div><dt className="text-xs font-medium text-muted">{l}</dt><dd className="mt-0.5 text-ink">{v || '—'}</dd></div>;
}
