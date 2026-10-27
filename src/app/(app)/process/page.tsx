import Link from 'next/link';
import { requireUser } from '@/server/auth/action';
import { one } from '@/server/db';
import { PageHeader } from '@/components/ui';

/** Live view of the client's 12-stage valve ERP process. */
export default async function ProcessPage() {
  const user = await requireUser();
  const o = user.currentOrgId;
  const c = await one<any>(
    `select
      (select count(*) from quotations where org_id=$1 and status in ('DRAFT','INTERNAL_REVIEW','SENT','NEGOTIATION','APPROVED','VIEWED'))::int quotes,
      (select count(*) from sales_orders where org_id=$1 and status not in ('CLOSED','CANCELLED'))::int orders,
      (select count(*) from drawings where org_id=$1 and status<>'RELEASED' and status<>'SUPERSEDED')::int drawings,
      (select count(*) from material_requirements where org_id=$1 and status='OPEN' and shortage_qty>0)::int shortages,
      (select count(*) from purchase_orders where org_id=$1 and status not in ('CLOSED','RECEIVED'))::int pos,
      (select count(*) from work_orders where org_id=$1 and status in ('RELEASED','IN_PROGRESS'))::int wip,
      (select count(*) from inspections where org_id=$1 and status='PENDING' and stage<>'FINAL')::int insp,
      (select count(*) from material_lots where org_id=$1 and status='RELEASED')::int lots,
      (select count(*) from serial_units where org_id=$1 and status in ('IN_ASSEMBLY'))::int assembly,
      (select count(*) from serial_units where org_id=$1 and status in ('AWAITING_FINAL','QUARANTINE'))::int final,
      (select count(*) from shipments where org_id=$1 and status in ('DRAFT','BLOCKED','READY'))::int dispatch,
      (select count(*) from invoices where org_id=$1 and status in ('ISSUED','PARTIALLY_PAID','OVERDUE'))::int invoices`, [o]);
  const steps = [
    { n: 1, t: 'Enquiry & quotation', h: '/quotes', m: `${c.quotes} open quotes`, d: 'Configuration validation, versions, approvals' },
    { n: 2, t: 'Sales order & review', h: '/orders', m: `${c.orders} active orders`, d: 'PO / spec / price / credit / date review & acknowledgement' },
    { n: 3, t: 'Engineering release', h: '/engineering', m: `${c.drawings} drawings in approval`, d: 'Drawings, revisions, BOM, change impact (ECN)' },
    { n: 4, t: 'Planning & supply', h: '/inventory', m: `${c.shortages} open shortages`, d: 'Net demand vs stock, WIP and POs' },
    { n: 5, t: 'Procurement & receiving', h: '/procurement', m: `${c.pos} open POs`, d: 'Approved suppliers, lot/heat/cert capture' },
    { n: 6, t: 'Production & subcontract', h: '/production', m: `${c.wip} WOs on the floor`, d: 'Controlled release, ops, scrap/rework, subcontract' },
    { n: 7, t: 'Component inspection & testing', h: '/quality', m: `${c.insp} inspections pending`, d: 'Quarantine, NCR, calibration' },
    { n: 8, t: 'Stores & inventory', h: '/inventory', m: `${c.lots} released lots`, d: 'Status/location, reservation & issue' },
    { n: 9, t: 'Assembly & traceability', h: '/assembly', m: `${c.assembly} in assembly`, d: 'Serial/tag, genealogy, as-built' },
    { n: 10, t: 'Final inspection & testing', h: '/quality/tests', m: `${c.final} awaiting release`, d: 'Pressure, seat/leak, functional' },
    { n: 11, t: 'Dispatch & invoicing', h: '/shipments', m: `${c.dispatch} open shipments · ${c.invoices} invoices`, d: 'Quality, credit, export & document gates' },
    { n: 12, t: 'Costing & reporting', h: '/costing', m: 'Planned vs actual', d: 'Material, labour, subcontract, scrap, overhead' },
  ];
  const Box = ({ s }: { s: (typeof steps)[number] }) => (
    <Link href={s.h} className="group relative block rounded-2xl border-2 border-teal-700/60 bg-sky-50 p-4 transition-all hover:-translate-y-0.5 hover:shadow-md dark:bg-surface">
      <span className="absolute -top-3 left-3 flex h-7 w-7 items-center justify-center rounded-full bg-slate-800 text-xs font-bold text-white">{s.n}</span>
      <p className="mt-2 text-sm font-semibold text-ink">{s.t}</p>
      <p className="mt-1 text-xs font-medium text-brand">{s.m}</p>
      <p className="mt-1 text-2xs text-muted">{s.d}</p>
    </Link>);
  return (
    <div>
      <PageHeader title="Valve ERP process flow" subtitle="Live status of the 12-stage process — click a stage to work in it" />
      <div className="grid gap-5 md:grid-cols-3 lg:grid-cols-6">{steps.slice(0, 6).map((s) => <Box key={s.n} s={s} />)}</div>
      <p className="my-3 text-center text-xs text-faint">↓ step 6 → component inspection/testing → stores → assembly → final inspection/testing → dispatch/invoicing</p>
      <div className="grid gap-5 md:grid-cols-3 lg:grid-cols-6">{[...steps.slice(6)].reverse().map((s) => <Box key={s.n} s={s} />)}</div>
      <div className="mt-8 grid gap-3 md:grid-cols-3">
        {[['Role-based access & maker-checker', '/approvals'], ['Exceptions control tower', '/exceptions'], ['Engineering change impact', '/changes'], ['Traceability: lot/serial → customer', '/traceability'], ['Interface log & safe retry', '/integrations'], ['Audit history', '/admin']].map(([t, h]) => (
          <Link key={h} href={h!} className="rounded-xl border border-line bg-surface px-4 py-3 text-sm font-medium text-ink hover:border-line-strong">{t} →</Link>))}
      </div>
    </div>
  );
}
