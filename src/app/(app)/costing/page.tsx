import Link from 'next/link';
import { requireUser } from '@/server/auth/action';
import { query } from '@/server/db';
import { Card, CardHeader, Table, Th, Td, StatusPill, PageHeader, StatTile } from '@/components/ui';
import { formatMoney } from '@/lib/money';

/** Planned vs actual cost per work order plus an inventory-to-finance reconciliation. */
export default async function CostingPage() {
  const user = await requireUser();
  const org = user.currentOrgId;
  const [rows, recon, ar] = await Promise.all([
    query<any>(`select w.id, w.wo_number, w.status, p.name pname,
        w.planned_material_cost pm, w.planned_labor_cost pl, w.planned_subcontract_cost ps, w.planned_overhead po,
        coalesce(sum(c.amount) filter (where c.cost_type='MATERIAL'),0) am, coalesce(sum(c.amount) filter (where c.cost_type='LABOR'),0) al,
        coalesce(sum(c.amount) filter (where c.cost_type='SUBCONTRACT'),0) asub, coalesce(sum(c.amount) filter (where c.cost_type='SCRAP'),0) ascr,
        coalesce(sum(c.amount) filter (where c.cost_type='OVERHEAD'),0) ao
      from work_orders w join products p on p.id=w.product_id left join cost_entries c on c.work_order_id=w.id where w.org_id=$1 group by w.id, p.name order by w.wo_number`, [org]),
    query<any>(`select (select coalesce(sum(s.on_hand * p.standard_cost),0) from stock_items s join products p on p.id=s.product_id where s.org_id=$1) stock_value,
        (select coalesce(sum(l.qty_available * p.standard_cost),0) from material_lots l join products p on p.id=l.product_id where l.org_id=$1 and l.status in ('RELEASED','QUARANTINE')) lot_value,
        (select coalesce(sum(amount),0) from cost_entries where org_id=$1) wip_cost`, [org]),
    query<any>(`select coalesce(sum(grand_total),0) billed, coalesce(sum(paid_amount),0) paid from invoices where org_id=$1 and status not in ('DRAFT','CANCELLED')`, [org]),
  ]);
  const tot = rows.reduce((a: any, r: any) => ({ plan: a.plan + Number(r.pm) + Number(r.pl) + Number(r.ps) + Number(r.po), act: a.act + Number(r.am) + Number(r.al) + Number(r.asub) + Number(r.ascr) + Number(r.ao) }), { plan: 0, act: 0 });
  const var_ = tot.act - tot.plan;
  const r = recon[0];
  return (
    <div className="space-y-6">
      <PageHeader title="Costing & reporting" subtitle="Planned vs actual material, labour, subcontract, scrap and overhead per work order" />
      <div className="grid gap-3 md:grid-cols-4">
        <StatTile label="Planned cost (all WOs)" value={formatMoney(tot.plan)} icon="money" />
        <StatTile label="Actual cost to date" value={formatMoney(tot.act)} icon="trending" tone="brand" />
        <StatTile label="Variance" value={formatMoney(var_)} tone={var_ > 0 ? 'danger' : 'ok'} hint={var_ > 0 ? 'over plan (actual includes WIP in progress)' : 'under plan'} icon="alert" />
        <StatTile label="Billed / collected" value={`${formatMoney(ar[0].billed)}`} hint={`${formatMoney(ar[0].paid)} collected`} icon="payment" />
      </div>
      <Card>
        <CardHeader title="Work order cost sheet" />
        <Table><thead><tr><Th>WO</Th><Th>Product</Th><Th>Status</Th><Th>Material</Th><Th>Labour</Th><Th>Subcontract</Th><Th>Scrap</Th><Th>Overhead</Th><Th>Plan</Th><Th>Actual</Th><Th>Var.</Th></tr></thead>
          <tbody>{rows.map((w: any) => { const plan = Number(w.pm) + Number(w.pl) + Number(w.ps) + Number(w.po); const act = Number(w.am) + Number(w.al) + Number(w.asub) + Number(w.ascr) + Number(w.ao); const v = act - plan; const done = w.status === 'COMPLETED'; return (
            <tr key={w.id}><Td><Link href={`/production/${w.id}`} className="font-mono text-xs font-semibold text-brand">{w.wo_number}</Link></Td><Td>{w.pname}</Td><Td><StatusPill status={w.status} /></Td>
              <Td className="text-xs">{formatMoney(w.am)}<div className="text-faint">/{formatMoney(w.pm)}</div></Td><Td className="text-xs">{formatMoney(w.al)}<div className="text-faint">/{formatMoney(w.pl)}</div></Td><Td className="text-xs">{formatMoney(w.asub)}<div className="text-faint">/{formatMoney(w.ps)}</div></Td>
              <Td className="text-xs">{formatMoney(w.ascr)}</Td><Td className="text-xs">{formatMoney(w.ao)}<div className="text-faint">/{formatMoney(w.po)}</div></Td>
              <Td>{formatMoney(plan)}</Td><Td className="font-medium">{formatMoney(act)}</Td><Td className={done && v > 0 ? 'font-semibold text-danger' : done ? 'font-semibold text-ok' : 'text-faint'}>{done ? formatMoney(v) : 'in progress'}</Td></tr>); })}</tbody></Table>
      </Card>
      <Card>
        <CardHeader title="Inventory ↔ finance reconciliation" subtitle="Stock ledger valuation vs traceable lots vs cost posted to work orders" />
        <Table><tbody>
          <tr><Td>Stock ledger value (on-hand × standard cost)</Td><Td className="text-right font-medium">{formatMoney(r.stock_value)}</Td></tr>
          <tr><Td>Traceable lot value (released + quarantine)</Td><Td className="text-right font-medium">{formatMoney(r.lot_value)}</Td></tr>
          <tr><Td>Cost posted to work orders (WIP + completed)</Td><Td className="text-right font-medium">{formatMoney(r.wip_cost)}</Td></tr>
        </tbody></Table>
      </Card>
    </div>
  );
}
