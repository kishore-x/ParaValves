import { format, formatDistanceToNow } from 'date-fns';

export function fmtDate(d: Date | string | null | undefined): string {
  if (!d) return '—';
  return format(new Date(d), 'dd MMM yyyy');
}
export function fmtDateTime(d: Date | string | null | undefined): string {
  if (!d) return '—';
  return format(new Date(d), 'dd MMM yyyy, HH:mm');
}
export function fromNow(d: Date | string | null | undefined): string {
  if (!d) return '—';
  return formatDistanceToNow(new Date(d), { addSuffix: true });
}
export function num(v: unknown): string {
  const n = Number(v ?? 0);
  return n.toLocaleString('en-IN', { maximumFractionDigits: 3 });
}
