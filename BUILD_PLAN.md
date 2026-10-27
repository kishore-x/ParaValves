# PARAVALVES PLATFORM — COMPLETE BUILD PLAN

**Unified ERP + CRM + Engineering + Inventory + Procurement + Projects + Finance**

| | |
|---|---|
| **Document** | Master build plan / engineering specification |
| **Repo** | `D:\Paravalves` |
| **Date** | 2026-09-01 |
| **Status** | Phase 0 scaffolding in place; implementation not started |
| **Target** | Production-grade internal business system replacing Holded / Zoho / Excel |

---

## 0. EXECUTIVE SUMMARY

Build one system in which the entire Paravalves business lifecycle shares a single relational
source of truth:

```
WEBSITE INQUIRY → LEAD → COMPANY/CONTACT → OPPORTUNITY → QUOTATION → SALES ORDER
  → ENGINEERING → PART NUMBER → DRAWING → APPROVAL → BOM → MATERIAL REQUIREMENT
  → INVENTORY CHECK → PROCUREMENT → PO → GOODS RECEIPT → STOCK → PROJECT EXECUTION
  → QC → DELIVERY → TAX INVOICE → PAYMENT → VERIFICATION → CLOSURE
```

Every stage reads data written by the previous stage. No re-keying. No parallel Excel.

**Realistic sizing.** This is ~60 database tables, ~120 API routes, ~55 screens, ~350 source
files. It is a 16-phase programme, not a single pass. Phases 0–9 produce a system Paravalves
can genuinely start operating on; Phases 10–16 make it production-hardened.

---

## 1. TECHNOLOGY DECISIONS (ADR SUMMARY)

| Concern | Decision | Rationale |
|---|---|---|
| App framework | **Next.js 15 (App Router) + React 19 + TypeScript strict** | One deployable unit for UI + API; server components keep data server-side; mature, hireable stack. |
| Language config | `strict: true`, `noUncheckedIndexedAccess: true` | Catch nullability/index bugs at compile time. |
| Database | **PostgreSQL 16** | Transactions, row locking, `numeric`, partial/GIN indexes, `SERIALIZABLE` where needed. Non-negotiable for stock + money. |
| DB access | **Drizzle ORM** (typed queries) + **hand-written SQL migrations** | Typed queries without ORM magic; SQL migrations give exact control of constraints, triggers, functions. Schema TS mirrors SQL; drift test enforces parity. |
| Migrations | Ordered `.sql` files + `schema_migrations` table + custom runner | Reproducible, reviewable, works on any managed Postgres. |
| Auth | **Custom session auth**: `node:crypto` scrypt hashing, opaque session token in `HttpOnly; SameSite=Lax; Secure` cookie, server-side `sessions` table | No third-party auth dependency; full control of revocation, idle timeout, audit. Zero native deps (Windows-friendly). |
| Authorization | Permission codes + role→permission mapping, resolved server-side per request; org scoping on **every** query | Least privilege; UI hiding is cosmetic only. |
| Validation | **Zod** schemas shared by forms + API + importers | One definition, three consumers. |
| Money | **decimal.js** in app, `numeric(18,4)` / `numeric(18,2)` in DB | Never floats for money. Server recomputes all totals. |
| Background jobs | **Postgres-backed queue** (`jobs` table, `FOR UPDATE SKIP LOCKED`) + `worker` process | No Redis dependency; retries, backoff, DLQ, idempotency keys. |
| Files | Storage abstraction (`LocalDiskDriver` now, `S3Driver` interface ready); access **only** via authorized route with short-lived HMAC token | No public bucket URLs for private documents. |
| Email | Abstraction (`LogDriver` dev / `SmtpDriver` prod via nodemailer) + `email_log` table | Templated, configurable, auditable. |
| PDF | `pdfkit` server-side, generated in a job for heavy documents | No headless-browser dependency. |
| Styling | **Tailwind CSS** + hand-built component primitives | Consistent enterprise look; no bloated UI kit. |
| Tests | **Vitest** (unit/integration/API) + **Playwright** (E2E) | Fast unit loop, real browser for critical journeys. |
| Dev DB | **Docker Compose** Postgres on port `55432` | Isolated from the developer's existing local Postgres; reproducible. |

**Rejected:** Prisma (migration control too coarse for triggers/locks), NextAuth (opaque session
control), Redis/BullMQ (extra infra for a single-site ERP), Supabase-hosted-only (must run
on-prem/any Postgres), float money (correctness).

---

## 2. REPOSITORY LAYOUT

