'use client';
import { useState } from 'react';
import { inputCls, Button } from '@/components/ui';
import { receiveGoodsAction } from '../actions';

interface Line { id: string; product_id: string; description: string; quantity: number; received_qty: number }
interface Row { po_line_id: string; product_id: string; received: string; accepted: string; rejected: string; damaged: string; batch: string }

export function GrnForm({ poId, lines }: { poId: string; lines: Line[] }) {
  const pending = lines.filter((l) => l.product_id && Number(l.received_qty) < Number(l.quantity));
  const [rows, setRows] = useState<Row[]>(
    pending.map((l) => {
      const rem = Number(l.quantity) - Number(l.received_qty);
      return { po_line_id: l.id, product_id: l.product_id, received: String(rem), accepted: String(rem), rejected: '0', damaged: '0', batch: '' };
    }),
  );
  if (!pending.length) return <p className="p-5 text-sm text-muted">All lines fully received.</p>;
  const upd = (i: number, patch: Partial<Row>) => setRows((rs) => rs.map((r, idx) => (idx === i ? { ...r, ...patch } : r)));
  const payload = rows.map((r) => ({ po_line_id: r.po_line_id, product_id: r.product_id, received: Number(r.received), accepted: Number(r.accepted), rejected: Number(r.rejected), damaged: Number(r.damaged), batch: r.batch || undefined }));

  return (
    <form action={receiveGoodsAction}>
      <input type="hidden" name="id" value={poId} />
      <input type="hidden" name="receipts" value={JSON.stringify(payload)} />
      <div className="overflow-x-auto">
        <table className="w-full text-sm">
          <thead><tr className="border-b border-line text-left text-xs uppercase text-muted"><th className="px-3 py-2">Line</th><th className="px-2 py-2 w-24">Received</th><th className="px-2 py-2 w-24">Accepted</th><th className="px-2 py-2 w-24">Rejected</th><th className="px-2 py-2 w-24">Damaged</th><th className="px-2 py-2 w-28">Batch</th></tr></thead>
          <tbody>{pending.map((l, i) => (
            <tr key={l.id} className="border-b border-line">
              <td className="px-3 py-1.5">{l.description}</td>
              <td className="px-2 py-1.5"><input value={rows[i]?.received} onChange={(e) => upd(i, { received: e.target.value })} type="number" step="any" className={inputCls} /></td>
              <td className="px-2 py-1.5"><input value={rows[i]?.accepted} onChange={(e) => upd(i, { accepted: e.target.value })} type="number" step="any" className={inputCls} /></td>
              <td className="px-2 py-1.5"><input value={rows[i]?.rejected} onChange={(e) => upd(i, { rejected: e.target.value })} type="number" step="any" className={inputCls} /></td>
              <td className="px-2 py-1.5"><input value={rows[i]?.damaged} onChange={(e) => upd(i, { damaged: e.target.value })} type="number" step="any" className={inputCls} /></td>
              <td className="px-2 py-1.5"><input value={rows[i]?.batch} onChange={(e) => upd(i, { batch: e.target.value })} className={inputCls} /></td>
            </tr>
          ))}</tbody>
        </table>
      </div>
      <div className="p-4"><Button type="submit">Receive Goods</Button> <span className="ml-2 text-xs text-muted">Only accepted quantities increase available stock.</span></div>
    </form>
  );
}
