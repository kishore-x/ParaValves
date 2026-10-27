import { requirePermission } from '@/server/auth/action';
import { query } from '@/server/db';
import { PageHeader } from '@/components/ui';
import { QuoteForm } from './QuoteForm';

export default async function NewQuotePage() {
  const user = await requirePermission('quote.create');
  const [companies, products] = await Promise.all([
    query<any>(`select id, name, company_number from companies where org_id=$1 and is_customer=true and archived_at is null order by name`, [user.currentOrgId]),
    query<any>(`select id, product_code, name, selling_price::text, tax_rate::text from products where org_id=$1 and archived_at is null order by product_code`, [user.currentOrgId]),
  ]);
  return (
    <div className="mx-auto max-w-5xl">
      <PageHeader title="New Quotation" subtitle="Totals are recomputed on the server on save" />
      <QuoteForm companies={companies} products={products} />
    </div>
  );
}