```
D:\Paravalves\
├── docker-compose.yml            # dev Postgres (port 55432)
├── .env.example / .env           # env contract; .env is gitignored
├── next.config.mjs               # security headers + CSP
├── migrations/                   # 0001_*.sql … ordered, immutable once merged
├── scripts/
│   ├── migrate.ts  seed.ts  reset.ts  verify-db.ts  worker.ts
├── src/
│   ├── app/
│   │   ├── (auth)/login, logout
│   │   ├── (app)/                # authenticated shell: sidebar, org switcher, search
│   │   │   ├── dashboard/  crm/  quotes/  orders/  products/  engineering/
│   │   │   ├── inventory/  procurement/  projects/  tasks/  finance/
│   │   │   ├── reports/  documents/  admin/  search/
│   │   └── api/                  # route handlers (see §7)
│   ├── server/
│   │   ├── db/          client.ts, schema/*.ts, tx.ts
│   │   ├── auth/        password.ts, session.ts, rbac.ts, guard.ts
│   │   ├── http/        handler.ts (auth+zod+error+audit wrapper), errors.ts, ratelimit.ts
│   │   ├── numbering/   engine.ts
│   │   ├── workflow/    machines.ts, gates.ts, transition.ts
│   │   ├── domain/      crm/ sales/ product/ engineering/ inventory/
│   │   │                mrp/ procurement/ projects/ finance/ imports/
│   │   ├── audit/       jobs/ files/ mail/ tax/ money/ search/ automation/
│   ├── lib/             zod schemas, formatting, date/tz, constants
│   └── components/      ui/ (primitives), data/ (table, filters), charts/, forms/
├── tests/
│   ├── unit/  integration/  api/  workflow/  security/  concurrency/  e2e/
└── docs/                # architecture, db, api, runbooks, business rules
```

**Layering rule:** `app/` may call `server/domain/*`. `server/domain/*` may call
`server/db`, `numbering`, `audit`, `jobs`, `workflow`. Nothing in `app/` touches `db` directly.
No business rule lives in a React component.

---

## 3. DATABASE DESIGN

### 3.1 Universal column contract

Every business entity carries:
`id uuid pk default gen_random_uuid()`, `org_id uuid not null fk`, human-readable
`*_number` unique per org, `status`, `created_at timestamptz not null default now()`,
`updated_at timestamptz not null`, `created_by uuid`, `updated_by uuid`,
`version integer not null default 1` (optimistic concurrency).

`updated_at` and `version` are maintained by a shared `touch_row()` trigger — never by app code.

### 3.2 Table inventory (~60 tables)

**Platform / security (12)**
`organizations` · `users` · `roles` · `permissions` · `role_permissions` · `user_roles` ·
`user_organizations` · `sessions` · `audit_logs` · `settings` · `number_sequences` · `rate_limits`

**Shared services (9)**
`files` · `documents` · `activities` · `notifications` · `tasks` · `jobs` · `email_log` ·
`status_transitions` · `automation_events`

**CRM (4)**
`companies` · `contacts` · `leads` · `inquiry_submissions`

**Product & engineering (10)**
`product_categories` · `products` · `part_number_rules` · `part_numbers` · `boms` · `bom_lines` ·
`drawings` · `drawing_revisions` · `drawing_comments` · `engineering_requests`

**Sales (4)**
`quotations` · `quotation_lines` · `sales_orders` · `sales_order_lines`

**Inventory (5)**
`warehouses` · `stock_items` · `stock_movements` · `stock_reservations` · `material_requirements`

**Procurement (6)**
`purchase_requests` · `purchase_request_lines` · `purchase_orders` · `purchase_order_lines` ·
`goods_receipts` · `goods_receipt_lines`

**Projects (3)**
`projects` · `project_tasks` · `project_members`

**Finance (10)**
`tax_rates` · `invoices` · `invoice_lines` · `payments` · `payment_allocations` · `bills` ·
`expenses` · `chart_of_accounts` · `journal_entries` · `journal_lines`

**Migration (1)** `import_batches`

### 3.3 Key relationships (ERD in text)

```
organizations 1─* users(via user_organizations) 1─* sessions
organizations 1─* companies 1─* contacts
companies 1─* leads ──converts──> companies (converted_company_id)
leads 1─* quotations 1─* quotation_lines
quotations ──converts──> sales_orders 1─* sales_order_lines
sales_orders 1─1 projects 1─* project_tasks
sales_orders 1─* engineering_requests 1─* drawings 1─* drawing_revisions
products 1─* boms 1─* bom_lines *─1 products (component)
sales_order_lines 1─* material_requirements *─1 products
products *─* warehouses  via stock_items
stock_items ←── stock_movements (append-only ledger)
sales_order_lines 1─* stock_reservations
material_requirements 1─* purchase_request_lines → purchase_order_lines
purchase_orders 1─* goods_receipts 1─* goods_receipt_lines → stock_movements
sales_orders 1─* invoices 1─* invoice_lines
invoices *─* payments via payment_allocations
ANY entity 1─* documents / activities / audit_logs / tasks (polymorphic entity_type+entity_id)
```

### 3.4 Integrity rules encoded in the database

| Rule | Mechanism |
|---|---|
| No duplicate business numbers | `unique (org_id, lead_number)` etc. on every document number |
| No negative stock | `check (on_hand >= 0 and reserved >= 0 and reserved <= on_hand)` on `stock_items` |
| No over-reservation | reservation service takes `SELECT … FOR UPDATE` on the `stock_items` row inside a transaction |
| No orphan lines | `on delete cascade` header→lines; `on delete restrict` on all master-data FKs |
| Money sanity | `check (grand_total >= 0)`, `check (paid_amount <= grand_total + tolerance)` on invoices |
| Quantities | `check (quantity > 0)`, `check (accepted_qty + rejected_qty + damaged_qty <= received_qty)` |
| Audit immutability | `BEFORE UPDATE OR DELETE ON audit_logs` trigger raises exception |
| Drawing history | `drawing_revisions` insert-only; a new revision never updates the old row |
| Stock ledger | `stock_movements` insert-only; `balance_after` written in the same transaction as the `stock_items` update |
| Concurrency | `version` column + `WHERE version = $expected`; a 0-row update ⇒ `409 CONFLICT` |
| Soft delete | Only where audit/business demands: `companies`, `products`, `users` (`archived_at`). Documents never hard-deleted. |

