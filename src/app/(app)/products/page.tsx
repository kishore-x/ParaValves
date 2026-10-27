import Link from 'next/link';
import { requireUser } from '@/server/auth/action';
import { query } from '@/server/db';
import { Card, Table, Th, Td, PageHeader, Button, EmptyState } from '@/components/ui';
import { formatMoney } from '@/lib/money';
import { num } from '@/lib/format';

export default async function ProductsPage({ searchParams }: { searchParams: Promise<{ q?: string }> }) {
  const user = await requireUser();
  const { q } = await searchParams;
  const params: unknown[] = [user.currentOrgId];
  let where = 'p.org_id=$1 and p.archived_at is null';
  if (q) { params.push(`%${q}%`); where += ` and (p.name ilike $2 or p.product_code ilike $2)`; }
  const rows = await query<any>(
    `select p.id, p.product_code, p.name, p.uom, p.material, p.selling_price, p.is_manufactured,
       coalesce(sum(s.on_hand),0) on_hand
     from products p left join stock_items s on s.product_id=p.id
     where ${where} group by p.id order by p.product_code limit 100`, params);
  return (
    <div>
      <PageHeader title="Products" subtitle="Product master" action={<Button href="/products/new">+ New Product</Button>} />
      <Card>
        {rows.length === 0 ? <EmptyState title="No products" action={<Button href="/products/new">+ New Product</Button>} /> : (
          <Table>
            <thead><tr><Th>Code</Th><Th>Name</Th><Th>Material</Th><Th>UOM</Th><Th>On hand</Th><Th>Price</Th><Th>Type</Th></tr></thead>
            <tbody>{rows.map((r) => (
              <tr key={r.id} className="hover:bg-bg">
                <Td><Link href={`/products/${r.id}`} className="font-mono font-medium text-brand">{r.product_code}</Link></Td>
                <Td>{r.name}</Td><Td>{r.material ?? '—'}</Td><Td>{r.uom}</Td>
                <Td>{num(r.on_hand)}</Td><Td>{formatMoney(r.selling_price)}</Td>
                <Td className="text-muted">{r.is_manufactured ? 'Manufactured' : 'Purchased'}</Td>
              </tr>
            ))}</tbody>
          </Table>
        )}
      </Card>
    </div>
  );
}
