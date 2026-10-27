/**
 * Self-contained "industrial photo" tiles rendered as layered SVG (no external
 * image assets). Each variant evokes a dark, lit scene — a valve, a blueprint, a
 * warehouse, a refinery — for the hero, list thumbnails and action cards.
 */
type Variant = 'valve-red' | 'valve-teal' | 'blueprint' | 'warehouse' | 'refinery';

export function IndustrialTile({ variant, className = '', rounded = true }: { variant: Variant; className?: string; rounded?: boolean }) {
  // Deterministic id (same on server + client) — avoids hydration mismatch.
  // Identical variants share identical gradient defs, so a shared id is safe.
  const id = variant;
  return (
    <svg viewBox="0 0 400 300" preserveAspectRatio="xMidYMid slice" className={`${className} ${rounded ? 'rounded-xl' : ''}`} aria-hidden>
      <defs>
        <linearGradient id={`bg-${id}`} x1="0" y1="0" x2="400" y2="300" gradientUnits="userSpaceOnUse">
          <stop stopColor="#1a1d22" /><stop offset="1" stopColor="#0c0e11" />
        </linearGradient>
        <radialGradient id={`glow-${id}`} cx="0.8" cy="0.25" r="0.9">
          <stop stopColor={GLOW[variant]} stopOpacity="0.55" /><stop offset="1" stopColor={GLOW[variant]} stopOpacity="0" />
        </radialGradient>
      </defs>
      <rect width="400" height="300" fill={`url(#bg-${id})`} />
      {variant === 'blueprint' && <BlueprintGrid />}
      <rect width="400" height="300" fill={`url(#glow-${id})`} />
      <g transform="translate(200 150)">{MOTIF[variant]}</g>
      {/* vignette */}
      <rect width="400" height="300" fill="#000" opacity="0.18" style={{ mixBlendMode: 'multiply' }} />
    </svg>
  );
}

const GLOW: Record<Variant, string> = {
  'valve-red': '#ff2c4d', 'valve-teal': '#2de0c8', blueprint: '#3b82f6', warehouse: '#2de0c8', refinery: '#ff6b4d',
};

function BlueprintGrid() {
  const lines = [];
  for (let x = 0; x <= 400; x += 25) lines.push(<line key={'v' + x} x1={x} y1="0" x2={x} y2="300" stroke="#3b82f6" strokeWidth="0.5" opacity="0.18" />);
  for (let y = 0; y <= 300; y += 25) lines.push(<line key={'h' + y} x1="0" y1={y} x2="400" y2={y} stroke="#3b82f6" strokeWidth="0.5" opacity="0.18" />);
  return <g>{lines}</g>;
}

function Valve({ color }: { color: string }) {
  const s = { stroke: color, strokeWidth: 5, fill: 'none', strokeLinecap: 'round' as const };
  return (
    <g opacity="0.92">
      <circle cx="0" cy="0" r="70" {...s} />
      <circle cx="0" cy="0" r="46" stroke={color} strokeWidth="3" fill="none" opacity="0.5" />
      <rect x="-140" y="-34" width="34" height="68" rx="3" {...s} />
      <rect x="106" y="-34" width="34" height="68" rx="3" {...s} />
      <path d="M-106 0h36M106 0h-36" {...s} />
      <path d="M0 -70v-34" {...s} />
      <rect x="-46" y="-120" width="92" height="16" rx="8" {...s} />
      {[0, 72, 144, 216, 288].map((a) => {
        const r = (a * Math.PI) / 180;
        // Fixed precision so server- and client-rendered strings match exactly (no hydration drift).
        return <circle key={a} cx={(70 * Math.cos(r)).toFixed(2)} cy={(70 * Math.sin(r)).toFixed(2)} r="4.5" fill={color} />;
      })}
    </g>
  );
}

function Warehouse({ color }: { color: string }) {
  const racks = [];
  for (let i = 0; i < 4; i++) {
    const x = -150 + i * 100;
    racks.push(<g key={i} opacity={0.3 + i * 0.12}>
      <rect x={x} y={-70} width="70" height="150" stroke={color} strokeWidth="3" fill="none" rx="2" />
      <line x1={x} y1={-20} x2={x + 70} y2={-20} stroke={color} strokeWidth="2" />
      <line x1={x} y1={30} x2={x + 70} y2={30} stroke={color} strokeWidth="2" />
      <rect x={x + 8} y={-62} width="24" height="38" fill={color} opacity="0.25" />
      <rect x={x + 38} y={36} width="24" height="38" fill={color} opacity="0.2" />
    </g>);
  }
  return <g>{racks}</g>;
}

function Refinery({ color }: { color: string }) {
  return (
    <g opacity="0.85" stroke={color} strokeWidth="4" fill="none" strokeLinecap="round">
      <rect x="-120" y="-30" width="50" height="110" rx="4" />
      <rect x="-50" y="-70" width="40" height="150" rx="20" />
      <rect x="10" y="-50" width="46" height="130" rx="4" />
      <rect x="66" y="-10" width="60" height="90" rx="4" />
      <path d="M-95 -30v-28M-30 -70v-24M33 -50v-20" />
      <path d="M-150 80h300" opacity="0.5" />
    </g>
  );
}

const MOTIF: Record<Variant, React.ReactNode> = {
  'valve-red': <Valve color="#ff5a73" />,
  'valve-teal': <Valve color="#2de0c8" />,
  blueprint: <Valve color="#7da8f5" />,
  warehouse: <Warehouse color="#2de0c8" />,
  refinery: <Refinery color="#ff8a6b" />,
};