### 3.5 Indexing strategy

- Every FK gets an index.
- Every list screen's default sort+filter gets a composite index, e.g.
  `(org_id, status, created_at desc)` on `leads`, `sales_orders`, `invoices`.
- Global search: `GIN` on a generated `tsvector` per searchable table + `pg_trgm` on
  `*_number` for prefix/fuzzy code lookup.
- Ledger reads: `(org_id, product_id, warehouse_id, created_at desc)` on `stock_movements`.
- Dashboards: partial indexes, e.g. `where status not in ('CLOSED','CANCELLED')`.
- **No blanket indexing** — each index exists because a measured query plan needs it (§14).

---

## 4. CROSS-CUTTING ENGINES

### 4.1 Numbering engine (`server/numbering/engine.ts`)

Configurable per org + document type in `number_sequences`
(`prefix`, `pattern`, `padding`, `reset_policy: never|yearly|monthly`, `current_value`, `period_key`).

Concurrency-safe by construction:

```sql
INSERT INTO number_sequences (org_id, doc_type, period_key, current_value)
VALUES ($1,$2,$3,1)
ON CONFLICT (org_id, doc_type, period_key)
DO UPDATE SET current_value = number_sequences.current_value + 1
RETURNING current_value, prefix, padding, pattern;
```

One atomic statement — two concurrent users can never receive the same number. Called **inside**
the caller's transaction. Gaps are acceptable and documented; duplicates are not.

Covers: LEAD, QUO, SO, PO, PR, PROJ, INV, CN, DN, GRN, MR, DRW, PART, CUST, SUPP, EXP, TASK, ER.
Output e.g. `SO-2026-000012`.

### 4.2 Part number engine (`server/domain/product/part-number.ts`)

Rules live in `part_number_rules` as an ordered segment list, not in code:

```json
{ "pattern": "{family}-{type}-{size}-{material}-{config}-R{revision}",
  "segments": [
    {"key":"family","source":"attribute","width":3,"required":true},
    {"key":"size","source":"attribute","transform":"pad2"},
    {"key":"material","source":"lookup","table":"material_codes"},
    {"key":"revision","source":"revision","width":2}
  ] }
```

Guarantees: deterministic generation → `unique (org_id, part_number)` → collision returns a
typed `PartNumberCollisionError` (never a silent overwrite) → revision bump creates a **new**
row, old row retained → full `audit_logs` entry → searchable.

### 4.3 Workflow / state machines (`server/workflow/machines.ts`)

Every stateful entity declares `{ from → allowed[] }` plus per-transition guards.

```
LEAD    NEW→CONTACTED→QUALIFIED→MEETING→QUOTATION→NEGOTIATION→WON|LOST
QUOTE   DRAFT→INTERNAL_REVIEW→APPROVED→SENT→VIEWED→NEGOTIATION→ACCEPTED|REJECTED|EXPIRED
ORDER   CONFIRMED→ENGINEERING→DRAWING_APPROVAL→MATERIAL_CHECK→PROCUREMENT→READY
        →EXECUTION→QC→DELIVERY→INVOICING→CLOSED   (CANCELLED from most states)
DRAWING DRAFT→REVIEW→INTERNAL_APPROVAL→CUSTOMER_APPROVAL→RELEASED  (→SUPERSEDED)
PO      DRAFT→PENDING_APPROVAL→APPROVED→SENT→CONFIRMED→PARTIALLY_RECEIVED→RECEIVED→CLOSED
INVOICE DRAFT→PENDING_APPROVAL→ISSUED→PARTIALLY_PAID→PAID | OVERDUE | CANCELLED|CREDITED
PROJECT PLANNING→ACTIVE→ON_HOLD→VERIFICATION→CLOSED
```

`transition(entity, to, actor, reason)` is the **only** way status changes. It:
1. verifies the transition is declared legal,
2. runs the gates (§4.4),
3. checks the actor's permission for that specific transition,
4. updates the row with the optimistic-concurrency version check,
5. writes `status_transitions` + `audit_logs` + `activities`,
6. enqueues automation events.

Arbitrary `PATCH { status: 'CLOSED' }` is impossible — status is not an editable field on any
generic update endpoint.

### 4.4 Business rule / gate engine (`server/workflow/gates.ts`)

Named, testable, centralized predicates:

| Gate | Blocks |
|---|---|
| `drawingApprovedForOrder` | ORDER → EXECUTION when `requires_drawing_approval` and no RELEASED drawing |
| `noOpenShortages` | ORDER → READY when any `material_requirements.shortage_qty > 0` |
| `mandatoryTasksComplete` | PROJECT → CLOSED when any `project_tasks.is_mandatory_for_closure` is open |
| `orderInvoiceable` | INVOICE issue when order is not at/after DELIVERY |
| `sufficientStock` | reservation exceeding `on_hand − reserved` |
| `segregationOfDuties` | approving a document you created, where the setting requires it |
| `releasedRevisionImmutable` | editing a RELEASED BOM/drawing without creating a new revision |

