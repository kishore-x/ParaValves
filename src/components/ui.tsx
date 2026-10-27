import Link from 'next/link';
import type { ReactNode } from 'react';
import { Icon } from './icons';

/* ── Card ─────────────────────────────────────────────────────────────── */
export function Card({ children, className = '' }: { children: ReactNode; className?: string }) {
  return <div className={`rounded-xl border border-line bg-surface shadow-sm ${className}`}>{children}</div>;
}
export function CardHeader({ title, subtitle, action }: { title: ReactNode; subtitle?: ReactNode; action?: ReactNode }) {
  return (
    <div className="flex items-center justify-between gap-3 border-b border-line px-5 py-4">
      <div className="min-w-0">
        <h2 className="truncate text-sm font-semibold text-ink">{title}</h2>
        {subtitle && <p className="mt-0.5 text-xs text-muted">{subtitle}</p>}
      </div>
      {action && <div className="shrink-0">{action}</div>}
    </div>
  );
}

/* ── Button ───────────────────────────────────────────────────────────── */
type BtnProps = {
  children: ReactNode;
  href?: string;
  onClick?: () => void;
  type?: 'button' | 'submit';
  variant?: 'primary' | 'ghost' | 'subtle' | 'danger';
  size?: 'sm' | 'md';
  disabled?: boolean;
  icon?: string;
  className?: string;
};
export function Button({ children, href, onClick, type = 'button', variant = 'primary', size = 'md', disabled, icon, className = '' }: BtnProps) {
  const base = 'inline-flex items-center justify-center gap-1.5 rounded-lg font-medium whitespace-nowrap transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[rgb(var(--ring))] focus-visible:ring-offset-1 focus-visible:ring-offset-[rgb(var(--surface))] disabled:opacity-50 disabled:pointer-events-none';
  const sizes = size === 'sm' ? 'h-8 px-3 text-xs' : 'h-9 px-3.5 text-sm';
  const variants = {
    primary: 'bg-brand text-brand-ink shadow-sm hover:bg-brand-strong active:scale-[.98]',
    ghost: 'border border-line bg-surface text-ink hover:bg-bg hover:border-line-strong',
    subtle: 'bg-bg text-muted hover:text-ink hover:bg-line/60',
    danger: 'bg-danger text-white shadow-sm hover:opacity-90 active:scale-[.98]',
  }[variant];
  const cls = `${base} ${sizes} ${variants} ${className}`;
  const inner = <>{icon && <Icon name={icon} size={size === 'sm' ? 15 : 16} />}{children}</>;
  if (href) return <Link href={href} className={cls}>{inner}</Link>;
  return <button type={type} onClick={onClick} disabled={disabled} className={cls}>{inner}</button>;
}

