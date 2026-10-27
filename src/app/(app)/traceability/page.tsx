import Link from 'next/link';
import { requireUser } from '@/server/auth/action';
import { query } from '@/server/db';
import { Card, CardHeader, Table, Th, Td, StatusPill, PageHeader, Field, Button, inputCls, EmptyState } from '@/components/ui';
import { fmtDate } from '@/lib/format';

/** Supplier receipt → lot → production issue → assembly → test → shipment → customer, in either direction. */
export default async function TraceabilityPage({ searchParams }: { searchParams: Promise<{ q?: string }> }) {
  const { q } = await searchParams;
  const user = await requireUser();
  const org = user.currentOrgId;
  const term = (q ?? '').trim();
  let units: any[] = [], lots: any[] = [];
  if (term) {
    const like = `%${term}%`;
    units = await query<any>(
      `select u.id, u.serial_number, u.tag_number, u.status, u.drawing_revision, p.name pname, w.wo_number, so.order_number, co.name customer, s.shipment_number, s.shipped_at,
         (select json_agg(json_build_object('component', c.component_name, 'lot', l.lot_number, 'heat', l.heat_number, 'cert', l.certificate_ref, 'supplier', sup.name, 'grn', g.grn_number, 'sc', sc.sc_number, 'process', sc.process, 'scsup', scs.name))
            from unit_components c left join material_lots l on l.id=c.lot_id left join companies sup on sup.id=l.supplier_id left join goods_receipts g on g.id=l.goods_receipt_id
            left join subcontract_orders sc on sc.id=c.subcontract_id left join companies scs on scs.id=sc.supplier_id where c.serial_unit_id=u.id) comps,
         (select json_agg(json_build_object('type', t.test_type, 'result', t.result, 'no', t.test_number) order by t.performed_at) from test_records t where t.serial_unit_id=u.id) tests
       from serial_units u join products p on p.id=u.product_id left join work_orders w on w.id=u.work_order_id left join sales_orders so on so.id=u.sales_order_id left join companies co on co.id=so.company_id
         left join shipment_lines sl on sl.serial_unit_id=u.id left join shipments s on s.id=sl.shipment_id
       where u.org_id=$1 and (u.serial_number ilike $2 or u.tag_number ilike $2
         or u.id in (select serial_unit_id from unit_components c join material_lots l on l.id=c.lot_id where l.lot_number ilike $2 or l.heat_number ilike $2))
       order by u.serial_number limit 20`, [org, like]);
    lots = await query<any>(
      `select l.*, p.name pname, sup.name supplier, g.grn_number,
         (select count(*) from unit_components c where c.lot_id=l.id)::int used_in,
         (select string_agg(distinct w.wo_number, ', ') from wo_material_issues i join work_orders w on w.id=i.work_order_id where i.lot_id=l.id) wos
       from material_lots l join products p on p.id=l.product_id left join companies sup on sup.id=l.supplier_id left join goods_receipts g on g.id=l.goods_receipt_id
       where l.org_id=$1 and (l.lot_number ilike $2 or l.heat_number ilike $2) limit 20`, [org, like]);
  }
  return (
    <div className="space-y-6">
      <PageHeader title="Traceability" subtitle="Search a serial, tag, lot or heat number to see supplier receipt → production → assembly → test → shipment" />
      <form className="flex max-w-xl gap-2"><input name="q" defaultValue={term} placeholder="Serial, tag, lot or heat number…" className={inputCls} autoFocus /><Button type="submit">Trace</Button></form>
      {!term && <Card><EmptyState title="Enter a serial, lot or heat number" hint="Try PV-2026-00001 or a heat number like H-" icon="search" /></Card>}
      {term && units.length === 0 && lots.length === 0 && <Card><EmptyState title={`Nothing found for “${term}”`} icon="search" /></Card>}
      {lots.map((l: any) => (
        <Card key={l.id}>
          <CardHeader title={`Lot ${l.lot_number}`} subtitle={`${l.pname} · supplier ${l.supplier ?? '—'} · GRN ${l.grn_number ?? '—'} · heat ${l.heat_number ?? '—'} · cert ${l.certificate_ref ?? '—'}`} action={<StatusPill status={l.status} />} />
          <p className="px-5 py-4 text-sm">Received {fmtDate(l.received_at)} · qty {Number(l.quantity)} · available {Number(l.qty_available)} · issued to WO: <b>{l.wos ?? 'none'}</b> · built into <b>{l.used_in}</b> unit(s) (shown below if matched)</p>
        </Card>))}
      {units.map((u: any) => (
        <Card key={u.id}>
          <CardHeader title={<Link href={`/assembly/${u.id}`} className="text-brand">{u.serial_number}</Link>} subtitle={`${u.pname} · ${u.drawing_revision ?? 'no rev'} · WO ${u.wo_number ?? '—'}`} action={<StatusPill status={u.status} />} />
          <div className="grid gap-4 p-5 md:grid-cols-3">
            <div><h4 className="mb-1 text-2xs font-semibold uppercase text-muted">Materials (backward)</h4>{(u.comps ?? []).map((c: any, i: number) => (
              <p key={i} className="text-xs">{c.component}: <b>{c.lot ?? c.sc}</b>{c.heat && ` · heat ${c.heat}`}{c.cert && ` · ${c.cert}`}<br /><span className="text-muted">{c.supplier ?? c.scsup}{c.grn && ` · ${c.grn}`}{c.process && ` · ${c.process}`}</span></p>))}</div>
            <div><h4 className="mb-1 text-2xs font-semibold uppercase text-muted">Tests</h4>{(u.tests ?? []).map((t: any) => <p key={t.no} className="text-xs">{t.type.replace('_', ' ')} <StatusPill status={t.result} /></p>)}{!(u.tests ?? []).length && <p className="text-xs text-muted">None</p>}</div>
            <div><h4 className="mb-1 text-2xs font-semibold uppercase text-muted">Customer (forward)</h4><p className="text-xs">Order {u.order_number ?? '—'}<br />{u.customer ?? '—'}<br />{u.shipment_number ? <>Shipped on {u.shipment_number} ({fmtDate(u.shipped_at)})</> : 'Not shipped'}</p></div>
          </div>
        </Card>))}
    </div>
  );
}
