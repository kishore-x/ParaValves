/**
 * Paravalves brand mark + wordmark.
 * The mark is a geometric coral tile with a white flow glyph (two interlocking
 * angular plates — a nod to a valve seat). The wordmark is Title-case
 * "ParaValves" with the signature coral "V".
 */
export function LogoMark({ size = 32 }: { size?: number }) {
  return (
    <svg width={size} height={size} viewBox="0 0 40 40" fill="none" aria-hidden className="shrink-0">
      <defs>
        <linearGradient id="pv-mark" x1="0" y1="0" x2="40" y2="40" gradientUnits="userSpaceOnUse">
          <stop stopColor="rgb(var(--brand))" />
          <stop offset="1" stopColor="rgb(var(--brand-strong))" />
        </linearGradient>
      </defs>
      <rect width="40" height="40" rx="10" fill="url(#pv-mark)" />
      {/* angular flow glyph */}
      <path d="M11 11h9.5a7 7 0 0 1 0 14H16" stroke="rgb(var(--brand-ink))" strokeWidth="3.4" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      <path d="M11 11v18" stroke="rgb(var(--brand-ink))" strokeWidth="3.4" strokeLinecap="round" />
      <circle cx="27" cy="18" r="1.9" fill="rgb(var(--brand-ink))" opacity="0.85" />
    </svg>
  );
}

export function Wordmark({ className = '', size = 'md', onDark = false }: { className?: string; size?: 'sm' | 'md' | 'lg'; onDark?: boolean }) {
  const sizeCls = { sm: 'text-base', md: 'text-lg', lg: 'text-3xl' }[size];
  const inkCls = onDark ? 'text-white' : 'text-ink';
  return (
    <span className={`brandmark inline-flex select-none items-baseline font-semibold tracking-tight ${sizeCls} ${inkCls} ${className}`}>
      Para<span className="text-brand">V</span>alves
    </span>
  );
}
