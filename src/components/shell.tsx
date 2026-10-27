'use client';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { useEffect, useState } from 'react';
import { Icon } from './icons';
import { Avatar } from './ui';
import { Wordmark, LogoMark } from './logo';
import { ThemeToggle } from './theme';
import { logoutAction } from '@/app/logout/actions';

const NAV: { group: string; items: { href: string; label: string; icon: string }[] }[] = [
  {
    group: 'Overview',
    items: [
      { href: '/dashboard', label: 'Dashboard', icon: 'dashboard' },
      { href: '/tasks', label: 'My Tasks', icon: 'tasks' },
    ],
  },
  {
    group: 'Sales & CRM',
    items: [
      { href: '/leads', label: 'Leads', icon: 'leads' },
      { href: '/companies', label: 'Companies', icon: 'companies' },
      { href: '/quotes', label: 'Quotations', icon: 'quote' },
      { href: '/orders', label: 'Sales Orders', icon: 'order' },
    ],
  },
  {
    group: 'Engineering',
    items: [
      { href: '/products', label: 'Products', icon: 'product' },
      { href: '/engineering', label: 'Drawings', icon: 'engineering' },
      { href: '/bom', label: 'Bills of Material', icon: 'box' },
    ],
  },
  {
    group: 'Operations',
    items: [
      { href: '/inventory', label: 'Inventory', icon: 'inventory' },
      { href: '/procurement', label: 'Procurement', icon: 'procurement' },
      { href: '/suppliers', label: 'Suppliers', icon: 'companies' },
      { href: '/production', label: 'Production', icon: 'engineering' },
      { href: '/subcontract', label: 'Subcontract', icon: 'box' },
      { href: '/assembly', label: 'Assembly & Serials', icon: 'product' },
      { href: '/projects', label: 'Projects', icon: 'projects' },
    ],
  },
  {
    group: 'Quality & Dispatch',
    items: [
      { href: '/quality', label: 'Inspections', icon: 'check' },
      { href: '/quality/tests', label: 'Valve Tests', icon: 'tasks' },
      { href: '/quality/ncr', label: 'Non-conformances', icon: 'alert' },
      { href: '/traceability', label: 'Traceability', icon: 'search' },
      { href: '/shipments', label: 'Dispatch', icon: 'procurement' },
    ],
  },
  {
    group: 'Control',
    items: [
      { href: '/process', label: 'Process Map', icon: 'trending' },
      { href: '/changes', label: 'Engineering Changes', icon: 'engineering' },
      { href: '/approvals', label: 'Approvals', icon: 'order' },
      { href: '/exceptions', label: 'Exceptions', icon: 'alert' },
      { href: '/costing', label: 'Costing', icon: 'money' },
      { href: '/integrations', label: 'Interfaces', icon: 'inbox' },
    ],
  },
  {
    group: 'Finance',
    items: [
      { href: '/invoices', label: 'Invoices', icon: 'invoice' },
      { href: '/payments', label: 'Payments', icon: 'payment' },
    ],
  },
  { group: 'System', items: [{ href: '/imports', label: 'Data Import', icon: 'inbox' }, { href: '/admin', label: 'Administration', icon: 'admin' }, { href: '/settings', label: 'Settings', icon: 'settings' }] },
];

function SidebarContent() {
  const pathname = usePathname();
  return (
    <>
      <div className="flex items-center gap-2.5 border-b border-line px-5 py-4">
        <LogoMark size={30} />
        <div className="leading-tight">
          <Wordmark size="md" />
          <p className="text-2xs tracking-wide text-faint">Operations Platform</p>
        </div>
      </div>
      <nav className="flex-1 overflow-y-auto px-3 pb-6">
        {NAV.map((g) => (
          <div key={g.group} className="mb-5">
            <p className="px-3 pb-1.5 text-2xs font-semibold uppercase tracking-wider text-faint">{g.group}</p>
            <div className="space-y-0.5">
              {g.items.map((it) => {
                const active = pathname === it.href || pathname.startsWith(it.href + '/');
                return (
                  <Link
                    key={it.href}
                    href={it.href}
                    className={`group relative flex items-center gap-2.5 rounded-lg px-3 py-2 text-sm transition-colors ${
                      active ? 'bg-brand-wash font-medium text-brand' : 'text-muted hover:bg-bg hover:text-ink'
                    }`}
                  >
                    {active && <span className="absolute left-0 top-1/2 h-5 w-0.5 -translate-y-1/2 rounded-full bg-brand" />}
                    <Icon name={it.icon} size={17} className={active ? 'text-brand' : 'text-faint group-hover:text-muted'} />
                    {it.label}
                  </Link>
                );
              })}
            </div>
          </div>
        ))}
      </nav>
    </>
  );
}

