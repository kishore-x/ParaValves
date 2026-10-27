import 'server-only';
import { AsyncLocalStorage } from 'node:async_hooks';
import { PGlite } from '@electric-sql/pglite';
import { pg_trgm } from '@electric-sql/pglite/contrib/pg_trgm';
import { pgcrypto } from '@electric-sql/pglite/contrib/pgcrypto';
import { DEMO_DATA_SQL, DEMO_SCHEMA_SQL } from './demo-sql.generated';

/**
 * In-memory demo database (real Postgres compiled to WASM). Used when no
 * DATABASE_URL is configured on Vercel, or when DEMO_DB=pglite. State lives in
 * the serverless instance: it is re-seeded on every cold start and is not shared
 * between instances, so it is for demos only.
 */
export interface Queryable {
  query<T = any>(text: string, params?: unknown[]): Promise<{ rows: T[] }>;
}

declare global {
  // eslint-disable-next-line no-var
  var __pv_pglite: Promise<PGlite> | undefined;
}

async function init(): Promise<PGlite> {
  const db = new PGlite({
    extensions: { pg_trgm, pgcrypto },
    // Match node-postgres: int8 and numeric come back as strings (money stays exact).
    parsers: { 20: (x: string) => x, 1700: (x: string) => x },
  });
  await db.waitReady;
  await db.exec(DEMO_SCHEMA_SQL);
  await db.exec(DEMO_DATA_SQL);
  // The dump disables triggers and blanks search_path for the session — undo both.
  await db.exec('reset session_replication_role; set search_path to public;');
  return db;
}

const getDb = () => (globalThis.__pv_pglite ??= init());

// One embedded connection: serialize access. Code running inside a transaction
// (tracked via AsyncLocalStorage) re-enters without waiting, like a pooled client would.
const inTx = new AsyncLocalStorage<true>();
let tail: Promise<void> = Promise.resolve();

function acquire(): Promise<() => void> {
  let release!: () => void;
  const prev = tail;
  tail = new Promise<void>((r) => (release = r));
  return prev.then(() => release);
}

async function run(text: string, params: unknown[]) {
  const db = await getDb();
  if (params.length === 0) {
    // Simple protocol, like node-postgres: allows multi-statement text.
    const results = await db.exec(text);
    return { rows: (results[results.length - 1]?.rows ?? []) as any[] };
  }
  const res = await db.query(text, params as never[]);
  return { rows: res.rows as any[] };
}

export const pglitePool: Queryable = {
  async query(text: string, params: unknown[] = []) {
    if (inTx.getStore()) return run(text, params);
    const release = await acquire();
    try {
      return await run(text, params);
    } finally {
      release();
    }
  },
};

export async function pgliteTx<T>(fn: (c: Queryable) => Promise<T>): Promise<T> {
  const release = await acquire();
  try {
    return await inTx.run(true, async () => {
      await run('begin', []);
      try {
        const result = await fn({ query: (t: string, p: unknown[] = []) => run(t, p) });
        await run('commit', []);
        return result;
      } catch (e) {
        await run('rollback', []);
        throw e;
      }
    });
  } finally {
    release();
  }
}
