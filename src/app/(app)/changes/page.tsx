import { requireUser } from '@/server/auth/action';
import { query } from '@/server/db';
import { Card, CardHeader, StatusPill, PageHeader, Field, Button, inputCls, Badge, EmptyState } from '@/components/ui';
import { Flash } from '@/components/flash';
import { fmtDate } from '@/lib/format';
import { newEcnAction, assessEcnAction, submitEcnAction, implementEcnAction } from '../mfg-actions';

export default async function ChangesPage({ searchParams }: { searchParams: Promise<{ error?: string; ok?: string }> }) {
  const sp = await searchParams;
  const user = await requireUser();
  const [rows, products] = await Promise.all([
    query<any>(`select e.*, p.name pname, m.name maker, c.name checker from engineering_changes e left join products p on p.id=e.product_id left join users m on m.id=e.maker_id left join users c on c.id=e.checker_id where e.org_id=$1 order by e.created_at desc`, [user.currentOrgId]),
    query<any>(`select id, product_code, name from products where org_id=$1 order by product_code`, [user.currentOrgId]),
  ]);
  return (
    <div className="space-y-6">
      <PageHeader title="Engineering changes" subtitle="Change after release → impact on orders, purchasing, stock and WIP → maker-checker approval → implement with history" />
      <Flash error={sp.error} ok={sp.ok} />
      {rows.length === 0 && <Card><EmptyState title="No engineering changes" /></Card>}
      {rows.map((e: any) => { const im = e.impact ?? {}; const has = e.status !== 'DRAFT'; return (
        <Card key={e.id}>
          <CardHeader title={`${e.ecn_number} · ${e.title}`} subtitle={`${e.pname ?? '—'} · raised ${fmtDate(e.created_at)} by ${e.maker ?? '—'}${e.checker ? ` · approved by ${e.checker}` : ''}`} action={<StatusPill status={e.status} />} />
          <div className="space-y-3 p-5 text-sm">
            {e.reason && <p className="text-muted">Reason: {e.reason}</p>}
            {has && (
              <div className="grid gap-3 md:grid-cols-4">
                <div className="rounded-lg border border-line p-3"><p className="text-2xs font-semibold uppercase text-muted">Open orders / customer commitments</p>{(im.orders ?? []).map((o: any) => <p key={o.order_number} className="text-xs">{o.order_number} · {o.customer} · due {fmtDate(o.delivery_date)}</p>)}{!(im.orders ?? []).length && <p className="text-xs text-muted">None</p>}</div>
                <div className="rounded-lg border border-line p-3"><p className="text-2xs font-semibold uppercase text-muted">Open purchasing</p>{(im.pos ?? []).map((o: any) => <p key={o.po_number} className="text-xs">{o.po_number} · {o.supplier}</p>)}{!(im.pos ?? []).length && <p className="text-xs text-muted">None</p>}</div>
                <div className="rounded-lg border border-line p-3"><p className="text-2xs font-semibold uppercase text-muted">Stock & lots</p><p className="text-xs">On hand {im.stock?.on_hand ?? 0} · incoming {im.stock?.incoming ?? 0}</p>{(im.stock?.lots ?? []).map((l: any) => <p key={l.lot_number} className="text-xs">{l.lot_number} · {Number(l.qty_available)}</p>)}</div>
                <div className="rounded-lg border border-line p-3"><p className="text-2xs font-semibold uppercase text-muted">WIP</p>{(im.wip ?? []).map((w: any) => <p key={w.wo_number} className="text-xs">{w.wo_number} · {w.status}</p>)}<p className="text-xs">{im.units_in_process ?? 0} unit(s) in process</p></div>
              </div>)}
            {e.disposition && <p><Badge tone="info">Disposition</Badge> {e.disposition} · effectivity: {e.effectivity}</p>}
            <div className="flex flex-wrap gap-2">
              {(e.status === 'DRAFT' || e.status === 'IMPACT_ASSESSED') && <form action={assessEcnAction}><input type="hidden" name="id" value={e.id} /><Button type="submit" size="sm" variant="ghost">{e.status === 'DRAFT' ? 'Assess impact' : 'Re-assess impact'}</Button></form>}
              {e.status === 'IMPACT_ASSESSED' && (
                <form action={submitEcnAction} className="flex flex-wrap items-center gap-2"><input type="hidden" name="id" value={e.id} />
                  <select name="disposition" className={`${inputCls} !h-8 !w-72`}><option>Use existing stock until exhausted, then change</option><option>Rework WIP & stock to new revision</option><option>Scrap affected stock</option><option>Concession for open orders</option></select>
                  <input name="effectivity" required placeholder="Effectivity (e.g. from serial 120)" className={`${inputCls} !h-8 !w-56`} /><Button type="submit" size="sm">Submit for approval</Button></form>)}
              {e.status === 'APPROVED' && <form action={implementEcnAction}><input type="hidden" name="id" value={e.id} /><Button type="submit" size="sm">Implement (raise drawing revision)</Button></form>}
            </div>
          </div>
        </Card>); })}
      <Card>
        <CardHeader title="Raise engineering change" />
        <form action={newEcnAction} className="grid gap-3 p-5 md:grid-cols-4">
          <Field label="Product"><select name="product_id" required className={inputCls}>{products.map((p: any) => <option key={p.id} value={p.id}>{p.product_code} · {p.name}</option>)}</select></Field>
          <Field label="Title"><input name="title" required className={inputCls} /></Field>
          <Field label="Reason"><input name="reason" className={inputCls} /></Field>
          <div className="flex items-end"><Button type="submit">Open ECN</Button></div>
        </form>
      </Card>
    </div>
  );
}
