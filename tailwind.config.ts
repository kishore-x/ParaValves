import type { Config } from 'tailwindcss';

const c = (name: string) => `rgb(var(--${name}) / <alpha-value>)`;

const config: Config = {
  content: ['./src/**/*.{ts,tsx}'],
  theme: {
    extend: {
      colors: {
        bg: c('bg'),
        surface: c('surface'),
        raised: c('raised'),
        line: c('line'),
        'line-strong': c('line-strong'),
        ink: c('ink'),
        muted: c('muted'),
        faint: c('faint'),
        brand: c('brand'),
        'brand-strong': c('brand-strong'),
        'brand-ink': c('brand-ink'),
        'brand-wash': c('brand-wash'),
        ok: c('ok'),
        'ok-wash': c('ok-wash'),
        warn: c('warn'),
        'warn-wash': c('warn-wash'),
        danger: c('danger'),
        'danger-wash': c('danger-wash'),
        info: c('info'),
        'info-wash': c('info-wash'),
      },
      fontFamily: {
        sans: ['var(--font-sans)', 'ui-sans-serif', 'system-ui', 'Segoe UI', 'Roboto', 'sans-serif'],
        mono: ['var(--font-mono)', 'ui-monospace', 'SFMono-Regular', 'Menlo', 'Consolas', 'monospace'],
      },
      fontSize: {
        '2xs': ['0.6875rem', { lineHeight: '1rem', letterSpacing: '0.02em' }],
      },
      boxShadow: {
        sm: 'var(--shadow-sm)',
        md: 'var(--shadow-md)',
        lg: 'var(--shadow-lg)',
      },
      borderRadius: { xl: '0.75rem', '2xl': '1rem' },
      ringColor: { DEFAULT: 'rgb(var(--ring))' },
    },
  },
  plugins: [],
};
export default config;
