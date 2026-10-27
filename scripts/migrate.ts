import 'dotenv/config';
import { readdirSync, readFileSync } from 'node:fs';
import { join } from 'node:path';
import { Pool } from 'pg';
import { pgConfig } from './pg-config';

const DIR = join(process.cwd(), 'migrations');

async function main() {
  const pool = new Pool(pgConfig(true)); // prefer DIRECT_DATABASE_URL for DDL
  await pool.query(`create table if not exists schema_migrations (
    name text primary key, applied_at timestamptz not null default now())`);
  const applied = new Set(
    (await pool.query<{ name: string }>('select name from schema_migrations')).rows.map((r) => r.name),
  );
  const files = readdirSync(DIR).filter((f) => f.endsWith('.sql')).sort();
  let count = 0;
  for (const file of files) {
    if (applied.has(file)) continue;
    const sql = readFileSync(join(DIR, file), 'utf8');
    const client = await pool.connect();
    try {
      await client.query('begin');
      await client.query(sql);
      await client.query('insert into schema_migrations(name) values ($1)', [file]);
      await client.query('commit');
      console.log(`✓ applied ${file}`);
      count++;
    } catch (e) {
      await client.query('rollback');
      console.error(`✗ failed ${file}`);
      throw e;
    } finally {
      client.release();
    }
  }
  console.log(count ? `Done. ${count} migration(s) applied.` : 'Database already up to date.');
  await pool.end();
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
