/**
 * Paravalves brand mark + wordmark.
 * The mark is a geometric coral tile with a white flow glyph (two interlocking
 * angular plates — a nod to a valve seat). The wordmark is Title-case
 * "ParaValves" with the signature coral "V".
 */
export function LogoMark({ size = 32 }: { size?: number }) {
  // Folded-plane coral mark: faceted "V" formed by angled surfaces.
  return (
    <svg width={size} height={size} viewBox="0 0 40 40" fill="none" aria-hidden className="shrink-0">
      <path d="M4 6 20 2l16 4-16 32z" fill="rgb(var(--brand))" />
      <path d="M20 2 4 6l16 32z" fill="rgb(var(--brand-strong))" />
      <path d="M20 2v36l8-16z" fill="rgb(var(--brand))" opacity="0.72" />
      <path d="M20 12 11 8l9 30 9-30z" fill="rgb(var(--bg))" opacity="0.18" />
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