Gates return `{ ok: false, code, message, context }` so the UI can render the *useful* error the
spec demands — e.g.
`"Unable to reserve 15 units of PV-BV-050-SS: 12 on hand, 3 reserved by SO-2026-000021."`

### 4.5 Tax engine (`server/tax/`)

Config-driven from `tax_rates` + company `tax_treatment` + `place_of_supply`:

```
resolveTax({ sellerState, buyerState, isExport, hsn, rate }) →
  isExport                    → { igst: 0, treatment: 'EXPORT_LUT' | 'EXPORT_WITH_IGST' }
  sellerState === buyerState  → { cgst: rate/2, sgst: rate/2 }
  otherwise                   → { igst: rate }
```

Line-level computation in decimal.js, `ROUND_HALF_UP` at 2dp, a `round_off` line reconciles the
invoice total. India (GST/GSTIN/HSN) and Spain/EU (VAT/NIF, intra-community reverse charge) are
separate strategy objects — **no country logic in any React component**.

### 4.6 Money (`server/money/`)

All arithmetic through decimal.js helpers. DB: `numeric(18,4)` for unit prices, `numeric(18,2)`
for totals. Multi-currency via `currency` + `exchange_rate` + `base_amount` on every financial
document. **Server always recomputes** subtotal/discount/tax/total and ignores browser totals.

### 4.7 Automation engine (`server/automation/`)

Rules are `(event) → [effects]`, dispatched through the job queue, deduplicated by
`automation_events.event_key UNIQUE` so replays are idempotent.

| Event | Effects |
|---|---|
| `lead.created` | assign owner → create follow-up task → notify → email |
| `quote.sent` | follow-up task at +N days |
| `quote.accepted` | create sales order (carrying customer/lines/terms) → notify |
| `order.created` | create project → open engineering request → explode BOM → run MRP |
| `mrp.shortage` | create material requirement → create purchase request → notify procurement |
| `drawing.approved` | unlock next order stage → notify sales |
| `goods.received` | post stock movements → recompute shortages → close requirements |
| `invoice.overdue` (cron) | create payment follow-up task → notify accounts |
| `deadline.approaching` (cron) | notify responsible user |

### 4.8 Audit (`server/audit/`)

`audit(actor, action, entityType, entityId, {before, after, metadata, requestId, ip})` written
in the same transaction as the change. `audit_logs` is append-only at the database level.
Covers login/logout/failed login, create/update/delete, every status transition, approvals,
drawing revisions, stock adjustments, invoice/payment changes, permission changes, exports,
privileged document access.

### 4.9 Jobs (`server/jobs/` + `scripts/worker.ts`)

`claim` uses `FOR UPDATE SKIP LOCKED`; exponential backoff `min(2^attempt, 15m)`; `max_attempts`
then `status='dead'` (DLQ view in admin). Handlers: `send_email`, `generate_pdf`, `recalc_stock`,
`run_mrp`, `process_import`, `build_report`, `notify`, `scheduled_followups`, `expire_quotes`,
`flag_overdue_invoices`.

### 4.10 Files (`server/files/`)

Validate on upload: extension allow-list, real MIME sniff (magic bytes, not client header), size
cap, filename sanitization, SHA-256 checksum, org scoping. Stored outside the web root under a
random key. Download only through `GET /api/files/:id`, which re-checks permission on the owning
entity and issues a short-lived HMAC token. No public URLs.

---

## 5. SECURITY MODEL

### 5.1 Authentication
scrypt (N=16384,r=8,p=1) per-user salt · opaque 32-byte session token, only its SHA-256 stored ·
`HttpOnly; SameSite=Lax; Secure` cookie · absolute TTL + idle timeout · rotation on privilege
change · server-side revocation · login rate limit + lockout after N failures · all auth events
audited.

### 5.2 Authorization
Permission codes `<module>.<action>` (`lead.view`, `quote.approve`, `invoice.export`,
`stock.adjust`, `finance.view_margins`). Role→permission mapping is data, editable in Admin.

| Role | Shape of access |
|---|---|
| Super Admin | everything incl. role/permission management |
| Owner / Management | all modules read, approvals, financial figures, global (both orgs) |
| Sales | CRM, quotes, orders (own/team), read-only inventory & projects |
| Engineering | products, part numbers, BOM, drawings, engineering requests |
| Procurement | suppliers, PR/PO, goods receipt, inventory read |
| Inventory | stock, movements, adjustments, warehouses, GRN |
| Accounts | invoices, payments, expenses, bills, financial reports |
| Project Manager | projects, tasks, Gantt, related order read |
| Quality | QC tasks, GRN inspection, drawing review |
| India Team / Spain Team | org-scoped modifier applied on top of the functional role |

### 5.3 Org (India / Spain) isolation
Every table carries `org_id`. Every query goes through a repository requiring an
`AuthContext { userId, orgIds[], permissions, isGlobal }` and injects `where org_id = any($orgIds)`.
A lint rule + integration test bans raw `db.select()` in `app/`. Global roles carry an explicit
`isGlobal` flag. **UI hiding is never the control.**

