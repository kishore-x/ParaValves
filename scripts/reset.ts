import 'dotenv/config';
import { Pool } from 'pg';
import { pgConfig } from './pg-config';
async function main() {
  const pool = new Pool(pgConfig());
  await pool.query('drop schema public cascade; create schema public;');
  console.log('✓ Schema dropped and recreated. Run db:migrate and db:seed next.');
  await pool.end();
}
main().catch((e) => { console.error(e); process.exit(1); });
