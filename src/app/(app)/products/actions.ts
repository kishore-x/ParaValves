'use server';
import { redirect } from 'next/navigation';
import { revalidatePath } from 'next/cache';
import { requirePermission } from '@/server/auth/action';
import { createProduct, generatePartNumber } from '@/server/domain/product';

export async function newProductAction(formData: FormData) {
  const user = await requirePermission('product.create');
  const id = await createProduct(user, {
    product_code: formData.get('product_code'),
    name: formData.get('name'),
    description: formData.get('description'),
    uom: formData.get('uom'),
    material: formData.get('material'),
    dimensions: formData.get('dimensions'),
    hsn_sac: formData.get('hsn_sac'),
    tax_rate: formData.get('tax_rate'),
    standard_cost: formData.get('standard_cost'),
    selling_price: formData.get('selling_price'),
    min_stock: formData.get('min_stock'),
    reorder_point: formData.get('reorder_point'),
    is_manufactured: formData.get('is_manufactured') === 'on',
  });
  redirect(`/products/${id}`);
}

export async function genPartNumberAction(formData: FormData) {
  const user = await requirePermission('partnumber.create');
  const productId = String(formData.get('product_id'));
  await generatePartNumber(user, productId, {
    family: String(formData.get('family') ?? ''),
    size: String(formData.get('size') ?? ''),
    material: String(formData.get('material') ?? ''),
    config: String(formData.get('config') ?? ''),
  });
  revalidatePath(`/products/${productId}`);
}
