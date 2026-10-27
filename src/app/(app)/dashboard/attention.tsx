'use client';
import Link from 'next/link';
import { useState } from 'react';
import { Icon } from '@/components/icons';
import { EmptyState } from '@/components/ui';

export type AttentionItem = { id: string; n: string; label: string; owner?: string | null; age?: string };
export type AttentionGroup = { key: string; label: string; icon: string; base: string; items: AttentionItem[] };

export function AttentionPanel({ groups }: { groups: AttentionGroup[] }) {
  const total = groups.reduce((a, g) => a + g.items.length, 0);
  const [tab, setTab] = useState('all');
  const visible = tab === 'all' ? groups.filter((g) => g.items.length) : groups.filter((g) => g.key === tab);

  const tabs = [{ key: 'all', label: 'All', count: total }, ...groups.map((g) => ({ key: g.key, label: g.label, count: g.items.length }))];

  return (
    <div className="rounded-xl border border-line bg-surface shadow-sm">
      <div className="flex items-center justify-between gap-3 px-5 pt-5">
        <h2 className="flex items-center gap-2 text-lg font-semibold tracking-tight text-ink">
          Attention Required
          {total > 0 && <span className="inline-flex h-5 min-w-5 items-center justify-center rounded-full bg-brand px-1.5 text-2xs font-bold text-brand-ink">{total}</span>}
        </h2>
        <Link href="/tasks" className="inline-flex items-center gap-1 text-xs font-medium text-muted hover:text-ink">View all <Icon name="arrowRight" size={13} /></Link>
      </div>

      <div className="mt-3 flex gap-5 border-b border-line px-5">
        {tabs.map((t) => (
          <button
            key={t.key}
            onClick={() => setTab(t.key)}
            className={`relative -mb-px flex items-center gap-1.5 pb-2.5 text-sm font-medium transition-colors ${tab === t.key ? 'text-ink' : 'text-faint hover:text-muted'}`}
          >
            {t.label}
            {t.count > 0 && <span className={`inline-flex h-4 min-w-4 items-center justify-center rounded px-1 text-2xs font-semibold ${tab === t.key ? 'bg-brand-wash text-brand' : 'bg-bg text-faint'}`}>{t.count}</span>}
            {tab === t.key && <span className="absolute inset-x-0 -bottom-px h-0.5 rounded-full bg-brand" />}
          </button>
        ))}
      </div>

      {total === 0 ? (
        <EmptyState icon="check" title="You're all caught up" hint="Nothing needs your attention right now." />
      ) : (
        <div>
          {visible.map((g) => (
            <div key={g.key}>
              <p className="flex items-center gap-2 bg-bg/50 px-5 py-2 text-2xs font-semibold uppercase tracking-wide text-muted">
                <Icon name={g.icon} size={13} className="text-faint" />{g.label}
                <span className="rounded bg-surface px-1.5 py-0.5 text-2xs text-muted ring-1 ring-inset ring-line">{g.items.length}</span>
              </p>
              <ul>
                {g.items.map((it) => (
                  <li key={it.id}>
                    <Link href={g.base + it.id} className="group flex items-center gap-3 border-b border-line px-5 py-2.5 last:border-0 hover:bg-bg">
                      <span className="h-4 w-4 shrink-0 rounded border border-line-strong" />
                      <span className="font-mono text-xs font-semibold text-brand">{it.n}</span>
                      {it.label && <span className="truncate text-sm text-ink">{it.label}</span>}
                      <span className="ml-auto hidden shrink-0 text-xs text-muted sm:inline">{it.owner ?? ''}</span>
                      {it.age && <span className="shrink-0 text-xs text-faint">{it.age}</span>}
                      <Icon name="arrowRight" size={14} className="shrink-0 text-faint opacity-0 transition-opacity group-hover:opacity-100" />
                    </Link>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
