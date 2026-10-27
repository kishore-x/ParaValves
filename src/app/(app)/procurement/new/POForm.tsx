'use client';
import { useMemo, useState } from 'react';
import { inputCls, Button, Field } from '@/components/ui';
import { newPOAction } from '../actions';

interface Product { id: string; product_code: string; name: string; standard_cost: string }
interface Supplier { id: string; name: string }
interface Line { product_id: string; description: string; quantity: string; unit_price: string; tax_rate: string }
const blank: Line = { product_id: '', description: '', quantity: '1', unit_price: '0', tax_rate: '18' };

export function POForm({ suppliers, products }: { suppliers: Supplier[]; products: Product[] }) {
  const [lines, setLines] = useState<Line[]>([{ ...blank }]);
  const upd = (i: number, patch: Partial<Line>) => setLines((ls) => ls.map((l, idx) => (idx === i ? { ...l, ...patch } : l)));
  const pick = (i: number, pid: string) => {
    const p = products.find((x) => x.id === pid);
    if (p) upd(i, { product_id: pid, description: `${p.product_code} — ${p.name}`, unit_price: p.standard_cost });
    else upd(i, { product_id: '' });
  };
  const total = useMemo(() => lines.reduce((a, l) => {
    const g = Number(l.quantity) * Number(l.unit_price); return a + g * (1 + Number(l.tax_rate) / 100);
  }, 0), [lines]);
  const fmt = (n: number) => `₹${n.toLocaleString('en-IN', { minimumFractionDigits: 2 })}`;

  const payload: Line[] = lines.map((l) => ({ ...l }));
  return (
    <form action={newPOAction} className="space-y-5">
      <input type="hidden" name="lines" value={JSON.stringify(payload.map((l) => ({ product_id: l.product_id || null, description: l.description, quantity: Number(l.quantity), unit_price: Number(l.unit_price), tax_rate: Number(l.tax_rate) })))} />
      <div className="grid gap-4 rounded-xl border border-line bg-surface p-5 sm:grid-cols-3">
        <div className="sm:col-span-2"><Field label="Supplier" required>
          <select name="supplier_id" required className={inputCls}><option value="">Select supplier…</option>{suppliers.map((s) => <option key={s.id} value={s.id}>{s.name}</option>)}</select>
        </Field></div>
        <Field label="Expected date"><input name="expected_date" type="date" className={inputCls} /></Field>
      </div>
      <div className="overflow-x-auto rounded-xl border border-line bg-surface">
        <table className="w-full text-sm">
          <thead><tr className="border-b border-line text-left text-xs uppercase text-muted"><th className="px-3 py-2">Product</th><th className="px-3 py-2">Description</th><th className="px-3 py-2 w-20">Qty</th><th className="px-3 py-2 w-28">Unit cost</th><th className="px-3 py-2 w-20">Tax%</th><th className="w-10"></th></tr></thead>
          <tbody>{lines.map((l, i) => (
            <tr key={i} className="border-b border-line">
              <td className="px-2 py-1.5"><select value={l.product_id} onChange={(e) => pick(i, e.target.value)} className={inputCls}><option value="">— free —</option>{products.map((p) => <option key={p.id} value={p.id}>{p.product_code}</option>)}</select></td>
              <td className="px-2 py-1.5"><input value={l.description} onChange={(e) => upd(i, { description: e.target.value })} className={inputCls} /></td>
              <td className="px-2 py-1.5"><input value={l.quantity} onChange={(e) => upd(i, { quantity: e.target.value })} type="number" step="any" className={inputCls} /></td>
              <td className="px-2 py-1.5"><input value={l.unit_price} onChange={(e) => upd(i, { unit_price: e.target.value })} type="number" step="any" className={inputCls} /></td>
              <td className="px-2 py-1.5"><input value={l.tax_rate} onChange={(e) => upd(i, { tax_rate: e.target.value })} type="number" step="any" className={inputCls} /></td>
              <td className="px-2 py-1.5">{lines.length > 1 && <button type="button" onClick={() => setLines((ls) => ls.filter((_, idx) => idx !== i))} className="text-danger">✕</button>}</td>
            </tr>
          ))}</tbody>
        </table>
        <div className="flex items-center justify-between p-3">
          <Button type="button" variant="ghost" size="sm" onClick={() => setLines((ls) => [...ls, { ...blank }])}>+ Add line</Button>
          <div className="text-base font-semibold">Total (incl. tax): {fmt(total)}</div>
        </div>
      </div>
      <div className="rounded-xl border border-line bg-surface p-5"><Field label="Notes"><textarea name="notes" rows={2} className={inputCls} /></Field></div>
      <div className="flex gap-2"><Button type="submit">Create Purchase Order</Button><Button href="/procurement" variant="ghost">Cancel</Button></div>
    </form>
  );
}
