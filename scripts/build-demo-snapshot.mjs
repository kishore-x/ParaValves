// Pre-builds the in-memory demo database into deploy/pglite/snapshot.tar.gz so a cold
// serverless start loads a ready data directory (~0.5s) instead of running initdb and
// replaying SQL (~2.7s). Re-run after changing schema.sql / data.sql or upgrading PGlite:
//   node scripts/build-demo-snapshot.mjs
import { readFileSync, writeFileSync } from 'node:fs';
import { PGlite } from '@electric-sql/pglite';
import { pg_trgm } from '@electric-sql/pglite/contrib/pg_trgm';
import { pgcrypto } from '@electric-sql/pglite/contrib/pgcrypto';

const read = (f) => readFileSync(new URL(`../deploy/pglite/${f}`, import.meta.url), 'utf8');

const db = new PGlite({ extensions: { pg_trgm, pgcrypto } });
await db.waitReady;
await db.exec(read('schema.sql'));
await db.exec(read('data.sql'));
await db.exec('reset session_replication_role; set search_path to public;');

const buf = Buffer.from(await (await db.dumpDataDir('gzip')).arrayBuffer());
writeFileSync(new URL('../deploy/pglite/snapshot.tar.gz', import.meta.url), buf);
console.log('wrote deploy/pglite/snapshot.tar.gz', (buf.length / 1048576).toFixed(1) + ' MB');
await db.close();
process.exit(0);