### 5.4 API contract — every route answers seven questions
1. Who is calling? 2. Authenticated? 3. Authorized for this permission?
4. Which org(s)? 5. Does this record belong to them?
6. Is the operation legal in the current state? 7. Is the input schema-valid?

Enforced by a single `defineRoute({ permission, schema, handler })` wrapper so a route cannot
accidentally skip a check.

### 5.5 Hardening
Zod on every input · parameterized queries only · React escaping + CSP (`frame-ancestors 'none'`,
`object-src 'none'`) · `SameSite=Lax` + origin check on mutations · rate limits on login, public
inquiry, search, export · secrets only in env, never in client bundles · `NEXT_PUBLIC_*` audited ·
structured logs with no PII/secrets · TLS in transit, disk/DB encryption at rest where supported.

### 5.6 Public website inquiry endpoint
`POST /api/public/inquiry` — the only unauthenticated write.
Origin allow-list → shared-secret header → per-IP + per-email rate limit → honeypot + minimum
fill-time → Zod validation → duplicate detection (email+phone+72h) → `inquiry_submissions` raw
log → lead creation → assignment → notification → follow-up task. It can **only** insert; it can
never read internal data.

---

## 6. MODULE SPECIFICATIONS

Each module is delivered with: schema → permissions → services → API → UI → validation → audit →
error handling → tests. Nothing is "done" before all ten.

### 6.1 CRM
Leads (number, company, contact, product requirement, qty, source, owner, priority, value,
expected close, notes, attachments, activities, follow-ups) · visual Kanban where drag-drop calls
the same guarded `transition()` the API uses · duplicate detection on email/phone/company ·
convert-to-customer reusing the existing company record · Company 360 and Contact records with
full activity history.

### 6.2 Quotations
Line editor with product lookup, qty, price, discount, tax, currency; server-recalculated totals ·
revisions (`parent_quote_id`, immutable history) · professional PDF · state machine · email send
with tracked `email_log` · expiry job.

### 6.3 Quote → Order
One click. Carries customer, contact, lines, part numbers, prices, taxes, terms, delivery. Writes
`sales_orders.quotation_id` for traceability. Idempotent — a second click returns the existing order.

### 6.4 Sales Orders
Full header + lines, customer PO reference, delivery dates, engineering requirement flags, linked
project, documents, configurable status workflow, per-line delivered/invoiced quantities.

### 6.5 Products & Part Numbers
Product master (code, part number, category, UOM, material, dimensions, specs, HSN/SAC, tax class,
cost, price, supplier, stock rules, revision) · duplicate prevention on code + on normalized
name+specs · part number engine (§4.2) with revision history and audit.

### 6.6 Engineering & Drawings
Engineering requests tied to orders · drawing register with revisions, uploads, inline preview
(PDF/image), comments, internal + customer approval with timestamps and actors ·
`DRAFT→REVIEW→INTERNAL_APPROVAL→CUSTOMER_APPROVAL→RELEASED` · previous revisions never destroyed ·
approval unlocks the downstream order gate.

### 6.7 BOM
Multi-level, revision-controlled, effective-dated, substitute components, scrap %.
`explodeBom(productId, qty, asOfDate)` returns the flattened requirement with cycle detection.

### 6.8 Inventory
`stock_items` (on-hand / reserved / incoming / damaged / rejected) per product per warehouse ·
every change writes an append-only `stock_movements` row with `balance_after` in the same
transaction · reservation service with `SELECT … FOR UPDATE` preventing overselling · release /
reallocation / partial availability · adjustments require `stock.adjust` and a reason.

### 6.9 MRP & Material Intelligence
For each order line: `required` vs `available` vs `reserved` vs `incoming` → `shortage`. Presented
as the spec demands — not "Stock = 13" but
**"15 required · 13 available · 2 incoming (arriving 02 Sep) · shortage 0 · fulfillable tomorrow."**
Shortages auto-create `material_requirements` and procurement recommendations.

### 6.10 Procurement
`MATERIAL REQUIREMENT → PURCHASE REQUEST → APPROVAL → PO → SUPPLIER CONFIRMATION → DISPATCH →
RECEIVING → INSPECTION → STOCK`. PO PDF + email. Supplier master with historical prices, purchase
history, on-time-delivery and acceptance-rate metrics.

### 6.11 Goods Receipt
GRN against PO: ordered / received / accepted / rejected / damaged, batch, serial, inspection,
rejection reason. **Only accepted quantity increases available stock**; rejected/damaged go to
their own buckets. Updates PO line received qty, recomputes shortages, closes requirements.

### 6.12 Projects
Auto-created from orders. Kanban + timeline + **Gantt** with dependencies, milestones, weighted
progress roll-up, delay detection vs planned dates, health indicator, budget vs actual, team,
documents, mandatory closure checklist.

### 6.13 Tasks
Personal dashboard: Overdue / Today / Upcoming / Waiting / Completed. Tasks arrive from the
automation engine (new lead → contact; quote sent → follow-up; drawing submitted → approval;
shortage → procurement; delay → PM) and are deduplicated by `source_key`.

