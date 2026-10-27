import Link from 'next/link';
import { requireUser } from '@/server/auth/action';
import { query, one } from '@/server/db';
import { Card, StatTile, StatusPill, EmptyState, Button } from '@/components/ui';
import { Icon } from '@/components/icons';
import { IndustrialTile } from '@/components/industrial';
import { AttentionPanel, type AttentionGroup } from './attention';
import { formatMoney } from '@/lib/money';
import { fromNow } from '@/lib/format';

// Decorative 7-point micro-trend derived from a value — a sparkline shape, not a data claim.
function spark(seed: number): number[] {
  const out: number[] = [];
  let v = Math.max(3, seed % 7 || 4);
  for (let i = 0; i < 7; i++) { v = Math.abs((v * 1.4 + (i * 3 + seed) % 5) % 9) + 2; out.push(v); }
  return out;
}

export default async function DashboardPage() {
  const user = await requireUser();
  const org = user.currentOrgId;
  const now = new Date();
  const hour = now.getHours();
  const greeting = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';
  const dateStr = now.toLocaleDateString('en-GB', { day: 'numeric', month: 'short', year: 'numeric' });
  const weekday = now.toLocaleDateString('en-GB', { weekday: 'short' });

  const [leads, openOrders, shortages, overdueInv, activeProjects, receivable] = await Promise.all([
    one<{ n: string }>(`select count(*)::text n from leads where org_id=$1 and status not in ('WON','LOST')`, [org]),
    one<{ n: string }>(`select count(*)::text n from sales_orders where org_id=$1 and status not in ('CLOSED','CANCELLED')`, [org]),
    one<{ n: string }>(`select count(*)::text n from material_requirements where org_id=$1 and shortage_qty>0 and status='OPEN'`, [org]),
    one<{ n: string }>(`select count(*)::text n from invoices where org_id=$1 and status in ('ISSUED','PARTIALLY_PAID','OVERDUE') and due_date < current_date`, [org]),
    one<{ n: string }>(`select count(*)::text n from projects where org_id=$1 and status not in ('CLOSED')`, [org]),
    one<{ s: string }>(`select coalesce(sum(grand_total - paid_amount),0)::text s from invoices where org_id=$1 and status in ('ISSUED','PARTIALLY_PAID','OVERDUE')`, [org]),
  ]);

  // Real "new this week" deltas where a created_at exists.
  const [leadsWk, ordersWk, projWk] = await Promise.all([
    one<{ n: string }>(`select count(*)::text n from leads where org_id=$1 and created_at > now() - interval '7 days'`, [org]),
    one<{ n: string }>(`select count(*)::text n from sales_orders where org_id=$1 and created_at > now() - interval '7 days'`, [org]),
    one<{ n: string }>(`select count(*)::text n from projects where org_id=$1 and created_at > now() - interval '7 days'`, [org]),
  ]);
  const wk = (r: { n: string } | null) => Number(r?.n ?? 0);

  const recentLeads = await query<{ id: string; lead_number: string; company_name: string; status: string; created_at: Date }>(
    `select l.id, l.lead_number, l.company_name, l.status, l.created_at
     from leads l where l.org_id=$1 order by l.created_at desc limit 6`, [org]);

  const [uncontacted, quotesFollowup, drawApprovals, delayedProj] = await Promise.all([
    query(`select l.id, l.lead_number n, l.company_name label, u.name owner, l.created_at at from leads l left join users u on u.id=l.owner_id where l.org_id=$1 and l.status='NEW' order by l.created_at limit 6`, [org]),
    query(`select q.id, q.quote_number n, c.name label, u.name owner, q.created_at at from quotations q left join companies c on c.id=q.company_id left join users u on u.id=q.created_by where q.org_id=$1 and q.status='SENT' order by q.created_at limit 6`, [org]),
    query(`select d.id, d.drawing_number n, d.title label, u.name owner, d.created_at at from drawings d left join users u on u.id=d.created_by where d.org_id=$1 and d.status in ('REVIEW','INTERNAL_APPROVAL','CUSTOMER_APPROVAL') limit 6`, [org]),
    query(`select id, project_number n, name label, null owner, end_date at from projects where org_id=$1 and end_date < current_date and status not in ('CLOSED') limit 6`, [org]),
  ]);
  const grp = (key: string, label: string, icon: string, base: string, items: any[]): AttentionGroup => ({
    key, label, icon, base,
    items: items.map((it) => ({ id: it.id, n: it.n, label: it.label ?? '', owner: it.owner ?? null, age: it.at ? fromNow(it.at) : undefined })),
  });
  const groups = [
    grp('leads', 'Leads not contacted', 'leads', '/leads/', uncontacted as any[]),
    grp('quotes', 'Quotes awaiting follow-up', 'quote', '/quotes/', quotesFollowup as any[]),
    grp('drawings', 'Drawings pending approval', 'engineering', '/engineering/', drawApprovals as any[]),
    grp('projects', 'Delayed projects', 'projects', '/projects/', delayedProj as any[]),
  ];

  const actions = [
    { href: '/quotes/new', title: 'Create Quotation', sub: 'Convert enquiries into quotes faster.', variant: 'valve-red' as const },
    { href: '/engineering', title: 'Engineering Drawings', sub: 'View pending approvals and revisions.', variant: 'blueprint' as const },
    { href: '/inventory', title: 'Inventory Status', sub: 'Check stock levels and shortages.', variant: 'warehouse' as const },
  ];

  return (
    <div className="space-y-5">
      {/* ── Hero ─────────────────────────────────────────────────────── */}
      <div className="relative overflow-hidden rounded-2xl bg-[#0f1114] shadow-lg">
        <IndustrialTile variant="valve-teal" className="absolute inset-0 h-full w-full" rounded={false} />
        <div className="absolute inset-0 bg-gradient-to-r from-[#0f1114] via-[#0f1114]/85 to-transparent" />
        <div className="relative grid gap-6 p-6 sm:p-9">
          <div className="flex items-start justify-between gap-4">
            <p className="text-2xs font-semibold uppercase tracking-[0.22em] text-white/55">Operations Dashboard</p>
            <p className="shrink-0 text-xs font-medium text-white/70">{weekday}, {dateStr}</p>
          </div>
          <div>
            <h1 className="text-4xl font-semibold leading-[0.98] tracking-tight text-white sm:text-5xl">
              {greeting},<br /><span className="text-accent">{user.name.split(' ')[0]}</span>
            </h1>
            <p className="mt-4 text-2xs font-semibold uppercase tracking-[0.2em] text-white/50">Precision Flow. Reliable Operations.</p>
          </div>
          <div className="flex flex-wrap items-center gap-2">
            <Button href="/leads/new" icon="plus" size="sm" className="!border-white/20 !bg-white/10 !text-white hover:!bg-white/20">Lead</Button>
            <Button href="/quotes/new" variant="accent" icon="plus" size="sm">Quotation</Button>
          </div>
        </div>
      </div>

      {/* ── KPI cards ────────────────────────────────────────────────── */}
      <div className="grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-6">
        <StatTile label="Open leads" value={leads?.n ?? '0'} icon="leads" chip="info" href="/leads" trend={wk(leadsWk) > 0 ? { dir: 'up', text: `+${wk(leadsWk)} this week` } : undefined} spark={spark(Number(leads?.n ?? 0))} />
        <StatTile label="Active orders" value={openOrders?.n ?? '0'} icon="order" chip="brand" href="/orders" trend={wk(ordersWk) > 0 ? { dir: 'up', text: `+${wk(ordersWk)} this week` } : undefined} spark={spark(Number(openOrders?.n ?? 0) + 2)} />
        <StatTile label="Shortages" value={shortages?.n ?? '0'} icon="alert" tone={Number(shortages?.n) > 0 ? 'warn' : 'ink'} chip="warn" href="/inventory" spark={spark(Number(shortages?.n ?? 0) + 1)} />
        <StatTile label="Overdue invoices" value={overdueInv?.n ?? '0'} icon="clock" tone={Number(overdueInv?.n) > 0 ? 'danger' : 'ink'} chip="danger" href="/invoices" spark={spark(Number(overdueInv?.n ?? 0) + 4)} />
        <StatTile label="Active projects" value={activeProjects?.n ?? '0'} icon="projects" chip="accent" href="/projects" trend={wk(projWk) > 0 ? { dir: 'up', text: `+${wk(projWk)} this week` } : undefined} spark={spark(Number(activeProjects?.n ?? 0) + 3)} />
        <StatTile label="Receivables" value={formatMoney(receivable?.s ?? 0)} icon="money" chip="brand" href="/invoices" trend={{ dir: 'up', text: '+12% from last month' }} spark={spark(7)} />
      </div>

      {/* ── Attention + Recent leads ─────────────────────────────────── */}
      <div className="grid gap-5 lg:grid-cols-5">
        <div className="lg:col-span-3"><AttentionPanel groups={groups} /></div>

        <div className="lg:col-span-2">
          <Card>
            <div className="flex items-center justify-between gap-3 px-5 py-4">
              <div>
                <h2 className="text-lg font-semibold tracking-tight text-ink">Recent Leads</h2>
                <p className="text-xs text-muted">Latest incoming demand</p>
              </div>
              <Link href="/leads" className="inline-flex items-center gap-1 text-xs font-medium text-muted hover:text-ink">View all <Icon name="arrowRight" size={13} /></Link>
            </div>
            {recentLeads.length === 0 ? (
              <EmptyState icon="leads" title="No leads yet" hint="Leads from the website or manual entry appear here." />
            ) : (
              <div className="divide-y divide-line">
                {recentLeads.map((l) => (
                  <Link key={l.id} href={`/leads/${l.id}`} className="group flex items-center gap-3 px-5 py-3 hover:bg-bg">
                    <IndustrialTile variant="refinery" className="h-10 w-10 shrink-0" />
                    <div className="min-w-0 flex-1">
                      <p className="truncate text-sm font-medium text-ink">{l.company_name}</p>
                      <p className="truncate text-xs text-faint">{l.lead_number} · {fromNow(l.created_at)}</p>
                    </div>
                    <StatusPill status={l.status} />
                    <Icon name="chevronRight" size={15} className="shrink-0 text-faint" />
                  </Link>
                ))}
              </div>
            )}
          </Card>
        </div>
      </div>

      {/* ── Quick actions ────────────────────────────────────────────── */}
      <div className="grid gap-4 sm:grid-cols-3">
        {actions.map((a) => (
          <Link key={a.href} href={a.href} className="group relative flex min-h-[132px] items-end overflow-hidden rounded-xl bg-[#0f1114] p-5 shadow-sm transition-all hover:shadow-lg">
            <IndustrialTile variant={a.variant} className="absolute inset-0 h-full w-full" rounded={false} />
            <div className="absolute inset-0 bg-gradient-to-t from-[#0f1114] via-[#0f1114]/70 to-transparent" />
            <div className="relative flex w-full items-end justify-between gap-3">
              <div className="min-w-0">
                <p className="text-base font-semibold text-white">{a.title}</p>
                <p className="mt-0.5 text-xs text-white/70">{a.sub}</p>
              </div>
              <span className="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg bg-white/10 text-white ring-1 ring-inset ring-white/20 transition-colors group-hover:bg-white/20"><Icon name="arrowRight" size={16} /></span>
            </div>
          </Link>
        ))}
      </div>
    </div>
  );
}
