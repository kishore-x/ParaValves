import Link from 'next/link';
import { requireUser } from '@/server/auth/action';
import { query } from '@/server/db';
import { Card, CardHeader, PageHeader, EmptyState, inputCls } from '@/components/ui';

export default async function SearchPage({ searchParams }: { searchParams: Promise<{ q?: string }> }) {
  const user = await requireUser();
  const { q } = await searchParams;
  const term = (q ?? '').trim();
  const like = `%${term}%`;
  const orgs = user.orgIds;

  const results = term.length >= 1 ? await Promise.all([
    query<any>(`select id, lead_number num, company_name label from leads where org_id=any($1) and (lead_number ilike $2 or company_name ilike $2) limit 8`, [orgs, like]).then((r) => ({ type: 'Leads', base: '/leads/', rows: r })),
    query<any>(`select id, company_number num, name label from companies where org_id=any($1) and (company_number ilike $2 or name ilike $2) limit 8`, [orgs, like]).then((r) => ({ type: 'Companies', base: '/companies/', rows: r })),
    query<any>(`select id, quote_number num, '' label from quotations where org_id=any($1) and quote_number ilike $2 limit 8`, [orgs, like]).then((r) => ({ type: 'Quotations', base: '/quotes/', rows: r })),
    query<any>(`select id, order_number num, '' label from sales_orders where org_id=any($1) and order_number ilike $2 limit 8`, [orgs, like]).then((r) => ({ type: 'Sales Orders', base: '/orders/', rows: r })),
    query<any>(`select id, product_code num, name label from products where org_id=any($1) and (product_code ilike $2 or name ilike $2) limit 8`, [orgs, like]).then((r) => ({ type: 'Products', base: '/products/', rows: r })),
    query<any>(`select id, part_number num, '' label from part_numbers where org_id=any($1) and part_number ilike $2 limit 8`, [orgs, like]).then((r) => ({ type: 'Part Numbers', base: '/products/', rows: r })),
    query<any>(`select id, invoice_number num, '' label from invoices where org_id=any($1) and invoice_number ilike $2 limit 8`, [orgs, like]).then((r) => ({ type: 'Invoices', base: '/invoices/', rows: r })),
    query<any>(`select id, po_number num, '' label from purchase_orders where org_id=any($1) and po_number ilike $2 limit 8`, [orgs, like]).then((r) => ({ type: 'Purchase Orders', base: '/procurement/', rows: r })),
  ]) : [];
  const nonEmpty = results.filter((r) => r.rows.length > 0);

  return (
    <div className="mx-auto max-w-3xl">
      <PageHeader title="Global Search" subtitle="Find any record and jump to its connected chain" />
      <form method="get" className="mb-5">
        <input name="q" defaultValue={term} autoFocus placeholder="Type a number, name or code…" className={inputCls} />
      </form>
      {term && nonEmpty.length === 0 && <Card><EmptyState title={`No results for “${term}”`} /></Card>}
      <div className="space-y-4">
        {nonEmpty.map((g) => (
          <Card key={g.type}>
            <CardHeader title={g.type} subtitle={`${g.rows.length} result(s)`} />
            <ul className="divide-y divide-line">
              {g.rows.map((r) => (
                <li key={r.id}><Link href={g.base + r.id} className="flex items-center justify-between px-5 py-2.5 text-sm hover:bg-bg">
                  <span><span className="font-mono font-medium text-brand">{r.num}</span> {r.label && <span className="text-muted">— {r.label}</span>}</span>
                  <span className="text-brand">→</span>
                </Link></li>
              ))}
            </ul>
          </Card>
        ))}
      </div>
    </div>
  );
}
