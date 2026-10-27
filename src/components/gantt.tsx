import { StatusPill } from './ui';

export interface GanttTask { name: string; start: Date; end: Date; progress: number; done: boolean; gate?: boolean; }

/** Simple, dependency-free Gantt: a time axis with a bar + progress fill per task. */
export function Gantt({ tasks }: { tasks: GanttTask[] }) {
  if (!tasks.length) return <p className="p-5 text-sm text-muted">No scheduled phases.</p>;
  const min = new Date(Math.min(...tasks.map((t) => t.start.getTime())));
  const max = new Date(Math.max(...tasks.map((t) => t.end.getTime())));
  const span = Math.max(1, max.getTime() - min.getTime());
  const pct = (d: Date) => ((d.getTime() - min.getTime()) / span) * 100;
  const now = Date.now();
  const nowPct = now >= min.getTime() && now <= max.getTime() ? ((now - min.getTime()) / span) * 100 : null;

  // month ticks
  const ticks: { label: string; left: number }[] = [];
  const cur = new Date(min.getFullYear(), min.getMonth(), 1);
  while (cur <= max) {
    ticks.push({ label: cur.toLocaleDateString('en-GB', { month: 'short' }), left: pct(cur) });
    cur.setMonth(cur.getMonth() + 1);
  }

  return (
    <div className="overflow-x-auto p-5">
      <div className="min-w-[560px]">
        {/* axis */}
        <div className="relative mb-2 ml-40 h-4 border-b border-line">
          {ticks.map((t, i) => (
            <span key={i} className="absolute -top-0 text-2xs text-faint" style={{ left: `${Math.max(0, Math.min(96, t.left))}%` }}>{t.label}</span>
          ))}
        </div>
        <div className="space-y-2">
          {tasks.map((t, i) => {
            const left = Math.max(0, pct(t.start));
            const width = Math.max(2, pct(t.end) - left);
            return (
              <div key={i} className="flex items-center gap-3">
                <div className="flex w-40 shrink-0 items-center gap-1.5 truncate text-sm">
                  <span className="truncate text-ink">{t.name}</span>
                  {t.gate && <span className="text-2xs text-warn" title="Mandatory for closure">◆</span>}
                </div>
                <div className="relative h-6 flex-1 rounded bg-bg">
                  {nowPct !== null && <div className="absolute inset-y-0 z-10 w-px bg-danger/60" style={{ left: `${nowPct}%` }} title="Today" />}
                  <div className={`absolute inset-y-0.5 overflow-hidden rounded ${t.done ? 'bg-ok/25' : 'bg-brand/20'}`} style={{ left: `${left}%`, width: `${width}%` }}>
                    <div className={`h-full ${t.done ? 'bg-ok' : 'bg-brand'}`} style={{ width: `${t.progress}%` }} />
                    <span className="absolute inset-0 flex items-center justify-end pr-1.5 text-2xs font-medium text-ink/70">{t.progress}%</span>
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}