### 6.14 Finance
GST-correct tax invoices (GSTIN, HSN/SAC, CGST/SGST/IGST, taxable value, place of supply,
round-off) · export invoices (currency, incoterm, LUT/with-IGST) · credit notes · invoice PDF ·
payments with partial allocation across invoices · receivables ageing · expenses with approval and
receipts · bills (AP) · chart of accounts + journal foundation.
**Stated honestly:** this is an accounting *foundation* (AR/AP/tax/reporting), not a certified
statutory ledger — documented as such per spec §36.

### 6.15 Documents
Polymorphic attachment to any entity, versioned, metadata, permissioned, audited access.

### 6.16 Search & 360 views
Global search across leads, companies, contacts, quotes, orders, projects, products, part numbers,
drawings, POs, invoices, payments — typing `SO-2026-000012` returns the record **and its whole
connected chain**.
**Order 360** — one screen: customer, order, quote, engineering, part number, drawing, BOM,
material, inventory, procurement, project %, tasks, delivery, invoice, payment, documents, audit
history, risks.
**Customer 360** — leads, contacts, quotes, orders, projects, invoices, payments, documents,
communication, timeline.

### 6.17 Dashboards & Reports
Management dashboard (Sales / Operations / Inventory / Finance / Tasks) plus the
**"Attention Required"** widget — leads not contacted, quotes awaiting follow-up, drawing
approvals, shortages, delayed POs, delayed projects, overdue tasks, overdue invoices, pending
approvals — every row clicks through to the record.
Reports: lead conversion, pipeline, sales by customer/product/period, stock, movement,
consumption, shortage, incoming, low stock, purchase volume, supplier performance, pending/delayed
POs, project completion/delay/cycle-time/profitability, revenue, expenses, receivables, payables,
P&L, tax. All server-side aggregated against indexes, all export-permission-checked.

### 6.18 Import & migration
`UPLOAD → VALIDATE → PREVIEW → ERROR REPORT → CONFIRM → IMPORT → AUDIT` for customers, contacts,
products, part numbers, inventory, suppliers, quotes, orders. Detects duplicates, invalid fields,
missing required fields, bad references, bad tax data. Nothing is inserted before the user confirms
a preview. Large files run as a background job.

### 6.19 Administration
Users, roles, permissions, organizations, currencies, tax rates, numbering rules, product
categories, lead sources, pipeline/order/project statuses, workflow requirements, approval rules,
inventory thresholds, notification rules, email templates. **No hard-coded business config.**

---

## 7. API SURFACE (representative)

```
POST   /api/auth/login | logout            GET /api/auth/me
POST   /api/public/inquiry                 (unauthenticated, hardened)

GET|POST   /api/leads                       GET|PATCH /api/leads/:id
POST       /api/leads/:id/transition | /convert | /activities
GET|POST   /api/companies /contacts /products /suppliers
POST       /api/products/:id/part-number

GET|POST   /api/quotes                      POST /api/quotes/:id/transition
POST       /api/quotes/:id/revise | /send | /pdf | /convert-to-order

GET|POST   /api/orders                      POST /api/orders/:id/transition
GET        /api/orders/:id/360 | /materials | /timeline

GET|POST   /api/boms                        POST /api/boms/:id/release
GET|POST   /api/drawings                    POST /api/drawings/:id/revisions | /approve

GET        /api/inventory/stock             POST /api/inventory/adjust
POST       /api/inventory/reserve | /release
GET        /api/mrp/requirements            POST /api/mrp/run

GET|POST   /api/purchase-requests /purchase-orders
POST       /api/purchase-orders/:id/approve | /send | /pdf
GET|POST   /api/goods-receipts

GET|POST   /api/projects /project-tasks     GET /api/projects/:id/gantt
GET|POST   /api/tasks                        POST /api/tasks/:id/complete

GET|POST   /api/invoices                     POST /api/invoices/:id/issue | /pdf
GET|POST   /api/payments /expenses /bills

GET        /api/search?q=                    GET /api/dashboard/:widget
GET        /api/reports/:report              POST /api/exports/:entity
GET        /api/files/:id                     POST /api/files
GET|POST   /api/imports                       POST /api/imports/:id/confirm
GET        /api/notifications                 POST /api/notifications/read
GET        /api/admin/*                        (users, roles, settings, numbering, jobs, audit)
GET        /api/health | /api/ready
```

Every route is declared through `defineRoute()` with its required permission and Zod schema.

---

## 8. UI / UX PLAN

Enterprise-serious, quiet, dense-but-readable. Neutral surface palette, one brand accent, semantic
status colours only (ok / warn / danger / info). Consistent primitives: `Button, Input, Select,
Combobox, Table, DataTable(server paginated+filtered+sorted), StatusPill, Card, Tabs, Drawer,
Modal(sparingly), Toast, EmptyState, Skeleton, ErrorState, Timeline, KanbanBoard, GanttChart,
StatTile, Chart`.

Layout: fixed collapsible sidebar, top bar with global search (`Ctrl+K`), org switcher,
notifications, user menu. Breakpoints: mobile ≥360 (usable), tablet ≥768 (Dashboard, CRM, Order,
Inventory, Project, Tasks fully operable — the shop-floor/travel case), desktop ≥1280 (optimized).
Keyboard: `Ctrl+K` search, `n` new, `/` filter, arrow navigation in tables, focus rings, ARIA on
all interactive elements.

