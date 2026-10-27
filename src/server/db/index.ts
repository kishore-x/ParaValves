import 'server-only';
import { Pool, type QueryResultRow } from 'pg';
import { env } from '../env';
import { pglitePool, pgliteTx, type Queryable } from './pglite';

declare global {
  // eslint-disable-next-line no-var
  var __pv_pool: Pool | undefined;
}

// Demo mode: in-memory Postgres (PGlite) instead of a server. Explicit via DEMO_DB=pglite,
// or automatic on Vercel when no DATABASE_URL has been configured.
const demo = process.env.DEMO_DB === 'pglite' || (!!process.env.VERCEL && !process.env.DATABASE_URL);

const url = env.DATABASE_URL;
const isLocal = /@(localhost|127\.0\.0\.1|db)[:/]/.test(url);
// Managed Postgres (Neon, Supabase, Render…) requires TLS. Enable it unless we
// are clearly talking to a local/dev database, or DATABASE_SSL says otherwise.
const useSsl = process.env.DATABASE_SSL
  ? process.env.DATABASE_SSL === 'true'
  : !isLocal || /sslmode=require/.test(url);
// Serverless (Vercel) runs many short-lived instances — keep pools small there.
const defaultMax = process.env.VERCEL ? 3 : 10;
// An env var present but blank (not unset) must not silently become 0 here —
// max:0 would allow zero connections. See src/server/env.ts's numEnv note.
const rawMax = process.env.DATABASE_POOL_MAX;
const poolMax = rawMax && rawMax.trim() !== '' && Number.isFinite(Number(rawMax)) ? Number(rawMax) : defaultMax;

const realPool = (): Pool =>
  global.__pv_pool ??
  new Pool({
    connectionString: url,
    max: poolMax,
    ssl: useSsl ? { rejectUnauthorized: false } : undefined,
    idleTimeoutMillis: 30_000,
    connectionTimeoutMillis: 10_000,
  });

export const pool: Pool = demo ? (pglitePool as unknown as Pool) : realPool();

if (!demo && env.NODE_ENV !== 'production') global.__pv_pool = pool;

export async function query<T extends QueryResultRow = QueryResultRow>(
  text: string,
  params: unknown[] = [],
): Promise<T[]> {
  const res = await pool.query<T>(text, params as never[]);
  return res.rows;
}

export async function one<T extends QueryResultRow = QueryResultRow>(
  text: string,
  params: unknown[] = [],
): Promise<T | null> {
  const rows = await query<T>(text, params);
  return rows[0] ?? null;
}

/** Run fn inside a transaction; commits on success, rolls back on throw. */
export async function tx<T>(fn: (c: TxClient) => Promise<T>): Promise<T> {
  if (demo) return pgliteTx((c) => fn(new TxClient(c)));
  const client = await pool.connect();
  try {
    await client.query('begin');
    const result = await fn(new TxClient(client));
    await client.query('commit');
    return result;
  } catch (e) {
    await client.query('rollback');
    throw e;
  } finally {
    client.release();
  }
}

export class TxClient {
  constructor(private readonly client: Queryable) {}
  async query<T extends QueryResultRow = QueryResultRow>(text: string, params: unknown[] = []): Promise<T[]> {
    const res = await this.client.query<T>(text, params as never[]);
    return res.rows;
  }
  async one<T extends QueryResultRow = QueryResultRow>(text: string, params: unknown[] = []): Promise<T | null> {
    const rows = await this.query<T>(text, params);
    return rows[0] ?? null;
  }
}