/* ── Status pill ──────────────────────────────────────────────────────── */
const STATUS_TONE: Record<string, 'ok' | 'warn' | 'danger' | 'info' | 'muted' | 'brand'> = {
  NEW: 'info', CONTACTED: 'info', QUALIFIED: 'brand', MEETING: 'brand', QUOTATION: 'warn',
  NEGOTIATION: 'warn', WON: 'ok', LOST: 'danger',
  DRAFT: 'muted', INTERNAL_REVIEW: 'info', APPROVED: 'brand', SENT: 'info', VIEWED: 'info',
  ACCEPTED: 'ok', REJECTED: 'danger', EXPIRED: 'muted',
  CONFIRMED: 'info', ENGINEERING: 'brand', DRAWING_APPROVAL: 'warn', MATERIAL_CHECK: 'warn',
  PROCUREMENT: 'warn', READY: 'ok', EXECUTION: 'brand', QC: 'warn',
  DELIVERY: 'info', INVOICING: 'warn', CLOSED: 'ok', CANCELLED: 'danger',
  OPEN: 'warn', DONE: 'ok', WAITING: 'muted', COVERED: 'ok', TODO: 'muted', DOING: 'brand',
  ISSUED: 'info', PAID: 'ok', PARTIALLY_PAID: 'warn', OVERDUE: 'danger', PENDING_APPROVAL: 'warn',
  ACTIVE: 'brand', PLANNING: 'muted', ON_HOLD: 'warn', VERIFICATION: 'warn',
  RELEASED: 'ok', REVIEW: 'info', INTERNAL_APPROVAL: 'brand', CUSTOMER_APPROVAL: 'warn', SUPERSEDED: 'muted',
  RECEIVED: 'ok', PARTIALLY_RECEIVED: 'warn', SUBMITTED: 'info',
  PASSED: 'ok', PASS: 'ok', FAILED: 'danger', FAIL: 'danger', PENDING: 'warn', QUARANTINE: 'warn', CONSUMED: 'muted',
  PLANNED: 'muted', IN_PROGRESS: 'brand', COMPLETED: 'ok', IN_ASSEMBLY: 'brand', AWAITING_FINAL: 'warn', SHIPPED: 'ok', BLOCKED: 'danger',
  RECONCILED: 'ok', MISMATCH: 'danger', RESOLVED: 'ok', IMPACT_ASSESSED: 'info', IMPLEMENTED: 'ok', CONDITIONAL: 'warn',
  RETRIED: 'info', OK: 'ok', OUT_OF_CALIBRATION: 'danger',
};
const TONE_CLS: Record<string, string> = {
  ok: 'bg-ok-wash text-ok ring-ok/20',
  warn: 'bg-warn-wash text-warn ring-warn/20',
  danger: 'bg-danger-wash text-danger ring-danger/20',
  info: 'bg-info-wash text-info ring-info/20',
  brand: 'bg-brand-wash text-brand ring-brand/20',
  muted: 'bg-bg text-muted ring-line',
};
export function StatusPill({ status }: { status: string }) {
  const tone = STATUS_TONE[status] ?? 'muted';
  return (
    <span className={`inline-flex items-center gap-1 rounded-md px-2 py-0.5 text-2xs font-semibold uppercase tracking-wide ring-1 ring-inset ${TONE_CLS[tone]}`}>
      <span className="h-1.5 w-1.5 rounded-full bg-current opacity-70" />
      {status.replace(/_/g, ' ')}
    </span>
  );
}
export function Badge({ children, tone = 'muted' }: { children: ReactNode; tone?: keyof typeof TONE_CLS }) {
  return <span className={`inline-flex items-center rounded-md px-2 py-0.5 text-2xs font-semibold ring-1 ring-inset ${TONE_CLS[tone]}`}>{children}</span>;
}

/* ── Stat tile ────────────────────────────────────────────────────────── */
export function StatTile({ label, value, hint, tone = 'ink', href, icon }: {
  label: string; value: ReactNode; hint?: string; tone?: 'ink' | 'ok' | 'warn' | 'danger' | 'brand'; href?: string; icon?: string;
}) {
  const toneCls = { ink: 'text-ink', ok: 'text-ok', warn: 'text-warn', danger: 'text-danger', brand: 'text-brand' }[tone];
  const iconTone = { ink: 'text-faint', ok: 'text-ok', warn: 'text-warn', danger: 'text-danger', brand: 'text-brand' }[tone];
  const inner = (
    <div className={`group rounded-xl border border-line bg-surface p-4 shadow-sm ${href ? 'transition-all hover:border-line-strong hover:shadow-md' : ''}`}>
      <div className="flex items-center justify-between">
        <p className="text-xs font-medium text-muted">{label}</p>
        {icon && <Icon name={icon} size={16} className={iconTone} />}
      </div>
      <p className={`mt-2 text-2xl font-semibold tracking-tight tnum ${toneCls}`}>{value}</p>
      {hint && <p className="mt-1 text-xs text-faint">{hint}</p>}
    </div>
  );
  return href ? <Link href={href} className="block">{inner}</Link> : inner;
}

/* ── Table ────────────────────────────────────────────────────────────── */
export function Table({ children }: { children: ReactNode }) {
  return <div className="overflow-x-auto"><table className="w-full border-collapse text-sm">{children}</table></div>;
}
export function Th({ children, className = '' }: { children?: ReactNode; className?: string }) {
  return <th className={`border-b border-line bg-bg/40 px-4 py-2.5 text-left text-2xs font-semibold uppercase tracking-wide text-muted ${className}`}>{children}</th>;
}
export function Td({ children, className = '' }: { children?: ReactNode; className?: string }) {
  return <td className={`border-b border-line px-4 py-3 align-middle text-ink ${className}`}>{children}</td>;
}

