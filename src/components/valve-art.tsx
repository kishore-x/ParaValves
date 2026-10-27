/**
 * Industrial flanged ball-valve illustration (monochrome line art) for the
 * dashboard hero. Self-contained SVG — no external image asset to ship.
 */
export function ValveArt({ className = '' }: { className?: string }) {
  const s = { stroke: 'currentColor', strokeWidth: 2, fill: 'none', strokeLinejoin: 'round' as const, strokeLinecap: 'round' as const };
  return (
    <svg viewBox="0 0 260 200" className={className} aria-hidden fill="none">
      {/* body */}
      <circle cx="130" cy="100" r="46" {...s} />
      <circle cx="130" cy="100" r="30" {...s} opacity="0.5" />
      {/* bore / flow path */}
      <path d="M100 100h60" {...s} opacity="0.7" />
      {/* left flange + pipe */}
      <path d="M84 78h-30M84 122h-30" {...s} />
      <rect x="30" y="74" width="12" height="52" rx="2" {...s} />
      <path d="M42 86h12M42 100h12M42 114h12" {...s} opacity="0.45" />
      {/* right flange + pipe */}
      <path d="M176 78h30M176 122h30" {...s} />
      <rect x="218" y="74" width="12" height="52" rx="2" {...s} />
      <path d="M206 86h12M206 100h12M206 114h12" {...s} opacity="0.45" />
      {/* stem + handle */}
      <path d="M130 54V30" {...s} />
      <rect x="92" y="18" width="76" height="12" rx="6" {...s} />
      <circle cx="130" cy="24" r="4" fill="currentColor" stroke="none" />
      {/* bolts around body */}
      {[0, 60, 120, 180, 240, 300].map((a) => {
        const r = (a * Math.PI) / 180;
        return <circle key={a} cx={130 + 46 * Math.cos(r)} cy={100 + 46 * Math.sin(r)} r="3.4" fill="currentColor" stroke="none" opacity="0.8" />;
      })}
    </svg>
  );
}
