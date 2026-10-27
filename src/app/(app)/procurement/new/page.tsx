import { requirePermission } from '@/server/auth/action';
import { query } from '@/server/db';
import { PageHeader } from '@/components/ui';
import { POForm } from './POForm';

export default async function NewPOPage() {
  const user = await requirePermission('procurement.create');
  const [suppliers, products] = await Promise.all([
    query<any>(`select id, name from companies where org_id=$1 and is_supplier=true and archived_at is null order by name`, [user.currentOrgId]),
    query<any>(`select id, product_code, name, standard_cost::text from products where org_id=$1 and archived_at is null order by product_code`, [user.currentOrgId]),
  ]);
  return (
    <div className="mx-auto max-w-5xl">
      <PageHeader title="New Purchase Order" />
      <POForm suppliers={suppliers} products={products} />
    </div>
  );
}
