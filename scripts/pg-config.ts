import type { PoolConfig } from 'pg';

/**
 * Shared connection config for the CLI scripts so they work against local
 * Docker Postgres *and* managed providers (Supabase, Neon, Render…) which
 * require TLS.
 */
export function pgConfig(preferDirect = false): PoolConfig {
  const url =
    (preferDirect ? process.env.DIRECT_DATABASE_URL : undefined) ??
    process.env.DATABASE_URL ??
    'postgres://paravalves:paravalves_dev_pw@127.0.0.1:55432/paravalves';

  const isLocal = /@(localhost|127\.0\.0\.1|db)[:/]/.test(url);
  const useSsl = process.env.DATABASE_SSL
    ? process.env.DATABASE_SSL === 'true'
    : !isLocal || /sslmode=require/.test(url);

  return { connectionString: url, ssl: useSsl ? { rejectUnauthorized: false } : undefined };
}
