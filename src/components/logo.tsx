/**
 * Paravalves wordmark — echoes the brand logo (lowercase geometric "paravalves").
 * The "v" carries the signature coral accent, nodding to the site's red "v" mark.
 */
export function Wordmark({ className = '', size = 'md', onDark = false }: { className?: string; size?: 'sm' | 'md' | 'lg'; onDark?: boolean }) {
  const sizeCls = { sm: 'text-base', md: 'text-lg', lg: 'text-3xl' }[size];
  const inkCls = onDark ? 'text-white' : 'text-ink';
  return (
    <span className={`brandmark inline-flex select-none items-baseline font-medium lowercase ${sizeCls} ${inkCls} ${className}`}>
      para<span className="text-brand">v</span>alves
    </span>
  );
}

/** Compact square mark: coral tile with a white "v" — for tight spaces. */
export function LogoMark({ size = 32 }: { size?: number }) {
  return (
    <span
      className="brandmark inline-flex shrink-0 items-center justify-center rounded-lg bg-brand font-semibold lowercase text-brand-ink shadow-sm"
      style={{ width: size, height: size, fontSize: size * 0.52 }}
    >
      v
    </span>
  );
}
