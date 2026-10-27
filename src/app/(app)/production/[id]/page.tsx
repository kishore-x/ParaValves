import { notFound } from 'next/navigation';
import Link from 'next/link';
import { requireUser } from '@/server/auth/action';
import { one, query } from '@/server/db';
import { releaseGates } from '@/server/domain/production';
import { Card, CardHeader, Table, Th, Td, StatusPill, PageHeader, Field, Button, inputCls, Badge } from '@/components/ui';
import { Flash } from '@/components/flash';
import { formatMoney } from '@/lib/money';
import { releaseWorkOrderAction, holdWorkOrderAction, issueMaterialAction, recordOperationAction } from '../../mfg-actions';

export default async function WorkOrderPage({ params, searchParams }: { params: Promise<{ id: string }>; searchParams: Promise<{ error?: string; ok?: string }> }) {
  const { id } = await params; const sp = await searchParams;
  const user = await requireUser();
  const wo = await one<any>(`select w.*, p.name pname, p.product_code, so.order_number from work_orders w join products p on p.id=w.product_id left join sales_orders so on so.id=w.sales_order_id where w.id=$1 and w.org_id=any($2)`, [id, user.orgIds]);
  if (!wo) notFound();
  const [ops, issues, lots, costs, units] = await Promise.all([
    query<any>(`select * from work_order_operations where work_order_id=$1 order by seq`, [id]),
    query<any>(`select i.*, l.lot_number, l.heat_number, p.name pname from wo_material_issues i join material_lots l on l.id=i.lot_id join products p on p.id=i.product_id where i.work_order_id=$1 order by i.issued_at`, [id]),
    query<any>(`select l.id, l.lot_number, l.qty_available, p.name pname from material_lots l join products p on p.id=l.product_id where l.org_id=$1 and l.status='RELEASED' and l.qty_available>0 order by l.lot_number`, [wo.org_id]),
    query<any>(`select cost_type, sum(amount) amt from cost_entries where work_order_id=$1 group by cost_type`, [id]),
    query<any>(`select id, serial_number, status from serial_units where work_order_id=$1 order by serial_number`, [id]),
  ]);
  const gates = wo.status === 'PLANNED' || wo.status === 'ON_HOLD' ? await releaseGates({ one: one, query }, wo) : { ok: true, reasons: [] };
  const actual = Object.fromEntries(costs.map((c: any) => [c.cost_type, Number(c.amt)]));
  return (
    <div className="space-y-6">
      <PageHeader title={`${wo.wo_number} · ${wo.pname}`} subtitle={<span>Qty {Number(wo.quantity)} · order {wo.order_number ?? 'stock build'} · <StatusPill status={wo.status} /></span>}
        action={<div className="flex gap-2">{(wo.status === 'PLANNED' || wo.status === 'ON_HOLD') && <form action={releaseWorkOrderAction}><input type="hidden" name="id" value={id} /><Button type="submit">Release to shop floor</Button></form>}<Button href="/production" variant="ghost">Back</Button></div>} />
      <Flash error={sp.error} ok={sp.ok} />
      {!gates.ok && <div className="rounded-lg border border-amber-200 bg-amber-50 px-4 py-3 text-sm text-amber-900"><b>Release blocked.</b> {gates.reasons.join(' · ')}</div>}
      {wo.hold_reason && <div className="rounded-lg border border-line bg-bg px-4 py-3 text-sm">On hold: {wo.hold_reason}</div>}

      <Card>
        <CardHeader title="Operations" subtitle="Progress, labour, scrap/rework and downtime per operation" />
        <Table><thead><tr><Th>#</Th><Th>Operation</Th><Th>Centre</Th><Th>Hours (act/plan)</Th><Th>Scrap</Th><Th>Rework</Th><Th>Down (min)</Th><Th>Status</Th><Th>Record</Th></tr></thead>
          <tbody>{ops.map((o: any) => (
            <tr key={o.id} className="align-top"><Td>{o.seq}</Td><Td className="font-medium">{o.name}{o.is_subcontract && <Badge tone="warn">subcontract</Badge>}</Td><Td className="text-xs">{o.work_center}</Td>
              <Td>{Number(o.actual_hours)} / {Number(o.planned_hours)}</Td><Td>{Number(o.scrap_qty)}</Td><Td>{Number(o.rework_qty)}</Td><Td>{o.downtime_minutes}</Td><Td><StatusPill status={o.status} /></Td>
              <Td>{o.status !== 'DONE' && wo.status !== 'COMPLETED' && (o.is_subcontract
                ? <Link href="/subcontract" className="text-xs text-brand">Manage via Subcontract →</Link>
                : <form action={recordOperationAction} className="flex flex-wrap items-center gap-1">
                  <input type="hidden" name="id" value={id} /><input type="hidden" name="op_id" value={o.id} />
                  <input name="hours" type="number" step="0.5" placeholder="hrs" className={`${inputCls} !h-8 !w-16`} /><input name="scrap" type="number" placeholder="scrap" className={`${inputCls} !h-8 !w-16`} /><input name="rework" type="number" placeholder="rwk" className={`${inputCls} !h-8 !w-14`} /><input name="downtime" type="number" placeholder="down" className={`${inputCls} !h-8 !w-16`} />
                  <label className="flex items-center gap-1 text-xs"><input type="checkbox" name="done" />done</label><Button type="submit" size="sm">Save</Button></form>)}</Td></tr>))}</tbody></Table>
      </Card>

      <div className="grid gap-6 lg:grid-cols-2">
        <Card>
          <CardHeader title="Material issued (lot traceability)" />
          <Table><thead><tr><Th>Lot</Th><Th>Heat</Th><Th>Material</Th><Th>Qty</Th></tr></thead>
            <tbody>{issues.length === 0 ? <tr><Td className="text-xs text-muted">Nothing issued yet</Td></tr> : issues.map((i: any) => <tr key={i.id}><Td className="font-medium">{i.lot_number}</Td><Td>{i.heat_number ?? '—'}</Td><Td>{i.pname}</Td><Td>{Number(i.quantity)}</Td></tr>)}</tbody></Table>
          {wo.status !== 'PLANNED' && wo.status !== 'COMPLETED' && (
            <form action={issueMaterialAction} className="flex items-end gap-2 border-t border-line p-4">
              <input type="hidden" name="id" value={id} />
              <Field label="Released lot"><select name="lot_id" className={inputCls}>{lots.map((l: any) => <option key={l.id} value={l.id}>{l.lot_number} · {l.pname} · {Number(l.qty_available)} avail</option>)}</select></Field>
              <Field label="Qty"><input name="quantity" type="number" min="1" defaultValue={1} className={`${inputCls} !w-20`} /></Field><Button type="submit">Issue</Button>
            </form>)}
        </Card>
        <Card>
          <CardHeader title="Cost — planned vs actual" />
          <Table><thead><tr><Th>Type</Th><Th>Planned</Th><Th>Actual</Th></tr></thead><tbody>
            {([['MATERIAL', wo.planned_material_cost], ['LABOR', wo.planned_labor_cost], ['SUBCONTRACT', wo.planned_subcontract_cost], ['OVERHEAD', wo.planned_overhead], ['SCRAP', 0]] as const).map(([k, pl]) => (
              <tr key={k}><Td>{k.toLowerCase()}</Td><Td>{formatMoney(pl)}</Td><Td>{formatMoney(actual[k] ?? 0)}</Td></tr>))}</tbody></Table>
          <div className="border-t border-line p-4">
            <h3 className="mb-2 text-xs font-semibold uppercase text-muted">Finished units</h3>
            {units.length === 0 ? <p className="text-xs text-muted">None yet — <Link href="/assembly" className="text-brand">assemble from this work order</Link></p> : <div className="flex flex-wrap gap-2">{units.map((u: any) => <Link key={u.id} href={`/assembly/${u.id}`}><Badge tone="brand">{u.serial_number} · {u.status.replace('_', ' ')}</Badge></Link>)}</div>}
          </div>
          {wo.status !== 'COMPLETED' && wo.status !== 'PLANNED' && (
            <form action={holdWorkOrderAction} className="flex gap-2 border-t border-line p-4"><input type="hidden" name="id" value={id} /><input name="reason" placeholder="Hold reason" className={inputCls} /><Button type="submit" variant="ghost">Hold</Button></form>)}
        </Card>
      </div>
    </div>
  );
}
