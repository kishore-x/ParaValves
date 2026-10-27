import { requirePermission } from '@/server/auth/action';
import { Card, PageHeader, Field, inputCls, Button } from '@/components/ui';
import { newLeadAction } from '../actions';

export default async function NewLeadPage() {
  await requirePermission('lead.create');
  return (
    <div className="mx-auto max-w-2xl">
      <PageHeader title="New Lead" subtitle="Capture incoming demand" />
      <Card className="p-6">
        <form action={newLeadAction} className="grid gap-4 sm:grid-cols-2">
          <div className="sm:col-span-2"><Field label="Company name" required><input name="company_name" required className={inputCls} /></Field></div>
          <Field label="Contact name"><input name="contact_name" className={inputCls} /></Field>
          <Field label="Email"><input name="email" type="email" className={inputCls} /></Field>
          <Field label="Phone"><input name="phone" className={inputCls} /></Field>
          <Field label="Country"><input name="country" defaultValue="IN" className={inputCls} /></Field>
          <Field label="Product requirement"><input name="product_requirement" className={inputCls} /></Field>
          <Field label="Quantity"><input name="quantity" type="number" step="any" className={inputCls} /></Field>
          <Field label="Source">
            <select name="source" className={inputCls} defaultValue="MANUAL">
              {['MANUAL', 'WEBSITE', 'EMAIL', 'PHONE', 'REFERRAL', 'IMPORT', 'OTHER'].map((s) => <option key={s}>{s}</option>)}
            </select>
          </Field>
          <Field label="Priority">
            <select name="priority" className={inputCls} defaultValue="NORMAL">
              {['LOW', 'NORMAL', 'HIGH', 'URGENT'].map((s) => <option key={s}>{s}</option>)}
            </select>
          </Field>
          <Field label="Expected value (₹)"><input name="expected_value" type="number" step="any" className={inputCls} /></Field>
          <Field label="Expected close date"><input name="expected_close" type="date" className={inputCls} /></Field>
          <div className="sm:col-span-2"><Field label="Description"><textarea name="description" rows={3} className={inputCls} /></Field></div>
          <div className="sm:col-span-2 flex gap-2">
            <Button type="submit">Create Lead</Button>
            <Button href="/leads" variant="ghost">Cancel</Button>
          </div>
        </form>
      </Card>
    </div>
  );
}
