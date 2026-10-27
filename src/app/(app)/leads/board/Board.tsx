'use client';
import Link from 'next/link';
import { useState } from 'react';
import { StatusPill } from '@/components/ui';
import { moveLeadAction } from './actions';

export interface BoardLead { id: string; lead_number: string; company_name: string; status: string; owner: string | null; expected_value: string | null; priority: string; }
const STAGES = ['NEW', 'CONTACTED', 'QUALIFIED', 'MEETING', 'QUOTATION', 'NEGOTIATION', 'WON', 'LOST'];
// valid forward/side transitions mirror the server machine (server still enforces)
const ALLOWED: Record<string, string[]> = {
  NEW: ['CONTACTED', 'QUALIFIED', 'LOST'], CONTACTED: ['QUALIFIED', 'LOST'],
  QUALIFIED: ['MEETING', 'QUOTATION', 'LOST'], MEETING: ['QUOTATION', 'NEGOTIATION', 'LOST'],
  QUOTATION: ['NEGOTIATION', 'WON', 'LOST'], NEGOTIATION: ['WON', 'LOST'], WON: [], LOST: [],
};
const money = (v: string | null) => v ? '₹' + Number(v).toLocaleString('en-IN') : '';

export function Board({ initial }: { initial: BoardLead[] }) {
  const [leads, setLeads] = useState(initial);
  const [drag, setDrag] = useState<BoardLead | null>(null);
  const [over, setOver] = useState<string | null>(null);
  const [toast, setToast] = useState<string | null>(null);

  async function drop(stage: string) {
    setOver(null);
    const lead = drag; setDrag(null);
    if (!lead || lead.status === stage) return;
    if (!ALLOWED[lead.status]?.includes(stage)) { flash(`Can't move ${lead.lead_number} from ${lead.status} to ${stage}`); return; }
    const prev = leads;
    setLeads((ls) => ls.map((l) => (l.id === lead.id ? { ...l, status: stage } : l))); // optimistic
    const res = await moveLeadAction(lead.id, stage);
    if (!res.ok) { setLeads(prev); flash(res.error ?? 'Move failed'); }
  }
  function flash(msg: string) { setToast(msg); setTimeout(() => setToast(null), 3500); }

  return (
    <div className="relative">
      {toast && <div className="fixed bottom-6 left-1/2 z-50 -translate-x-1/2 rounded-lg bg-danger px-4 py-2 text-sm font-medium text-white shadow-lg">{toast}</div>}
      <div className="flex gap-3 overflow-x-auto pb-4">
        {STAGES.map((stage) => {
          const items = leads.filter((l) => l.status === stage);
          return (
            <div key={stage}
              onDragOver={(e) => { e.preventDefault(); setOver(stage); }}
              onDragLeave={() => setOver((o) => (o === stage ? null : o))}
              onDrop={() => drop(stage)}
              className={`flex w-64 shrink-0 flex-col rounded-xl border bg-bg/50 ${over === stage ? 'border-brand ring-2 ring-[rgb(var(--ring))]' : 'border-line'}`}>
              <div className="flex items-center justify-between px-3 py-2.5">
                <div className="flex items-center gap-2"><StatusPill status={stage} /><span className="text-xs text-faint">{items.length}</span></div>
              </div>
              <div className="flex min-h-[120px] flex-1 flex-col gap-2 p-2">
                {items.map((l) => (
                  <div key={l.id} draggable onDragStart={() => setDrag(l)} onDragEnd={() => { setDrag(null); setOver(null); }}
                    className="cursor-grab rounded-lg border border-line bg-surface p-3 shadow-sm transition-shadow hover:shadow-md active:cursor-grabbing">
                    <Link href={`/leads/${l.id}`} className="text-sm font-medium text-ink hover:text-brand">{l.company_name}</Link>
                    <p className="mt-0.5 font-mono text-2xs text-faint">{l.lead_number}</p>
                    <div className="mt-2 flex items-center justify-between text-2xs">
                      <span className="text-muted">{l.owner ?? 'Unassigned'}</span>
                      {l.expected_value && <span className="font-medium text-ink">{money(l.expected_value)}</span>}
                    </div>
                  </div>
                ))}
                {items.length === 0 && <p className="px-2 py-6 text-center text-2xs text-faint">Drop here</p>}
              </div>
            </div>
          );
        })}
      </div>
      <p className="mt-2 text-xs text-faint">Drag a card between columns to change its stage. Invalid moves are rejected by the workflow engine.</p>
    </div>
  );
}
