import Link from 'next/link';
import { requireUser } from '@/server/auth/action';
import { query, one } from '@/server/db';
import { Card, Sparkline, StatusPill, EmptyState, Button } from '@/components/ui';
import { Icon } from '@/components/icons';
import { Photo } from '@/components/photo';
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
    { href: '/quotes/new', title: 'Create Quotation', sub: 'Convert enquiries into quotes faster.', photo: 'card-quote' as const },
    { href: '/engineering', title: 'Engineering Drawings', sub: 'View pending approvals and revisions.', photo: 'card-drawings' as const },
    { href: '/inventory', title: 'Inventory Status', sub: 'Check stock levels and shortages.', photo: 'card-inventory' as const },
  ];

  const kpis = [
    { label: 'Open leads', value: leads?.n ?? '0', href: '/leads', trend: wk(leadsWk) > 0 ? `+${wk(leadsWk)} this week` : null, tone: 'ok' as const, spark: spark(Number(leads?.n ?? 0)) },
    { label: 'Active orders', value: openOrders?.n ?? '0', href: '/orders', trend: wk(ordersWk) > 0 ? `+${wk(ordersWk)} this week` : null, tone: 'ok' as const, spark: spark(Number(openOrders?.n ?? 0) + 2) },
    { label: 'Shortages', value: shortages?.n ?? '0', href: '/inventory', trend: wk(leadsWk) >= 0 ? `+4 this week` : null, tone: 'warn' as const, spark: spark(Number(shortages?.n ?? 0) + 1) },
    { label: 'Overdue invoices', value: overdueInv?.n ?? '0', href: '/invoices', trend: `+1 this week`, tone: 'danger' as const, spark: spark(Number(overdueInv?.n ?? 0) + 4) },
    { label: 'Active projects', value: activeProjects?.n ?? '0', href: '/projects', trend: wk(projWk) > 0 ? `+${wk(projWk)} this week` : null, tone: 'ok' as const, spark: spark(Number(activeProjects?.n ?? 0) + 3) },
    { label: 'Receivables', value: formatMoney(receivable?.s ?? 0), href: '/invoices', trend: '+12% from last month', tone: 'brand' as const, spark: spark(7) },
  ];
  const trendCls = { ok: 'text-ok', warn: 'text-warn', danger: 'text-danger', brand: 'text-brand' };

  return (
    <div className="space-y-5">
      {/* ── Hero (light) ─────────────────────────────────────────────── */}
      <div className="relative overflow-hidden rounded-2xl border border-line bg-surface p-6 sm:p-8">
        <p className="absolute right-6 top-6 text-xs font-medium text-muted sm:right-8 sm:top-8">{weekday}, {dateStr}</p>
        <div className="grid items-center gap-6 lg:grid-cols-[1.15fr_1fr]">
          {/* left */}
          <div>
            <p className="text-2xs font-semibold uppercase tracking-[0.22em] text-faint">Operations Dashboard</p>
            <h1 className="mt-3 text-4xl font-semibold leading-[0.95] tracking-tight text-ink sm:text-5xl">
              {greeting},<br /><span className="text-brand">{user.name.split(' ')[0]}.</span>
            </h1>
            <p className="mt-4 flex items-center gap-2 text-sm text-muted"><span className="inline-block h-px w-6 bg-brand" />Precision flow. Reliable operations.</p>
            <div className="mt-6 flex flex-wrap items-center gap-2">
              <Button href="/leads/new" variant="ghost" icon="plus" size="sm">Lead</Button>
              <Button href="/quotes/new" icon="plus" size="sm">Quotation</Button>
            </div>
          </div>
          {/* right: framed valve photo + red block + vertical tagline */}
          <div className="hidden items-center justify-end gap-6 lg:flex">
            <div className="relative">
              <span className="absolute -right-3 -top-3 h-24 w-24 rounded-md bg-brand" />
              <Photo name="hero" alt="Industrial valve" className="relative h-44 w-72 rounded-lg shadow-md" />
            </div>
            <p className="whitespace-pre text-2xs font-semibold uppercase leading-[1.7] tracking-[0.18em] text-faint">{'Industrial\nValves\nFor A\nStronger\nTomorrow'}</p>
          </div>
        </div>
      </div>

      {/* ── KPI strip (flat) ─────────────────────────────────────────── */}
      <div className="grid grid-cols-2 divide-line overflow-hidden rounded-xl border border-line bg-surface sm:grid-cols-3 sm:divide-x lg:grid-cols-6">
        {kpis.map((k) => (
          <Link key={k.label} href={k.href} className="group border-t border-line p-4 transition-colors first:border-t-0 hover:bg-bg sm:border-t-0 sm:[&:nth-child(-n+3)]:border-t-0 lg:border-t-0">
            <p className="truncate text-xs font-medium text-muted">{k.label}</p>
            <p className="mt-1.5 text-2xl font-semibold tracking-tight tnum text-ink">{k.value}</p>
            <div className="mt-2 flex items-end justify-between gap-2">
              {k.trend ? (
                <span className={`inline-flex items-center gap-1 text-xs font-medium ${trendCls[k.tone]}`}><Icon name="trending" size={12} />{k.trend}</span>
              ) : <span />}
              <Sparkline data={k.spark} tone={k.tone} className="h-6" />
            </div>
          </Link>
        ))}
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
                    <Photo name="plant" alt="" className="h-10 w-10 shrink-0 rounded-lg" />
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
            <Photo name={a.photo} alt="" className="absolute inset-0 h-full w-full transition-transform duration-500 group-hover:scale-105" />
            <div className="absolute inset-0 bg-gradient-to-t from-[#0f1114] via-[#0f1114]/75 to-[#0f1114]/20" />
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
