import 'server-only';
import { query, type TxClient } from '../db';

interface AuditInput {
  orgId?: string | null;
  actorId?: string | null;
  actorName?: string | null;
  action: string;
  entityType: string;
  entityId?: string | null;
  before?: unknown;
  after?: unknown;
  metadata?: Record<string, unknown>;
  ip?: string | null;
}

export async function audit(input: AuditInput, client?: TxClient): Promise<void> {
  const q = `insert into audit_logs
    (org_id, actor_id, actor_name, action, entity_type, entity_id, before_data, after_data, metadata, ip)
    values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)`;
  const params = [
    input.orgId ?? null,
    input.actorId ?? null,
    input.actorName ?? null,
    input.action,
    input.entityType,
    input.entityId ?? null,
    input.before ? JSON.stringify(input.before) : null,
    input.after ? JSON.stringify(input.after) : null,
    input.metadata ? JSON.stringify(input.metadata) : null,
    input.ip ?? null,
  ];
  if (client) await client.query(q, params);
  else await query(q, params);
}

export async function logActivity(
  orgId: string,
  entityType: string,
  entityId: string,
  kind: string,
  summary: string,
  actor?: { id: string; name: string },
  client?: TxClient,
): Promise<void> {
  const q = `insert into activities (org_id, entity_type, entity_id, kind, summary, actor_id, actor_name)
             values ($1,$2,$3,$4,$5,$6,$7)`;
  const params = [orgId, entityType, entityId, kind, summary, actor?.id ?? null, actor?.name ?? null];
  if (client) await client.query(q, params);
  else await query(q, params);
}
