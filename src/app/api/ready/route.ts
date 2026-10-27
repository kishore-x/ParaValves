import { NextResponse } from 'next/server';
import { query } from '@/server/db';
export async function GET() {
  try {
    await query('select 1');
    return NextResponse.json({ status: 'ready', db: 'up' });
  } catch {
    return NextResponse.json({ status: 'not-ready', db: 'down' }, { status: 503 });
  }
}
