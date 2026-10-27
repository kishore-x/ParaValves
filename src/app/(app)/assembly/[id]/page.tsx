import { notFound } from 'next/navigation';
import Link from 'next/link';
import { requireUser } from '@/server/auth/action';
import { one, query } from '@/server/db';
import { releaseGate } from '@/server/domain/quality';
import { Card, CardHeader, Table, Th, Td, StatusPill, PageHeader, Button, Badge } from '@/components/ui';
import { Flash } from '@/components/flash';
import { fmtDateTime } from '@/lib/format';
import { releaseUnitAction } from '../../mfg-actions';

export default async function UnitPage({ params, searchParams }: { params: Promise<{ id: string }>; searchParams: Promise<{ error?: string; ok?: string }> }) {
  const { id } = await params; const sp = await searchParams;
  const user = await requireUser();
  const u = await one<any>(`select u.*, p.name pname, p.product_code, so.order_number, co.name customer, w.wo_number from serial_units u join products p on p.id=u.product_id left join sales_orders so on so.id=u.sales_order_id left join companies co on co.id=so.company_id left join work_orders w on w.id=u.work_order_id where u.id=$1 and u.org_id=any($2)`, [id, user.orgIds]);
  if (!u) notFound();
  const [comps, tests, insp, ship] = await Promise.all([
    query<any>(`select c.*, l.lot_number, l.heat_number, l.certificate_ref, l.status lot_status, sup.name supplier, s.sc_number, s.process from unit_components c left join material_lots l on l.id=c.lot_id left join companies sup on sup.id=l.supplier_id left join subcontract_orders s on s.id=c.subcontract_id where c.serial_unit_id=$1`, [id]),
    query<any>(`select t.*, e.code eq from test_records t left join equipment e on e.id=t.equipment_id where t.serial_unit_id=$1 order by t.performed_at`, [id]),
    query<any>(`select * from inspections where subject_id=$1 order by created_at`, [id]),
    one<any>(`select s.shipment_number, s.shipped_at, s.status from shipment_lines l join shipments s on s.id=l.shipment_id where l.serial_unit_id=$1`, [id]),
  ]);
  const gate = await releaseGate({ one, query }, id);
  return (
    <div className="space-y-6">
      <PageHeader title={`${u.serial_number}${u.tag_number ? ` · tag ${u.tag_number}` : ''}`} subtitle={<span>{u.pname} · WO {u.wo_number ?? '—'} · order {u.order_number ?? '—'} ({u.customer ?? 'stock'}) · <StatusPill status={u.status} /></span>}
        action={<div className="flex gap-2">{u.status !== 'RELEASED' && u.status !== 'SHIPPED' && <form action={releaseUnitAction}><input type="hidden" name="id" value={id} /><Button type="submit" disabled={!gate.ok}>Release (quality)</Button></form>}<Button href="/assembly" variant="ghost">Back</Button></div>} />
      <Flash error={sp.error} ok={sp.ok} />
      {u.status !== 'RELEASED' && u.status !== 'SHIPPED' && (
        <Card className="p-4">
          <h3 className="mb-2 text-sm font-semibold">Release checklist</h3>
          {gate.ok ? <p className="text-sm text-ok">All gates satisfied — ready for quality release.</p> : <ul className="list-disc pl-5 text-sm text-danger">{gate.reasons.map((r) => <li key={r}>{r}</li>)}</ul>}
          <div className="mt-3 flex gap-2"><Button href="/quality" variant="ghost" size="sm">Open final inspection</Button><Button href={`/quality/tests?unit=${id}`} variant="ghost" size="sm">Record test</Button></div>
        </Card>)}
      <div className="grid gap-6 lg:grid-cols-2">
        <Card>
          <CardHeader title="As-built genealogy" subtitle={`Drawing ${u.drawing_revision ?? 'n/a'}`} />
          <Table><thead><tr><Th>Component</Th><Th>Lot / heat</Th><Th>Cert</Th><Th>Supplier</Th></tr></thead>
            <tbody>{comps.map((c: any) => (
              <tr key={c.id}><Td className="font-medium">{c.component_name}</Td><Td>{c.lot_number ?? c.sc_number ?? '—'}{c.heat_number && <div className="text-2xs text-muted">heat {c.heat_number}</div>}</Td><Td className="text-xs">{c.certificate_ref ?? '—'}</Td><Td className="text-xs">{c.supplier ?? c.process ?? '—'}</Td></tr>))}</tbody></Table>
          {ship && <div className="border-t border-line px-5 py-3 text-xs text-muted">Shipped on <b>{ship.shipment_number}</b> · {fmtDateTime(ship.shipped_at)}</div>}
        </Card>
        <Card>
          <CardHeader title="Inspections & tests" subtitle="Original failed results are retained" />
          <Table><thead><tr><Th>Record</Th><Th>Type</Th><Th>Result</Th><Th>When</Th></tr></thead>
            <tbody>{insp.map((i: any) => <tr key={i.id}><Td className="font-medium">{i.inspection_no}</Td><Td>{i.stage} inspection</Td><Td><StatusPill status={i.status} /></Td><Td className="text-xs text-faint">{fmtDateTime(i.decided_at ?? i.created_at)}</Td></tr>)}
              {tests.map((t: any) => <tr key={t.id}><Td className="font-medium">{t.test_number}</Td><Td>{t.test_type.replace('_', ' ')}{t.retest_of && <Badge>retest</Badge>}</Td><Td><StatusPill status={t.result} /></Td><Td className="text-xs text-faint">{fmtDateTime(t.performed_at)}</Td></tr>)}</tbody></Table>
        </Card>
      </div>
      <p className="text-xs text-muted">Full forward/backward trace: <Link className="text-brand" href={`/traceability?q=${u.serial_number}`}>open in Traceability</Link></p>
    </div>
  );
}
