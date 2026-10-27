import 'dotenv/config';
import { Pool } from 'pg';
import { pgConfig } from './pg-config';
import { randomBytes, createHash } from 'node:crypto';
async function main() {
  const email = process.argv[2] ?? 'admin@paravalves.com';
  const pool = new Pool(pgConfig());
  const u = await pool.query<{ id: string }>('select id from users where email=$1', [email]);
  const token = randomBytes(32).toString('hex');
  const hash = createHash('sha256').update(token).digest('hex');
  await pool.query(
    `insert into sessions(user_id, token_hash, expires_at) values ($1,$2, now() + interval '12 hours')`,
    [u.rows[0]!.id, hash]);
  console.log(token);
  await pool.end();
}
main();
