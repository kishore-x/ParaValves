'use server';
import { requirePermission } from '@/server/auth/action';
import { previewImport, commitImport, type ImportEntity, type PreviewResult } from '@/server/domain/imports';

export async function previewAction(entity: ImportEntity, csv: string): Promise<PreviewResult> {
  const user = await requirePermission('admin.view');
  return previewImport(user, entity, csv);
}

export async function commitAction(entity: ImportEntity, csv: string): Promise<{ imported: number; skipped: number }> {
  const user = await requirePermission('admin.manage');
  const r = await commitImport(user, entity, csv);
  return { imported: r.imported, skipped: r.skipped };
}
