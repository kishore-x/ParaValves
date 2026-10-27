'use client';
import { useEffect, useState } from 'react';
import { Icon } from './icons';

export type Theme = 'light' | 'dark' | 'system';
const KEY = 'pv-theme';

function apply(theme: Theme) {
  const root = document.documentElement;
  if (theme === 'system') root.removeAttribute('data-theme');
  else root.setAttribute('data-theme', theme);
}

function read(): Theme {
  try {
    const v = localStorage.getItem(KEY) as Theme | null;
    return v === 'dark' || v === 'light' || v === 'system' ? v : 'light';
  } catch { return 'light'; }
}

export function setTheme(theme: Theme) {
  try { localStorage.setItem(KEY, theme); } catch {}
  apply(theme);
  window.dispatchEvent(new CustomEvent('pv-theme-change', { detail: theme }));
}

/** Small icon toggle for the topbar — flips light ⇄ dark. */
export function ThemeToggle() {
  const [theme, setLocal] = useState<Theme>('light');
  useEffect(() => {
    setLocal(read());
    const h = (e: Event) => setLocal((e as CustomEvent).detail as Theme);
    window.addEventListener('pv-theme-change', h);
    return () => window.removeEventListener('pv-theme-change', h);
  }, []);
  const isDark = theme === 'dark' || (theme === 'system' && typeof window !== 'undefined' && window.matchMedia?.('(prefers-color-scheme: dark)').matches);
  return (
    <button
      onClick={() => setTheme(isDark ? 'light' : 'dark')}
      className="rounded-lg p-2 text-muted transition-colors hover:bg-bg hover:text-ink"
      aria-label="Toggle theme"
      title={isDark ? 'Switch to light' : 'Switch to dark'}
    >
      <Icon name={isDark ? 'sun' : 'moon'} size={18} />
    </button>
  );
}

/** Full 3-way selector for the Settings page. */
export function ThemeSelector() {
  const [theme, setLocal] = useState<Theme>('light');
  useEffect(() => {
    setLocal(read());
    const h = (e: Event) => setLocal((e as CustomEvent).detail as Theme);
    window.addEventListener('pv-theme-change', h);
    return () => window.removeEventListener('pv-theme-change', h);
  }, []);
  const opts: { value: Theme; label: string; icon: string; desc: string }[] = [
    { value: 'light', label: 'Light', icon: 'sun', desc: 'White background' },
    { value: 'dark', label: 'Dark', icon: 'moon', desc: 'Charcoal background' },
    { value: 'system', label: 'System', icon: 'monitor', desc: 'Match your device' },
  ];
  return (
    <div className="grid gap-3 sm:grid-cols-3">
      {opts.map((o) => {
        const active = theme === o.value;
        return (
          <button
            key={o.value}
            onClick={() => setTheme(o.value)}
            className={`group flex flex-col items-start gap-3 rounded-xl border p-4 text-left transition-all ${
              active ? 'border-brand ring-2 ring-[rgb(var(--ring))]' : 'border-line hover:border-line-strong'
            }`}
          >
            {/* mini preview */}
            <div className={`flex h-16 w-full items-center gap-1.5 overflow-hidden rounded-lg border ${o.value === 'dark' ? 'border-[#2d3035] bg-[#141517]' : o.value === 'light' ? 'border-[#e2dfdc] bg-[#f2f0ef]' : 'border-line bg-gradient-to-r from-[#f2f0ef] to-[#141517]'} p-2`}>
              <div className="h-full w-6 rounded bg-brand/80" />
              <div className="flex-1 space-y-1.5">
                <div className={`h-1.5 w-3/4 rounded ${o.value === 'dark' ? 'bg-white/30' : o.value === 'light' ? 'bg-black/20' : 'bg-black/20'}`} />
                <div className={`h-1.5 w-1/2 rounded ${o.value === 'dark' ? 'bg-white/20' : 'bg-black/10'}`} />
              </div>
            </div>
            <div className="flex items-center gap-2">
              <Icon name={o.icon} size={16} className={active ? 'text-brand' : 'text-muted'} />
              <span className={`text-sm font-medium ${active ? 'text-brand' : 'text-ink'}`}>{o.label}</span>
              {active && <Icon name="check" size={14} className="text-brand" />}
            </div>
            <span className="text-xs text-muted">{o.desc}</span>
          </button>
        );
      })}
    </div>
  );
}
