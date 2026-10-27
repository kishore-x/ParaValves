import { requireUser } from '@/server/auth/action';
import { query } from '@/server/db';
import { Card, CardHeader, Table, Th, Td, StatusPill, PageHeader, Field, Button, inputCls } from '@/components/ui';
import { Flash } from '@/components/flash';
import { fmtDate } from '@/lib/format';
import { formatMoney } from '@/lib/money';
import { newSubcontractAction, updateSubcontractAction } from '../mfg-actions';

export default async function SubcontractPage({ searchParams }: { searchParams: Promise<{ error?: string; ok?: string }> }) {
  const sp = await searchParams;
  const user = await requireUser();
  const org = user.currentOrgId;
  const [rows, suppliers, wos, products] = await Promise.all([
    query<any>(`select s.*, c.name supplier, w.wo_number, p.name pname from subcontract_orders s join companies c on c.id=s.supplier_id left join work_orders w on w.id=s.work_order_id left join products p on p.id=s.product_id where s.org_id=$1 order by case s.status when 'MISMATCH' then 0 when 'SENT' then 1 when 'PARTIAL' then 2 else 3 end, s.sent_at desc`, [org]),
    query<any>(`select id, name from companies where org_id=$1 and is_supplier and approval_status<>'BLOCKED' order by name`, [org]),
    query<any>(`select id, wo_number from work_orders where org_id=$1 and status<>'COMPLETED' order by wo_number`, [org]),
    query<any>(`select id, name from products where org_id=$1 order by name limit 100`, [org]),
  ]);
  const atSupplier = rows.reduce((a: number, r: any) => a + Math.max(0, Number(r.qty_sent) - Number(r.qty_returned) - Number(r.qty_scrapped)), 0);
  return (
    <div className="space-y-6">
      <PageHeader title="Subcontract" subtitle={`Supplier-held stock reconciliation — ${atSupplier} unit(s) currently at suppliers`} />
      <Flash error={sp.error} ok={sp.ok} />
      <Card>
        <CardHeader title="Reconciliation" subtitle="sent = returned + scrapped + still at supplier; processed must not exceed returned" />
        <Table><thead><tr><Th>SC</Th><Th>Supplier / process</Th><Th>WO</Th><Th>Sent</Th><Th>Returned</Th><Th>Processed</Th><Th>Scrapped</Th><Th>At supplier</Th><Th>Status</Th><Th>Post receipt</Th></tr></thead>
          <tbody>{rows.map((r: any) => { const out = Number(r.qty_sent) - Number(r.qty_returned) - Number(r.qty_scrapped); return (
            <tr key={r.id} className="align-top"><Td className="font-medium">{r.sc_number}<div className="text-2xs text-faint">due {fmtDate(r.due_date)}</div></Td><Td>{r.supplier}<div className="text-xs text-muted">{r.process}</div></Td><Td>{r.wo_number ?? '—'}</Td>
              <Td>{Number(r.qty_sent)}</Td><Td>{Number(r.qty_returned)}</Td><Td>{Number(r.qty_processed)}</Td><Td>{Number(r.qty_scrapped)}</Td>
              <Td className={out < 0 ? 'font-semibold text-danger' : ''}>{out}</Td><Td><StatusPill status={r.status} /></Td>
              <Td>{r.status !== 'RECONCILED' && (
                <form action={updateSubcontractAction} className="flex flex-wrap items-center gap-1"><input type="hidden" name="id" value={r.id} />
                  <input name="returned" type="number" placeholder="ret" className={`${inputCls} !h-8 !w-14`} /><input name="processed" type="number" placeholder="proc" className={`${inputCls} !h-8 !w-14`} /><input name="scrapped" type="number" placeholder="scrap" className={`${inputCls} !h-8 !w-14`} /><Button type="submit" size="sm">Post</Button></form>)}
                {r.note && <div className="mt-1 text-2xs text-muted">{r.note}</div>}</Td></tr>); })}</tbody></Table>
      </Card>
      <Card>
        <CardHeader title="Send material to a subcontractor" subtitle="Blocked suppliers are excluded" />
        <form action={newSubcontractAction} className="grid gap-3 p-5 md:grid-cols-4">
          <Field label="Supplier"><select name="supplier_id" required className={inputCls}>{suppliers.map((s: any) => <option key={s.id} value={s.id}>{s.name}</option>)}</select></Field>
          <Field label="Process"><input name="process" required defaultValue="Heat treatment" className={inputCls} /></Field>
          <Field label="Work order"><select name="work_order_id" className={inputCls}><option value="">—</option>{wos.map((w: any) => <option key={w.id} value={w.id}>{w.wo_number}</option>)}</select></Field>
          <Field label="Item"><select name="product_id" className={inputCls}><option value="">—</option>{products.map((p: any) => <option key={p.id} value={p.id}>{p.name}</option>)}</select></Field>
          <Field label="Qty sent"><input name="qty_sent" type="number" min="1" required className={inputCls} /></Field>
          <Field label="Job cost (₹)"><input name="cost" type="number" className={inputCls} /></Field>
          <Field label="Due back"><input name="due_date" type="date" className={inputCls} /></Field>
          <div className="flex items-end"><Button type="submit">Send</Button></div>
        </form>
      </Card>
    </div>
  );
}
