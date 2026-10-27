import Link from 'next/link';
import { requireUser } from '@/server/auth/action';
import { query, one } from '@/server/db';
import { Card, CardHeader, StatTile, StatusPill, Table, Th, Td, PageHeader, EmptyState, Button } from '@/components/ui';
import { Icon } from '@/components/icons';
import { formatMoney } from '@/lib/money';
import { fromNow } from '@/lib/format';

export default async function DashboardPage() {
  const user = await requireUser();
  const org = user.currentOrgId;
  const hour = new Date().getHours();
  const greeting = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';

  const [leads, openOrders, shortages, overdueInv, activeProjects, receivable] = await Promise.all([
    one<{ n: string }>(`select count(*)::text n from leads where org_id=$1 and status not in ('WON','LOST')`, [org]),
    one<{ n: string }>(`select count(*)::text n from sales_orders where org_id=$1 and status not in ('CLOSED','CANCELLED')`, [org]),
    one<{ n: string }>(`select count(*)::text n from material_requirements where org_id=$1 and shortage_qty>0 and status='OPEN'`, [org]),
    one<{ n: string }>(`select count(*)::text n from invoices where org_id=$1 and status in ('ISSUED','PARTIALLY_PAID','OVERDUE') and due_date < current_date`, [org]),
    one<{ n: string }>(`select count(*)::text n from projects where org_id=$1 and status not in ('CLOSED')`, [org]),
    one<{ s: string }>(`select coalesce(sum(grand_total - paid_amount),0)::text s from invoices where org_id=$1 and status in ('ISSUED','PARTIALLY_PAID','OVERDUE')`, [org]),
  ]);

  const recentLeads = await query<{ id: string; lead_number: string; company_name: string; status: string; created_at: Date; owner: string | null }>(
    `select l.id, l.lead_number, l.company_name, l.status, l.created_at, u.name owner
     from leads l left join users u on u.id = l.owner_id where l.org_id=$1 order by l.created_at desc limit 6`, [org]);

  const [uncontacted, quotesFollowup, drawApprovals, delayedProj] = await Promise.all([
    query(`select id, lead_number n, company_name label from leads where org_id=$1 and status='NEW' order by created_at limit 6`, [org]),
    query(`select id, quote_number n, '' label from quotations where org_id=$1 and status='SENT' order by created_at limit 6`, [org]),
    query(`select id, drawing_number n, title label from drawings where org_id=$1 and status in ('REVIEW','INTERNAL_APPROVAL','CUSTOMER_APPROVAL') limit 6`, [org]),
    query(`select id, project_number n, name label from projects where org_id=$1 and end_date < current_date and status not in ('CLOSED') limit 6`, [org]),
  ]);
  const attention = [
    { label: 'Leads not contacted', icon: 'leads', base: '/leads/', items: uncontacted as any[] },
    { label: 'Quotes awaiting follow-up', icon: 'quote', base: '/quotes/', items: quotesFollowup as any[] },
    { label: 'Drawings pending approval', icon: 'engineering', base: '/engineering/', items: drawApprovals as any[] },
    { label: 'Delayed projects', icon: 'projects', base: '/projects/', items: delayedProj as any[] },
  ];
  const attentionTotal = attention.reduce((a, x) => a + x.items.length, 0);

  return (
    <div>
      <PageHeader
        title={`${greeting}, ${user.name.split(' ')[0]}`}
        subtitle="Here's what needs your attention across the business today."
        action={<><Button href="/leads/new" variant="ghost" icon="plus" size="sm">Lead</Button><Button href="/quotes/new" icon="plus" size="sm">Quotation</Button></>}
      />

      <div className="grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-6">
        <StatTile label="Open leads" value={leads?.n ?? '0'} icon="leads" href="/leads" />
        <StatTile label="Active orders" value={openOrders?.n ?? '0'} icon="order" href="/orders" />
        <StatTile label="Shortages" value={shortages?.n ?? '0'} icon="alert" tone={Number(shortages?.n) > 0 ? 'warn' : 'ok'} href="/inventory" />
        <StatTile label="Overdue invoices" value={overdueInv?.n ?? '0'} icon="clock" tone={Number(overdueInv?.n) > 0 ? 'danger' : 'ok'} href="/invoices" />
        <StatTile label="Active projects" value={activeProjects?.n ?? '0'} icon="projects" href="/projects" />
        <StatTile label="Receivables" value={formatMoney(receivable?.s ?? 0)} icon="money" tone="brand" href="/invoices" />
      </div>

      <div className="mt-5 grid gap-5 lg:grid-cols-5">
        {/* Attention required — wider */}
        <div className="lg:col-span-3">
          <Card>
            <CardHeader
              title={<span className="flex items-center gap-2">Attention Required {attentionTotal > 0 && <span className="rounded-md bg-danger-wash px-1.5 py-0.5 text-2xs font-bold text-danger">{attentionTotal}</span>}</span>}
              subtitle="Actionable items — click any row to jump straight to the record"
            />
            {attentionTotal === 0 ? (
              <EmptyState icon="check" title="You're all caught up" hint="Nothing needs your attention right now." />
            ) : (
              <div className="divide-y divide-line">
                {attention.filter((a) => a.items.length > 0).map((a) => (
                  <div key={a.label} className="px-5 py-4">
                    <p className="mb-2 flex items-center gap-2 text-xs font-semibold text-muted">
                      <Icon name={a.icon} size={14} className="text-faint" />{a.label}
                      <span className="rounded bg-bg px-1.5 py-0.5 text-2xs text-muted">{a.items.length}</span>
                    </p>
                    <ul className="space-y-0.5">
                      {a.items.slice(0, 4).map((it) => (
                        <li key={it.id}>
                          <Link href={a.base + it.id} className="group -mx-2 flex items-center justify-between rounded-lg px-2 py-1.5 text-sm hover:bg-bg">
                            <span className="truncate"><span className="font-mono text-xs font-medium text-brand">{it.n}</span>{it.label && <span className="text-muted"> · {it.label}</span>}</span>
                            <Icon name="arrowRight" size={14} className="shrink-0 text-faint opacity-0 transition-opacity group-hover:opacity-100" />
                          </Link>
                        </li>
                      ))}
                    </ul>
                  </div>
                ))}
              </div>
            )}
          </Card>
        </div>

        {/* Recent leads */}
        <div className="lg:col-span-2">
          <Card>
            <CardHeader title="Recent Leads" subtitle="Latest incoming demand" action={<Link href="/leads" className="text-xs font-medium text-brand hover:underline">View all</Link>} />
            {recentLeads.length === 0 ? (
              <EmptyState icon="leads" title="No leads yet" hint="Leads from the website or manual entry appear here." />
            ) : (
              <div className="divide-y divide-line">
                {recentLeads.map((l) => (
                  <Link key={l.id} href={`/leads/${l.id}`} className="flex items-center justify-between gap-2 px-5 py-3 hover:bg-bg">
                    <div className="min-w-0">
                      <p className="truncate text-sm font-medium text-ink">{l.company_name}</p>
                      <p className="text-xs text-faint">{l.lead_number} · {fromNow(l.created_at)}</p>
                    </div>
                    <StatusPill status={l.status} />
                  </Link>
                ))}
              </div>
            )}
          </Card>
        </div>
      </div>
    </div>
  );
}