Every list has: server-side pagination, filters, sort, saved views, empty state, loading skeleton,
error state with retry, and an export button gated by permission. Charts only where they carry
operational meaning (§72).

---

## 9. PHASED DELIVERY PLAN

Each phase ends with: `typecheck` + `lint` + `test` + `build` + migration check + a demoable
vertical slice. **No phase starts while the previous phase's foundation is broken.**

| # | Phase | Delivers | Exit criteria |
|---|---|---|---|
| **0** | Architecture & schema | Stack, repo layout, docker DB, env contract, migration runner, full schema + seeds, ERD docs | `db:migrate` + `db:verify` green on a clean database |
| **1** | Auth, orgs, users, RBAC | Login, sessions, permissions, org switching, admin user/role screens, auth audit | Security tests: unauthenticated, wrong-permission, cross-org all rejected |
| **2** | CRM | Companies, contacts, leads, Kanban, activities, tasks, public inquiry endpoint | Website → lead → assignment → follow-up task end-to-end |
| **3** | Quotations & Sales Orders | Quote editor, tax/total engine, PDF, state machine, one-click conversion | Quote → accepted → order with zero re-keying |
| **4** | Products & part numbering | Product master, categories, part-number rules + engine, revisions | Concurrency test: 100 parallel generations, 0 duplicates |
| **5** | Engineering & drawings | Engineering requests, drawing register, revisions, approvals, file security | Order blocked at gate until a drawing is RELEASED |
| **6** | BOM & inventory | BOM revisions + explosion, warehouses, stock items, movement ledger, reservations | Concurrency test: parallel reservations never oversell |
| **7** | MRP & procurement | Requirement calc, shortage intelligence, PR → PO → GRN → stock | Shortage of 3 auto-creates a requirement and a purchase request |
| **8** | Projects, tasks, Gantt | Auto project creation, tasks, dependencies, milestones, Gantt, progress, delays | Closure blocked while mandatory verification tasks open |
| **9** | Finance | GST + export invoices, credit notes, payments, allocations, expenses, bills, AR ageing | GST split correct for intra/inter-state and export |
| **10** | Documents, notifications, automation | Polymorphic documents, notification centre, automation rules, email templates + log, job worker | Automation replay creates no duplicates |
| **11** | Dashboards & reports | Management dashboard, Attention Required, Order 360, Customer 360, global search, reports | Order 360 answers the whole order on one screen |
| **12** | Import & migration | Import pipeline (validate/preview/error-report/confirm), all entity importers | Real Paravalves Excel imports with a clean error report |
| **13** | Security hardening | Full §5 review, rate limits, headers, file security, penetration attempts, fixes | Documented security report; every finding closed |
| **14** | Performance | Query plans, index tuning, N+1 elimination, caching, pagination audit, load test | p95 API < 300 ms, dashboard < 1.5 s, Order 360 < 800 ms |
| **15** | QA & E2E | Full 26-step chain (§10), unit/integration/API/workflow/security/concurrency suites, CI | Whole suite green in CI |
| **16** | Deployment | Staging + production, backups, restore drill, monitoring, runbooks, final audit reports | Restore actually tested; all seven reports produced |

---

## 10. THE CRITICAL END-TO-END TEST

One automated Playwright + integration test proving the whole chain:

```
 1 website submits inquiry        14 inventory checked
 2 lead created                   15 shortage calculated
 3 lead assigned                  16 procurement requirement created
 4 follow-up task created         17 purchase order created
 5 quote created                  18 material received
 6 quote PDF generated            19 inventory updated
 7 quote accepted                 20 project updated
 8 sales order created            21 QC completed
 9 project created                22 delivery completed
10 part number generated          23 invoice generated
11 drawing uploaded               24 payment recorded
12 drawing approved               25 final verification completed
13 BOM exploded                   26 project closed
```

Asserted at every step: correct numbering, correct stock arithmetic, correct tax, correct audit
entries, correct notifications, and that each gate genuinely blocked before its precondition was met.

---

## 11. TEST STRATEGY

| Suite | Scope | Tool |
|---|---|---|
| Unit | tax engine, money, numbering format, BOM explosion, MRP arithmetic, state machines, gates, part-number rules | Vitest |
| Integration | services against a real Postgres (per-test transaction rollback) | Vitest |
| API | authn/authz per route, org isolation, validation errors, 409 concurrency | Vitest + fetch |
| Workflow | Lead→Quote→Order, Order→Engineering, Order→Inventory, Inventory→Procurement, Procurement→Receiving, Invoice→Payment | Vitest |
| Security | unauthenticated access, wrong role, cross-org record access, direct status manipulation, file access without entity permission, IDOR, rate limits | Vitest |
| Concurrency | parallel numbering, parallel reservations, simultaneous edits (version conflict), duplicate automation events | Vitest + `Promise.all` |
| E2E | the 26-step chain, login, CRM board, order 360, invoice + payment | Playwright |

Coverage targets: ≥90% on `server/domain`, `server/workflow`, `server/tax`, `server/numbering`;
UI covered by E2E rather than snapshot noise.

---

## 12. CI / CD

GitHub Actions on every PR: `install → typecheck → lint → migrate (clean DB) → unit → integration
→ api → build → e2e (smoke) → dependency audit → secret scan`. Migration check verifies migrations
are append-only and apply cleanly from scratch. A PR with any red check is not production-ready.
`main` → staging automatically; production requires a tagged release plus manual approval.

