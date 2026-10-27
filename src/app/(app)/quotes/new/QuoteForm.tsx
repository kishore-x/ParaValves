'use client';
import { useMemo, useState } from 'react';
import { inputCls, Button, Field } from '@/components/ui';
import { newQuoteAction } from '../actions';

interface Product { id: string; product_code: string; name: string; selling_price: string; tax_rate: string }
interface Company { id: string; name: string; company_number: string }
interface Line { product_id: string; description: string; quantity: string; unit_price: string; discount_pct: string; tax_rate: string }

const blank: Line = { product_id: '', description: '', quantity: '1', unit_price: '0', discount_pct: '0', tax_rate: '18' };

export function QuoteForm({ companies, products }: { companies: Company[]; products: Product[] }) {
  const [lines, setLines] = useState<Line[]>([{ ...blank }]);

  function update(i: number, patch: Partial<Line>) {
    setLines((ls) => ls.map((l, idx) => (idx === i ? { ...l, ...patch } : l)));
  }
  function pickProduct(i: number, productId: string) {
    const p = products.find((x) => x.id === productId);
    if (p) update(i, { product_id: productId, description: `${p.product_code} — ${p.name}`, unit_price: p.selling_price, tax_rate: p.tax_rate });
    else update(i, { product_id: '' });
  }

  const totals = useMemo(() => {
    let sub = 0, disc = 0, tax = 0;
    for (const l of lines) {
      const gross = Number(l.quantity) * Number(l.unit_price);
      const d = (gross * Number(l.discount_pct)) / 100;
      const taxable = gross - d;
      const t = (taxable * Number(l.tax_rate)) / 100;
      sub += gross; disc += d; tax += t;
    }
    return { sub, disc, tax, grand: sub - disc + tax };
  }, [lines]);

  const fmt = (n: number) => `₹${n.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;

  return (
    <form action={newQuoteAction} className="space-y-5">
      <input type="hidden" name="lines" value={JSON.stringify(lines)} />
      <div className="grid gap-4 rounded-xl border border-line bg-surface p-5 sm:grid-cols-3">
        <div className="sm:col-span-2"><Field label="Customer" required>
          <select name="company_id" required className={inputCls}>
            <option value="">Select customer…</option>
            {companies.map((c) => <option key={c.id} value={c.id}>{c.name} ({c.company_number})</option>)}
          </select>
        </Field></div>
        <Field label="Currency"><select name="currency" className={inputCls}><option>INR</option><option>EUR</option><option>USD</option></select></Field>
        <Field label="Payment terms"><select name="payment_terms" className={inputCls}><option>NET30</option><option>NET15</option><option>ADVANCE</option></select></Field>
        <Field label="Valid until"><input name="valid_until" type="date" className={inputCls} /></Field>
        <Field label="Delivery terms"><input name="delivery_terms" placeholder="e.g. Ex-works" className={inputCls} /></Field>
      </div>

      <div className="overflow-x-auto rounded-xl border border-line bg-surface">
        <table className="w-full text-sm">
          <thead><tr className="border-b border-line text-left text-xs uppercase text-muted">
            <th className="px-3 py-2">Product</th><th className="px-3 py-2">Description</th>
            <th className="px-3 py-2 w-20">Qty</th><th className="px-3 py-2 w-28">Unit price</th>
            <th className="px-3 py-2 w-20">Disc %</th><th className="px-3 py-2 w-20">Tax %</th>
            <th className="px-3 py-2 w-28 text-right">Total</th><th className="w-10"></th>
          </tr></thead>
          <tbody>
            {lines.map((l, i) => {
              const gross = Number(l.quantity) * Number(l.unit_price);
              const total = (gross - (gross * Number(l.discount_pct)) / 100) * (1 + Number(l.tax_rate) / 100);
              return (
                <tr key={i} className="border-b border-line">
                  <td className="px-2 py-1.5"><select value={l.product_id} onChange={(e) => pickProduct(i, e.target.value)} className={inputCls}><option value="">— free text —</option>{products.map((p) => <option key={p.id} value={p.id}>{p.product_code}</option>)}</select></td>
                  <td className="px-2 py-1.5"><input value={l.description} onChange={(e) => update(i, { description: e.target.value })} className={inputCls} placeholder="Description" /></td>
                  <td className="px-2 py-1.5"><input value={l.quantity} onChange={(e) => update(i, { quantity: e.target.value })} type="number" step="any" className={inputCls} /></td>
                  <td className="px-2 py-1.5"><input value={l.unit_price} onChange={(e) => update(i, { unit_price: e.target.value })} type="number" step="any" className={inputCls} /></td>
                  <td className="px-2 py-1.5"><input value={l.discount_pct} onChange={(e) => update(i, { discount_pct: e.target.value })} type="number" step="any" className={inputCls} /></td>
                  <td className="px-2 py-1.5"><input value={l.tax_rate} onChange={(e) => update(i, { tax_rate: e.target.value })} type="number" step="any" className={inputCls} /></td>
                  <td className="px-3 py-1.5 text-right font-medium">{fmt(total || 0)}</td>
                  <td className="px-2 py-1.5">{lines.length > 1 && <button type="button" onClick={() => setLines((ls) => ls.filter((_, idx) => idx !== i))} className="text-danger">✕</button>}</td>
                </tr>
              );
            })}
          </tbody>
        </table>
        <div className="flex items-center justify-between p-3">
          <Button type="button" variant="ghost" size="sm" onClick={() => setLines((ls) => [...ls, { ...blank }])}>+ Add line</Button>
          <div className="w-64 space-y-1 text-sm">
            <Row label="Subtotal" value={fmt(totals.sub)} />
            <Row label="Discount" value={`− ${fmt(totals.disc)}`} />
            <Row label="Tax" value={fmt(totals.tax)} />
            <div className="mt-1 flex justify-between border-t border-line pt-1 text-base font-semibold"><span>Grand total</span><span>{fmt(totals.grand)}</span></div>
          </div>
        </div>
      </div>

      <div className="rounded-xl border border-line bg-surface p-5">
        <Field label="Notes"><textarea name="notes" rows={2} className={inputCls} /></Field>
      </div>
      <div className="flex gap-2"><Button type="submit">Create Quotation</Button><Button href="/quotes" variant="ghost">Cancel</Button></div>
    </form>
  );
}
function Row({ label, value }: { label: string; value: string }) {
  return <div className="flex justify-between text-muted"><span>{label}</span><span className="text-ink">{value}</span></div>;
}
