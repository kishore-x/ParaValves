import { requirePermission } from '@/server/auth/action';
import { Card, PageHeader, Field, inputCls, Button } from '@/components/ui';
import { newProductAction } from '../actions';

export default async function NewProductPage() {
  await requirePermission('product.create');
  return (
    <div className="mx-auto max-w-2xl">
      <PageHeader title="New Product" />
      <Card className="p-6">
        <form action={newProductAction} className="grid gap-4 sm:grid-cols-2">
          <Field label="Product code" required><input name="product_code" required className={inputCls} /></Field>
          <Field label="Name" required><input name="name" required className={inputCls} /></Field>
          <Field label="UOM"><input name="uom" defaultValue="NOS" className={inputCls} /></Field>
          <Field label="Material"><input name="material" className={inputCls} /></Field>
          <Field label="Dimensions"><input name="dimensions" className={inputCls} /></Field>
          <Field label="HSN/SAC"><input name="hsn_sac" className={inputCls} /></Field>
          <Field label="Tax rate %"><input name="tax_rate" type="number" step="any" defaultValue="18" className={inputCls} /></Field>
          <Field label="Standard cost"><input name="standard_cost" type="number" step="any" defaultValue="0" className={inputCls} /></Field>
          <Field label="Selling price"><input name="selling_price" type="number" step="any" defaultValue="0" className={inputCls} /></Field>
          <Field label="Min stock"><input name="min_stock" type="number" step="any" defaultValue="0" className={inputCls} /></Field>
          <Field label="Reorder point"><input name="reorder_point" type="number" step="any" defaultValue="0" className={inputCls} /></Field>
          <div className="sm:col-span-2"><Field label="Description"><textarea name="description" rows={2} className={inputCls} /></Field></div>
          <label className="flex items-center gap-2 text-sm sm:col-span-2"><input type="checkbox" name="is_manufactured" /> Manufactured in-house (has BOM)</label>
          <div className="sm:col-span-2 flex gap-2"><Button type="submit">Create</Button><Button href="/products" variant="ghost">Cancel</Button></div>
        </form>
      </Card>
    </div>
  );
}
