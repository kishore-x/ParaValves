import { requireUser } from '@/server/auth/action';
import { query } from '@/server/db';
import { Card, CardHeader, Table, Th, Td, StatusPill, PageHeader, Field, Button, inputCls, Badge } from '@/components/ui';
import { Flash } from '@/components/flash';
import { formatMoney } from '@/lib/money';
import { fmtDate } from '@/lib/format';
import { newBomRevisionAction, addBomLineAction, releaseBomAction } from '../mfg-actions';

export default async function BomPage({ searchParams }: { searchParams: Promise<{ error?: string; ok?: string }> }) {
  const sp = await searchParams;
  const user = await requireUser();
  const org = user.currentOrgId;
  const [products, boms, lines, components] = await Promise.all([
    query<any>(`select id, product_code, name from products where org_id=$1 and is_manufactured order by product_code`, [org]),
    query<any>(`select * from boms where org_id=$1 order by product_id, revision desc`, [org]),
    query<any>(`select l.*, p.product_code, p.name, p.standard_cost from bom_lines l join products p on p.id=l.component_id where l.bom_id in (select id from boms where org_id=$1)`, [org]),
    query<any>(`select id, product_code, name from products where org_id=$1 and not is_manufactured order by product_code`, [org]),
  ]);
  return (
    <div className="space-y-6">
      <PageHeader title="Bills of material" subtitle="Revision-controlled BOMs with effectivity — only a released BOM can drive production" />
      <Flash error={sp.error} ok={sp.ok} />
      {products.map((p: any) => {
        const pb = boms.filter((b: any) => b.product_id === p.id);
        const cur = pb.find((b: any) => b.status === 'RELEASED') ?? pb[0];
        const draft = pb.find((b: any) => b.status === 'DRAFT');
        const shown = draft ?? cur;
        const ls = shown ? lines.filter((l: any) => l.bom_id === shown.id) : [];
        const cost = ls.reduce((a: number, l: any) => a + Number(l.quantity) * (1 + Number(l.scrap_pct) / 100) * Number(l.standard_cost), 0);
        return (
          <Card key={p.id}>
            <CardHeader title={`${p.product_code} · ${p.name}`} subtitle={shown ? `Revision ${shown.revision}${shown.effective_date ? ` · effective ${fmtDate(shown.effective_date)}` : ''} · rolled-up material cost ${formatMoney(cost)}` : 'No BOM defined'}
              action={<div className="flex items-center gap-2">{shown && <StatusPill status={shown.status} />}{!draft && <form action={newBomRevisionAction}><input type="hidden" name="product_id" value={p.id} /><Button type="submit" size="sm" variant="ghost">{shown ? 'New revision' : 'Create BOM'}</Button></form>}</div>} />
            {shown && (
              <>
                <Table><thead><tr><Th>Component</Th><Th>Qty</Th><Th>Scrap %</Th><Th>Std cost</Th></tr></thead>
                  <tbody>{ls.map((l: any) => <tr key={l.id}><Td className="font-medium">{l.product_code} <span className="font-normal text-muted">{l.name}</span></Td><Td>{Number(l.quantity)}</Td><Td>{Number(l.scrap_pct)}</Td><Td>{formatMoney(l.standard_cost)}</Td></tr>)}</tbody></Table>
                {shown.status === 'DRAFT' && (
                  <div className="flex flex-wrap items-end gap-2 border-t border-line p-4">
                    <form action={addBomLineAction} className="flex flex-wrap items-end gap-2"><input type="hidden" name="bom_id" value={shown.id} />
                      <Field label="Component"><select name="component_id" className={inputCls}>{components.map((c: any) => <option key={c.id} value={c.id}>{c.product_code} · {c.name}</option>)}</select></Field>
                      <Field label="Qty"><input name="quantity" type="number" min="0.01" step="0.01" defaultValue={1} className={`${inputCls} !w-20`} /></Field>
                      <Field label="Scrap %"><input name="scrap_pct" type="number" step="0.5" defaultValue={0} className={`${inputCls} !w-20`} /></Field>
                      <Button type="submit" size="sm">Add line</Button></form>
                    <form action={releaseBomAction}><input type="hidden" name="bom_id" value={shown.id} /><Button type="submit" size="sm">Release revision {shown.revision}</Button></form>
                    <Badge tone="warn">draft — not yet usable for production</Badge>
                  </div>)}
              </>)}
          </Card>);
      })}
    </div>
  );
}
