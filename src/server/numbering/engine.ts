import 'server-only';
import type { TxClient } from '../db';
import { pool } from '../db';

export type DocType =
  | 'LEAD' | 'QUO' | 'SO' | 'PO' | 'PR' | 'PROJ' | 'INV' | 'CN' | 'DN'
  | 'GRN' | 'MR' | 'DRW' | 'PART' | 'CUST' | 'SUPP' | 'EXP' | 'TASK' | 'ER' | 'PAY'
  | 'NCR' | 'INS' | 'WO' | 'SC' | 'TST' | 'SHP' | 'ECN' | 'EXC' | 'LOT';

const DEFAULT_PREFIX: Record<DocType, string> = {
  LEAD: 'LEAD', QUO: 'QUO', SO: 'SO', PO: 'PO', PR: 'PR', PROJ: 'PROJ',
  INV: 'INV', CN: 'CN', DN: 'DN', GRN: 'GRN', MR: 'MR', DRW: 'DRW',
  PART: 'PART', CUST: 'CUST', SUPP: 'SUPP', EXP: 'EXP', TASK: 'TASK', ER: 'ER', PAY: 'PAY',
  NCR: 'NCR', INS: 'INS', WO: 'WO', SC: 'SC', TST: 'TST', SHP: 'SHP', ECN: 'ECN', EXC: 'EXC', LOT: 'LOT',
};

/**
 * Concurrency-safe number generation. A single atomic upsert guarantees two
 * callers can never receive the same value. Must be called inside a transaction
 * (pass the TxClient) so the number aligns with the document being created.
 */
export async function nextNumber(
  client: TxClient | typeof pool,
  orgId: string,
  docType: DocType,
): Promise<string> {
  const year = new Date().getUTCFullYear();
  const periodKey = String(year);
  const prefix = DEFAULT_PREFIX[docType];
  const padding = 6;

  const q = `
    insert into number_sequences (org_id, doc_type, period_key, prefix, padding, current_value)
    values ($1,$2,$3,$4,$5,1)
    on conflict (org_id, doc_type, period_key)
    do update set current_value = number_sequences.current_value + 1
    returning current_value, prefix, padding`;

  const params = [orgId, docType, periodKey, prefix, padding];
  const rows =
    'query' in client
      ? await (client as TxClient).query<{ current_value: string; prefix: string; padding: number }>(q, params)
      : (await (client as typeof pool).query(q, params as never[])).rows;

  const row = rows[0]!;
  const seq = String(row.current_value).padStart(row.padding, '0');
  return `${row.prefix}-${year}-${seq}`;
}