---

## 13. ENVIRONMENTS, BACKUP, OBSERVABILITY

**Environments:** DEVELOPMENT (docker Postgres :55432) → STAGING (managed Postgres, prod-like
anonymized volume) → PRODUCTION. Separate env files, separate secrets, no developer connects to
production. Deployment reproducible from a tagged commit.

**Backup & recovery:** nightly `pg_dump` + platform PITR where available; retention 7 daily /
4 weekly / 12 monthly; file storage snapshotted alongside; **quarterly restore drill into a
scratch instance with a signed-off checklist**. An untested backup is documented as unreliable
until a restore has actually been performed.

**Observability:** structured JSON logs with `requestId` correlation and no PII; server-side error
tracking (users see safe, useful messages); job monitoring (pending/running/failed/dead); slow-query
log; `GET /api/health` (process) and `GET /api/ready` (DB + storage + queue); auth/security event log.

---

## 14. PERFORMANCE PROGRAMME

Forbidden: full-table fetches, N+1 queries, shipping large datasets to the browser, recomputing
reports per render, sequential network calls that could be parallel. Required: server-side
pagination/filter/sort everywhere, debounced search, targeted indexes justified by `EXPLAIN
ANALYZE`, cached aggregates for dashboards with scheduled refresh, lazy-loaded heavy views (Gantt,
charts), background jobs for anything slow, short transactions.

Measured before production on a seeded realistic dataset (5k companies / 20k orders / 100k stock
movements): initial load, API latency, DB query latency, search, dashboard, inventory, Order 360,
Gantt, reports, large table pagination.

---

## 15. DOCUMENTATION DELIVERABLES (`docs/`)

`architecture.md` · `database.md` (+ ERD) · `api.md` · `auth.md` · `authorization.md` ·
`workflows.md` · `business-rules.md` · `numbering.md` · `part-numbers.md` · `tax.md` ·
`environment.md` · `deployment.md` · `backup-restore.md` · `migrations.md` · `integrations.md` ·
`troubleshooting.md` · `runbook.md`

---

## 16. FINAL AUDIT DELIVERABLES

At the end of Phase 16, produce honestly and without inflation:

1. **Feature completion report** — every spec section marked complete / partial / not built.
2. **Database integrity report** — FKs, constraints, indexes, orphan check, duplicate business
   identifier check, stock consistency check, impossible-financial-state check.
3. **Security report** — the §5 review, attempted unauthorized access results, findings, fixes.
4. **Performance report** — measured numbers against the §14 targets.
5. **Test report** — suites, counts, coverage, known gaps.
6. **Deployment report** — environments, pipeline, backup config, restore-drill evidence.
7. **Known limitations report** — explicitly, including the accounting-foundation caveat.

**Rule: no claim of 100% completion while anything is incomplete.**

---

## 17. DEFINITION OF DONE (per feature)

A feature is complete only when **all** hold: UI works · API works · database is correct ·
authorization enforced server-side · validation returns useful errors · business rules enforced
centrally · errors handled and logged · audit trail written · edge cases handled · tests exist and
pass · performance acceptable · it integrates correctly with downstream workflows.

Not done because: the page exists, the button exists, the form submits, or a row appeared.

---

## 18. CURRENT STATE OF THE REPOSITORY

Already created in `D:\Paravalves`:

- `package.json` — scripts (`dev`, `db:migrate`, `db:seed`, `worker`, `test`, `ci`) and dependency set
- `tsconfig.json` — strict TypeScript with `@/*` path alias
- `next.config.mjs` — security headers + CSP
- `tailwind.config.ts`, `postcss.config.mjs`, `.eslintrc.json`, `.gitignore`
- `docker-compose.yml` — Postgres 16 on port **55432** (isolated from the existing local Postgres on 5432)
- `.env.example` and `.env` (generated with fresh random secrets; `.env` is gitignored)
- Empty `src/`, `migrations/`, `scripts/`, `tests/`, `docs/` trees
- Local git repository initialized
- Postgres dev container started

Not yet done: `npm install` (was interrupted), and all of Phases 0–16.

**Command to resume the build:**

```bash
npm install && npm run db:up && npm run db:migrate && npm run db:seed && npm run dev
```

---

## 19. OPEN DECISIONS THAT REQUIRE PARAVALVES INPUT

These change business behaviour, so they should be answered rather than assumed:

1. **Part number formula** — exact segment order, codes and widths per product family.
2. **Order workflow** — which stages are mandatory vs optional per product type.
3. **Approval matrix** — value thresholds for quote/PO/invoice approval, and whether segregation
   of duties (cannot approve your own document) is enforced.
4. **Org model** — are India and Spain separate legal entities with separate numbering and books
   (assumed yes), and which roles are genuinely global?
5. **Tax specifics** — Spain VAT treatment set, India export mode (LUT vs with-IGST), and whether
   e-invoicing/IRN is in scope.
6. **Data migration scope** — how much Holded/Zoho history moves in versus stays archived.
7. **Email** — sending domain, SMTP provider, and whether customer-facing mail sends from the
   platform in Phase 1 or later.

---

*End of build plan.*
