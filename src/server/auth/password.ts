import 'server-only';
import { randomBytes, scrypt as _scrypt, timingSafeEqual } from 'node:crypto';
import { promisify } from 'node:util';

const scrypt = promisify(_scrypt);
const N = 16384;
const KEYLEN = 64;

export async function hashPassword(password: string): Promise<string> {
  const salt = randomBytes(16);
  const derived = (await (scrypt as any)(password, salt, KEYLEN, { N })) as Buffer;
  return `scrypt$${N}$${salt.toString('hex')}$${derived.toString('hex')}`;
}

export async function verifyPassword(password: string, stored: string): Promise<boolean> {
  const parts = stored.split('$');
  if (parts.length !== 4 || parts[0] !== 'scrypt') return false;
  const cost = Number(parts[1]);
  const salt = Buffer.from(parts[2]!, 'hex');
  const expected = Buffer.from(parts[3]!, 'hex');
  const derived = (await (scrypt as any)(password, salt, expected.length, { N: cost })) as Buffer;
  return derived.length === expected.length && timingSafeEqual(derived, expected);
}
