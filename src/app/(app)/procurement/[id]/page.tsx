import { notFound } from 'next/navigation';
import { requireUser } from '@/server/auth/action';
import { one, query } from '@/server/db';
import { PO } from '@/server/workflow/machines';
import { Card, CardHeader, PageHeader, StatusPill, Table, Th, Td, Button, Field, inputCls } from '@/components/ui';
import { ActivityTimeline } from '@/components/timeline';
import { formatMoney } from '@/lib/money';
import { fmtDate, num } from '@/lib/format';
import { transitionPOAction } from '../actions';
import { GrnForm } from './GrnForm';

export default async function PODetail({ params }: { params: Promise<{ id: string }> }) {
  const user = await requireUser();
  const { id } = await params;
  const po = await one<any>(`select po.*, c.name supplier from purchase_orders po join companies c on c.id=po.supplier_id where po.id=$1 and po.org_id=any($2)`, [id, user.orgIds]);
  if (!po) notFound();
  const lines = await query<any>(`select * from purchase_order_lines where purchase_order_id=$1 order by line_no`, [id]);
  const grns = await query<any>(`select grn_number, received_at from goods_receipts where purchase_order_id=$1 order by received_at desc`, [id]);
  const next = PO[po.status] ?? [];
  return (
    <div>
      <PageHeader title={po.po_number} subtitle={po.supplier} action={<StatusPill status={po.status} />} />
      <div className="grid gap-5 lg:grid-cols-3">
        <div className="space-y-5 lg:col-span-2">
          <Card>
            <CardHeader title="Line items" />
            <Table>
              <thead><tr><Th>#</Th><Th>Description</Th><Th>Qty</Th><Th>Received</Th><Th>Unit</Th><Th className="text-right">Total</Th></tr></thead>
              <tbody>{lines.map((l) => (
                <tr key={l.id}><Td>{l.line_no}</Td><Td>{l.description}</Td><Td>{num(l.quantity)}</Td>
                  <Td>{num(l.received_qty)}</Td><Td>{formatMoney(l.unit_price)}</Td><Td className="text-right font-medium">{formatMoney(l.line_total)}</Td></tr>
              ))}</tbody>
            </Table>
            <div className="flex justify-end p-4 text-sm"><div className="w-56"><div className="flex justify-between border-t border-line pt-1 font-semibold"><span>Total</span><span>{formatMoney(po.grand_total)}</span></div></div></div>
          </Card>

          {next.length > 0 && (
            <Card>
              <CardHeader title="Update status" />
              <form action={transitionPOAction} className="flex items-end gap-3 p-5">
                <input type="hidden" name="id" value={po.id} /><input type="hidden" name="version" value={po.version} />
                <div className="w-56"><Field label="Move to"><select name="to" className={inputCls}>{next.map((s) => <option key={s} value={s}>{s.replace(/_/g,' ')}</option>)}</select></Field></div>
                <Button type="submit">Update</Button>
              </form>
            </Card>
          )}

          {(po.status === 'SENT' || po.status === 'CONFIRMED' || po.status === 'PARTIALLY_RECEIVED') && (
            <Card>
              <CardHeader title="Goods Receipt (GRN)" subtitle="Record received / accepted / rejected / damaged" />
              <GrnForm poId={po.id} lines={lines} />
            </Card>
          )}

          {grns.length > 0 && (
            <Card>
              <CardHeader title="Receipt history" />
              <Table><thead><tr><Th>GRN #</Th><Th>Date</Th></tr></thead>
                <tbody>{grns.map((g, i) => <tr key={i}><Td className="font-mono">{g.grn_number}</Td><Td>{fmtDate(g.received_at)}</Td></tr>)}</tbody></Table>
            </Card>
          )}
        </div>
        <ActivityTimeline entityType="po" entityId={po.id} />
      </div>
    </div>
  );
}
