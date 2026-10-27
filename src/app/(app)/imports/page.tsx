import { requirePermission } from '@/server/auth/action';
import { PageHeader } from '@/components/ui';
import { ImportClient } from './ImportClient';

export default async function ImportsPage() {
  await requirePermission('admin.view');
  return (
    <div className="mx-auto max-w-5xl">
      <PageHeader title="Data Import" subtitle="Migrate companies, products and contacts from Excel / CSV — validate before anything is saved." />
      <ImportClient />
    </div>
  );
}
