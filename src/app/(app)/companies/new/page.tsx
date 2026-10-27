import { requirePermission } from '@/server/auth/action';
import { Card, PageHeader, Field, inputCls, Button } from '@/components/ui';
import { newCompanyAction } from '../actions';

export default async function NewCompanyPage() {
  await requirePermission('company.create');
  return (
    <div className="mx-auto max-w-2xl">
      <PageHeader title="New Company" />
      <Card className="p-6">
        <form action={newCompanyAction} className="grid gap-4 sm:grid-cols-2">
          <div className="sm:col-span-2"><Field label="Name" required><input name="name" required className={inputCls} /></Field></div>
          <Field label="Country"><input name="country" defaultValue="IN" className={inputCls} /></Field>
          <Field label="State code"><input name="state_code" placeholder="e.g. 29" className={inputCls} /></Field>
          <Field label="City"><input name="city" className={inputCls} /></Field>
          <Field label="Postal code"><input name="postal_code" className={inputCls} /></Field>
          <div className="sm:col-span-2"><Field label="Address"><textarea name="address" rows={2} className={inputCls} /></Field></div>
          <Field label="GSTIN"><input name="gstin" className={inputCls} /></Field>
          <Field label="Tax treatment"><select name="tax_treatment" className={inputCls}><option>DOMESTIC</option><option>EXPORT</option></select></Field>
          <Field label="Currency"><select name="currency" className={inputCls}><option>INR</option><option>EUR</option><option>USD</option></select></Field>
          <Field label="Payment terms"><select name="payment_terms" className={inputCls}><option>NET30</option><option>NET15</option><option>NET45</option><option>ADVANCE</option></select></Field>
          <label className="flex items-center gap-2 text-sm sm:col-span-2"><input type="checkbox" name="is_supplier" /> This is a supplier</label>
          <div className="sm:col-span-2 flex gap-2"><Button type="submit">Create</Button><Button href="/companies" variant="ghost">Cancel</Button></div>
        </form>
      </Card>
    </div>
  );
}