export function Shell({ userName, orgName, notifCount, children }: { userName: string; orgName: string; notifCount: number; children: React.ReactNode }) {
  const [open, setOpen] = useState(false);
  const pathname = usePathname();
  useEffect(() => { setOpen(false); }, [pathname]);
  return (
    <div className="flex min-h-screen bg-bg">
      {/* desktop sidebar */}
      <aside className="sticky top-0 hidden h-screen w-60 shrink-0 flex-col border-r border-line bg-surface md:flex">
        <SidebarContent />
      </aside>
      {/* mobile drawer */}
      {open && (
        <>
          <div className="fixed inset-0 z-40 bg-black/40 md:hidden" onClick={() => setOpen(false)} />
          <aside className="fixed inset-y-0 left-0 z-50 flex w-64 flex-col border-r border-line bg-surface shadow-lg md:hidden">
            <SidebarContent />
          </aside>
        </>
      )}

      <div className="flex min-w-0 flex-1 flex-col">
        <header className="sticky top-0 z-30 flex h-14 items-center gap-3 border-b border-line bg-surface/80 px-4 backdrop-blur-md sm:px-6">
          <button onClick={() => setOpen(true)} className="rounded-lg p-1.5 text-muted hover:bg-bg md:hidden" aria-label="Menu"><Icon name="menu" /></button>
          <form action="/search" method="get" className="relative hidden max-w-md flex-1 sm:block">
            <Icon name="search" size={16} className="pointer-events-none absolute left-3 top-1/2 -translate-y-1/2 text-faint" />
            <input name="q" placeholder="Search everything…" className="h-9 w-full rounded-lg border border-line bg-bg pl-9 pr-16 text-sm outline-none transition-colors hover:border-line-strong focus:border-brand focus:bg-surface" />
            <kbd className="pointer-events-none absolute right-2.5 top-1/2 -translate-y-1/2 rounded border border-line bg-surface px-1.5 py-0.5 text-2xs font-medium text-faint">⌘K</kbd>
          </form>
          <div className="ml-auto flex items-center gap-1.5 sm:gap-2.5">
            <span className="hidden items-center gap-1.5 rounded-lg border border-line px-2.5 py-1.5 text-xs font-medium text-muted sm:inline-flex">
              <span className="h-1.5 w-1.5 rounded-full bg-ok" />{orgName}
            </span>
            <ThemeToggle />
            <Link href="/settings" className="hidden rounded-lg p-2 text-muted transition-colors hover:bg-bg hover:text-ink sm:inline-flex" aria-label="Settings"><Icon name="settings" size={18} /></Link>
            <Link href="/notifications" className="relative rounded-lg p-2 text-muted transition-colors hover:bg-bg hover:text-ink" aria-label="Notifications">
              <Icon name="bell" size={18} />
              {notifCount > 0 && <span className="absolute right-1 top-1 flex h-4 min-w-4 items-center justify-center rounded-full bg-danger px-1 text-2xs font-bold text-white ring-2 ring-surface">{notifCount > 9 ? '9+' : notifCount}</span>}
            </Link>
            <div className="flex items-center gap-2 rounded-lg py-1 pl-1 pr-1">
              <Avatar name={userName} size={30} />
              <span className="hidden text-sm font-medium text-ink lg:inline">{userName}</span>
            </div>
            {/* POST, never a <Link> — a GET logout gets fired by link prefetching. */}
            <form action={logoutAction}>
              <button type="submit" className="flex rounded-lg p-2 text-muted transition-colors hover:bg-danger-wash hover:text-danger" aria-label="Sign out"><Icon name="logout" size={18} /></button>
            </form>
          </div>
        </header>
        <main className="mx-auto w-full max-w-[1400px] flex-1 px-4 py-6 sm:px-6 lg:px-8">
          <div className="animate-in">{children}</div>
        </main>
      </div>
    </div>
  );
}