/* ── Empty state ──────────────────────────────────────────────────────── */
export function EmptyState({ title, hint, action, icon = 'inbox' }: { title: string; hint?: string; action?: ReactNode; icon?: string }) {
  return (
    <div className="flex flex-col items-center justify-center gap-3 px-6 py-16 text-center">
      <div className="flex h-11 w-11 items-center justify-center rounded-full bg-bg text-faint ring-1 ring-line">
        <Icon name={icon} size={20} />
      </div>
      <div>
        <p className="text-sm font-medium text-ink">{title}</p>
        {hint && <p className="mx-auto mt-1 max-w-xs text-xs text-muted">{hint}</p>}
      </div>
      {action}
    </div>
  );
}

/* ── Page header ──────────────────────────────────────────────────────── */
export function PageHeader({ title, subtitle, action }: { title: string; subtitle?: ReactNode; action?: ReactNode }) {
  return (
    <div className="mb-6 flex flex-wrap items-start justify-between gap-3">
      <div className="min-w-0">
        <h1 className="text-lg font-semibold tracking-tight text-ink">{title}</h1>
        {subtitle && <p className="mt-1 text-sm text-muted">{subtitle}</p>}
      </div>
      {action && <div className="flex shrink-0 items-center gap-2">{action}</div>}
    </div>
  );
}

/* ── Field ────────────────────────────────────────────────────────────── */
export function Field({ label, children, required, hint }: { label: string; children: ReactNode; required?: boolean; hint?: string }) {
  return (
    <label className="block">
      <span className="mb-1.5 block text-xs font-medium text-muted">
        {label}{required && <span className="text-danger"> *</span>}
      </span>
      {children}
      {hint && <span className="mt-1 block text-2xs text-faint">{hint}</span>}
    </label>
  );
}
export const inputCls =
  'h-9 w-full rounded-lg border border-line bg-surface px-3 text-sm text-ink outline-none transition-colors placeholder:text-faint hover:border-line-strong focus:border-brand focus:ring-2 focus:ring-[rgb(var(--ring))] focus:ring-offset-0';

/* ── Avatar ───────────────────────────────────────────────────────────── */
export function Avatar({ name, size = 32 }: { name: string; size?: number }) {
  const initials = name.split(' ').filter(Boolean).slice(0, 2).map((s) => s[0]).join('').toUpperCase();
  return (
    <span
      className="inline-flex shrink-0 items-center justify-center rounded-full bg-brand-wash font-semibold text-brand"
      style={{ width: size, height: size, fontSize: size * 0.4 }}
    >
      {initials}
    </span>
  );
}

/* ── Skeleton primitives ──────────────────────────────────────────────── */
export function Skeleton({ className = '' }: { className?: string }) {
  return <div className={`skeleton ${className}`} />;
}
export function SkeletonTable({ rows = 6, cols = 5 }: { rows?: number; cols?: number }) {
  return (
    <Card>
      <div className="border-b border-line px-5 py-4"><Skeleton className="h-4 w-40" /></div>
      <div className="divide-y divide-line">
        {Array.from({ length: rows }).map((_, r) => (
          <div key={r} className="flex items-center gap-4 px-4 py-3.5">
            {Array.from({ length: cols }).map((_, c) => (
              <Skeleton key={c} className={`h-4 ${c === 0 ? 'w-24' : c === 1 ? 'flex-1' : 'w-20'}`} />
            ))}
          </div>
        ))}
      </div>
    </Card>
  );
}
export function SkeletonStats({ n = 4 }: { n?: number }) {
  return (
    <div className="grid grid-cols-2 gap-3 sm:grid-cols-4">
      {Array.from({ length: n }).map((_, i) => (
        <div key={i} className="rounded-xl border border-line bg-surface p-4 shadow-sm">
          <Skeleton className="h-3 w-16" /><Skeleton className="mt-3 h-7 w-20" />
        </div>
      ))}
    </div>
  );
}
