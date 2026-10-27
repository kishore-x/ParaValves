import 'server-only';

function req(name: string, fallback?: string): string {
  const v = process.env[name] ?? fallback;
  if (v === undefined) throw new Error(`Missing required env var: ${name}`);
  return v;
}

/**
 * Numeric env var with a safe fallback. `??` alone is not enough here: a var
 * that exists in the platform (e.g. Vercel) with an EMPTY string value is not
 * `undefined`, so `?? fallback` never triggers and `Number('')` silently
 * becomes 0 — e.g. this turned SESSION_TTL_HOURS into 0, expiring every
 * session within milliseconds of login. Treat blank/unparseable as unset.
 */
function numEnv(name: string, fallback: number): number {
  const raw = process.env[name];
  if (raw === undefined || raw.trim() === '') return fallback;
  const n = Number(raw);
  return Number.isFinite(n) ? n : fallback;
}

export const env = {
  NODE_ENV: process.env.NODE_ENV ?? 'development',
  APP_URL: process.env.APP_URL ?? 'http://localhost:3000',
  DATABASE_URL: req('DATABASE_URL', 'postgres://paravalves:paravalves_dev_pw@127.0.0.1:55432/paravalves'),
  SESSION_SECRET: req('SESSION_SECRET', 'dev-insecure-session-secret-change-me'),
  SESSION_TTL_HOURS: numEnv('SESSION_TTL_HOURS', 12),
  SESSION_IDLE_MIN: numEnv('SESSION_IDLE_TIMEOUT_MINUTES', 120),
  COOKIE_SECURE: (process.env.COOKIE_SECURE ?? 'false') === 'true',
  WEBSITE_INQUIRY_API_KEY: process.env.WEBSITE_INQUIRY_API_KEY ?? '',
  WEBSITE_RATE_PER_HOUR: numEnv('WEBSITE_INQUIRY_RATE_PER_HOUR', 20),
  MAIL_DRIVER: process.env.MAIL_DRIVER ?? 'log',
};
