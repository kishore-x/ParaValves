-- ===========================================================================
-- Paravalves Platform — initial schema (Phase 0)
-- PostgreSQL 16
-- ===========================================================================

create extension if not exists "pgcrypto";
create extension if not exists "pg_trgm";

-- --- shared trigger: maintain updated_at + version --------------------------
create or replace function touch_row() returns trigger as $$
begin
  new.updated_at := now();
  if tg_op = 'UPDATE' then
    new.version := old.version + 1;
  end if;
  return new;
end;
$$ language plpgsql;

-- ===========================================================================
-- PLATFORM / SECURITY
-- ===========================================================================

create table organizations (
  id           uuid primary key default gen_random_uuid(),
  code         text not null unique,
  name         text not null,
  country      text not null default 'IN',
  currency     text not null default 'INR',
  gstin        text,
  state_code   text,
  address      text,
  is_active    boolean not null default true,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now(),
  version      integer not null default 1
);
create trigger t_org before update on organizations for each row execute function touch_row();

create table users (
  id            uuid primary key default gen_random_uuid(),
  email         text not null unique,
  name          text not null,
  password_hash text not null,
  is_active     boolean not null default true,
  is_global     boolean not null default false,   -- can access all orgs
  archived_at   timestamptz,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  version       integer not null default 1
);
create trigger t_users before update on users for each row execute function touch_row();

create table roles (
  id          uuid primary key default gen_random_uuid(),
  code        text not null unique,
  name        text not null,
  description text,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  version     integer not null default 1
);
create trigger t_roles before update on roles for each row execute function touch_row();

create table permissions (
  code        text primary key,        -- e.g. lead.view
  module      text not null,
  description text
);

create table role_permissions (
  role_id         uuid not null references roles(id) on delete cascade,
  permission_code text not null references permissions(code) on delete cascade,
  primary key (role_id, permission_code)
);

create table user_roles (
  user_id uuid not null references users(id) on delete cascade,
  role_id uuid not null references roles(id) on delete cascade,
  primary key (user_id, role_id)
);

create table user_organizations (
  user_id uuid not null references users(id) on delete cascade,
  org_id  uuid not null references organizations(id) on delete cascade,
  primary key (user_id, org_id)
);

create table sessions (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references users(id) on delete cascade,
  token_hash  text not null unique,
  created_at  timestamptz not null default now(),
  expires_at  timestamptz not null,
  last_seen_at timestamptz not null default now(),
  ip          text,
  user_agent  text
);
create index idx_sessions_user on sessions(user_id);

create table audit_logs (
  id          bigserial primary key,
  org_id      uuid,
  actor_id    uuid,
  actor_name  text,
  action      text not null,
  entity_type text not null,
  entity_id   text,
  before_data jsonb,
  after_data  jsonb,
  metadata    jsonb,
  ip          text,
  created_at  timestamptz not null default now()
);
create index idx_audit_entity on audit_logs(entity_type, entity_id);
create index idx_audit_org_time on audit_logs(org_id, created_at desc);

-- audit is append-only
create or replace function audit_immutable() returns trigger as $$
begin
  raise exception 'audit_logs is append-only';
end;
$$ language plpgsql;
create trigger t_audit_immutable before update or delete on audit_logs
  for each row execute function audit_immutable();

create table settings (
  org_id     uuid not null references organizations(id) on delete cascade,
  key        text not null,
  value      jsonb not null,
  updated_at timestamptz not null default now(),
  primary key (org_id, key)
);

create table number_sequences (
  org_id        uuid not null references organizations(id) on delete cascade,
  doc_type      text not null,
  period_key    text not null default '',
  prefix        text not null,
  padding       integer not null default 6,
  current_value bigint not null default 0,
  primary key (org_id, doc_type, period_key)
);

create table rate_limits (
  bucket     text not null,
  window_key text not null,
  count      integer not null default 0,
  primary key (bucket, window_key)
);

-- ===========================================================================
-- SHARED SERVICES
-- ===========================================================================

create table files (
  id           uuid primary key default gen_random_uuid(),
  org_id       uuid not null references organizations(id) on delete cascade,
  entity_type  text,
  entity_id    text,
  filename     text not null,
  mime_type    text not null,
  size_bytes   bigint not null,
  storage_key  text not null,
  checksum     text,
  uploaded_by  uuid references users(id),
  created_at   timestamptz not null default now()
);
create index idx_files_entity on files(entity_type, entity_id);

create table activities (
  id          bigserial primary key,
  org_id      uuid not null references organizations(id) on delete cascade,
  entity_type text not null,
  entity_id   text not null,
  kind        text not null,           -- note|call|email|meeting|status|system
  summary     text not null,
  detail      text,
  actor_id    uuid references users(id),
  actor_name  text,
  created_at  timestamptz not null default now()
);
create index idx_activities_entity on activities(entity_type, entity_id, created_at desc);

create table notifications (
  id          bigserial primary key,
  org_id      uuid not null references organizations(id) on delete cascade,
  user_id     uuid not null references users(id) on delete cascade,
  category    text not null,
  title       text not null,
  body        text,
  link        text,
  is_read     boolean not null default false,
  created_at  timestamptz not null default now()
);
create index idx_notif_user on notifications(user_id, is_read, created_at desc);

create table tasks (
  id            uuid primary key default gen_random_uuid(),
  org_id        uuid not null references organizations(id) on delete cascade,
  task_number   text not null,
  title         text not null,
  description   text,
  entity_type   text,
  entity_id     text,
  assignee_id   uuid references users(id),
  due_at        timestamptz,
  status        text not null default 'OPEN',  -- OPEN|WAITING|DONE
  priority      text not null default 'NORMAL',
  source_key    text,                          -- dedup key for automation
  created_by    uuid references users(id),
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  version       integer not null default 1,
  unique (org_id, task_number),
  unique (org_id, source_key)
);
create trigger t_tasks before update on tasks for each row execute function touch_row();
create index idx_tasks_assignee on tasks(assignee_id, status, due_at);

create table status_transitions (
  id          bigserial primary key,
  org_id      uuid not null,
  entity_type text not null,
  entity_id   text not null,
  from_status text,
  to_status   text not null,
  actor_id    uuid,
  actor_name  text,
  reason      text,
  created_at  timestamptz not null default now()
);
create index idx_transitions_entity on status_transitions(entity_type, entity_id);

create table jobs (
  id           uuid primary key default gen_random_uuid(),
  kind         text not null,
  payload      jsonb not null default '{}',
  status       text not null default 'pending', -- pending|running|done|failed|dead
  attempts     integer not null default 0,
  max_attempts integer not null default 5,
  run_at       timestamptz not null default now(),
  last_error   text,
  created_at   timestamptz not null default now()
);
create index idx_jobs_claim on jobs(status, run_at);

create table email_log (
  id          bigserial primary key,
  org_id      uuid,
  recipient   text not null,
  subject     text not null,
  event       text,
  status      text not null default 'queued',
  error       text,
  created_at  timestamptz not null default now(),
  sent_at     timestamptz
);

create table automation_events (
  event_key  text primary key,
  kind       text not null,
  created_at timestamptz not null default now()
);

-- ===========================================================================
-- CRM
-- ===========================================================================

create table companies (
  id            uuid primary key default gen_random_uuid(),
  org_id        uuid not null references organizations(id) on delete cascade,
  company_number text not null,
  name          text not null,
  is_customer   boolean not null default true,
  is_supplier   boolean not null default false,
  country       text,
  state_code    text,
  city          text,
  address       text,
  postal_code   text,
  gstin         text,
  tax_treatment text default 'DOMESTIC',   -- DOMESTIC|EXPORT
  currency      text default 'INR',
  payment_terms text default 'NET30',
  category      text,
  owner_id      uuid references users(id),
  archived_at   timestamptz,
  created_by    uuid references users(id),
  updated_by    uuid references users(id),
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  version       integer not null default 1,
  unique (org_id, company_number)
);
create trigger t_companies before update on companies for each row execute function touch_row();
create index idx_companies_name on companies using gin (name gin_trgm_ops);
create index idx_companies_org on companies(org_id, created_at desc);

create table contacts (
  id           uuid primary key default gen_random_uuid(),
  org_id       uuid not null references organizations(id) on delete cascade,
  company_id   uuid references companies(id) on delete set null,
  name         text not null,
  designation  text,
  department   text,
  email        text,
  phone        text,
  whatsapp     text,
  is_primary   boolean not null default false,
  notes        text,
  created_by   uuid references users(id),
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now(),
  version      integer not null default 1
);
create trigger t_contacts before update on contacts for each row execute function touch_row();
create index idx_contacts_company on contacts(company_id);

create table leads (
  id              uuid primary key default gen_random_uuid(),
  org_id          uuid not null references organizations(id) on delete cascade,
  lead_number     text not null,
  company_name    text not null,
  contact_name    text,
  email           text,
  phone           text,
  country         text,
  product_requirement text,
  quantity        numeric(18,3),
  description     text,
  source          text not null default 'MANUAL',
  status          text not null default 'NEW',
  priority        text not null default 'NORMAL',
  expected_value  numeric(18,2),
  expected_close  date,
  owner_id        uuid references users(id),
  company_id      uuid references companies(id),   -- linked/converted
  converted_at    timestamptz,
  created_by      uuid references users(id),
  updated_by      uuid references users(id),
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  version         integer not null default 1,
  unique (org_id, lead_number)
);
create trigger t_leads before update on leads for each row execute function touch_row();
create index idx_leads_pipeline on leads(org_id, status, created_at desc);

create table inquiry_submissions (
  id           bigserial primary key,
  org_id       uuid,
  payload      jsonb not null,
  ip           text,
  lead_id      uuid references leads(id),
  is_duplicate boolean not null default false,
  created_at   timestamptz not null default now()
);

-- ===========================================================================
-- PRODUCTS & ENGINEERING
-- ===========================================================================

create table product_categories (
  id        uuid primary key default gen_random_uuid(),
  org_id    uuid not null references organizations(id) on delete cascade,
  name      text not null,
  parent_id uuid references product_categories(id),
  unique (org_id, name)
);

create table products (
  id            uuid primary key default gen_random_uuid(),
  org_id        uuid not null references organizations(id) on delete cascade,
  product_code  text not null,
  name          text not null,
  category_id   uuid references product_categories(id),
  description   text,
  uom           text not null default 'NOS',
  material      text,
  dimensions    text,
  specifications jsonb,
  hsn_sac       text,
  tax_rate      numeric(5,2) not null default 18,
  standard_cost numeric(18,4) not null default 0,
  selling_price numeric(18,4) not null default 0,
  min_stock     numeric(18,3) not null default 0,
  reorder_point numeric(18,3) not null default 0,
  is_manufactured boolean not null default false,
  archived_at   timestamptz,
  created_by    uuid references users(id),
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  version       integer not null default 1,
  unique (org_id, product_code)
);
create trigger t_products before update on products for each row execute function touch_row();
create index idx_products_name on products using gin (name gin_trgm_ops);

create table part_number_rules (
  id         uuid primary key default gen_random_uuid(),
  org_id     uuid not null references organizations(id) on delete cascade,
  name       text not null,
  pattern    text not null,          -- {family}-{size}-{material}-R{revision}
  segments   jsonb not null default '[]',
  is_default boolean not null default false
);

create table part_numbers (
  id           uuid primary key default gen_random_uuid(),
  org_id       uuid not null references organizations(id) on delete cascade,
  part_number  text not null,
  product_id   uuid references products(id),
  attributes   jsonb not null default '{}',
  revision     integer not null default 1,
  created_by   uuid references users(id),
  created_at   timestamptz not null default now(),
  unique (org_id, part_number)
);

create table boms (
  id           uuid primary key default gen_random_uuid(),
  org_id       uuid not null references organizations(id) on delete cascade,
  product_id   uuid not null references products(id),
  revision     integer not null default 1,
  status       text not null default 'DRAFT',   -- DRAFT|RELEASED|SUPERSEDED
  effective_date date,
  created_by   uuid references users(id),
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now(),
  version      integer not null default 1,
  unique (org_id, product_id, revision)
);
create trigger t_boms before update on boms for each row execute function touch_row();

create table bom_lines (
  id            uuid primary key default gen_random_uuid(),
  bom_id        uuid not null references boms(id) on delete cascade,
  component_id  uuid not null references products(id),
  quantity      numeric(18,4) not null check (quantity > 0),
  uom           text not null default 'NOS',
  scrap_pct     numeric(5,2) not null default 0
);
create index idx_bomlines_bom on bom_lines(bom_id);

create table engineering_requests (
  id           uuid primary key default gen_random_uuid(),
  org_id       uuid not null references organizations(id) on delete cascade,
  er_number    text not null,
  sales_order_id uuid,
  product_id   uuid references products(id),
  title        text not null,
  description  text,
  status       text not null default 'OPEN',
  assignee_id  uuid references users(id),
  created_by   uuid references users(id),
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now(),
  version      integer not null default 1,
  unique (org_id, er_number)
);
create trigger t_er before update on engineering_requests for each row execute function touch_row();

create table drawings (
  id             uuid primary key default gen_random_uuid(),
  org_id         uuid not null references organizations(id) on delete cascade,
  drawing_number text not null,
  product_id     uuid references products(id),
  sales_order_id uuid,
  title          text not null,
  status         text not null default 'DRAFT',
  current_revision integer not null default 1,
  created_by     uuid references users(id),
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now(),
  version        integer not null default 1,
  unique (org_id, drawing_number)
);
create trigger t_drawings before update on drawings for each row execute function touch_row();

create table drawing_revisions (
  id           uuid primary key default gen_random_uuid(),
  drawing_id   uuid not null references drawings(id) on delete cascade,
  revision     integer not null,
  file_id      uuid references files(id),
  status       text not null default 'DRAFT',
  uploaded_by  uuid references users(id),
  reviewed_by  uuid references users(id),
  approved_by  uuid references users(id),
  approved_at  timestamptz,
  notes        text,
  created_at   timestamptz not null default now(),
  unique (drawing_id, revision)
);

-- ===========================================================================
-- SALES: QUOTES & ORDERS
-- ===========================================================================

create table quotations (
  id            uuid primary key default gen_random_uuid(),
  org_id        uuid not null references organizations(id) on delete cascade,
  quote_number  text not null,
  company_id    uuid not null references companies(id),
  contact_id    uuid references contacts(id),
  lead_id       uuid references leads(id),
  parent_quote_id uuid references quotations(id),
  revision      integer not null default 1,
  status        text not null default 'DRAFT',
  currency      text not null default 'INR',
  exchange_rate numeric(18,6) not null default 1,
  payment_terms text default 'NET30',
  delivery_terms text,
  valid_until   date,
  notes         text,
  subtotal      numeric(18,2) not null default 0,
  discount_total numeric(18,2) not null default 0,
  tax_total     numeric(18,2) not null default 0,
  grand_total   numeric(18,2) not null default 0,
  created_by    uuid references users(id),
  updated_by    uuid references users(id),
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  version       integer not null default 1,
  unique (org_id, quote_number)
);
create trigger t_quotes before update on quotations for each row execute function touch_row();
create index idx_quotes_org on quotations(org_id, status, created_at desc);

create table quotation_lines (
  id           uuid primary key default gen_random_uuid(),
  quotation_id uuid not null references quotations(id) on delete cascade,
  line_no      integer not null,
  product_id   uuid references products(id),
  description  text not null,
  quantity     numeric(18,3) not null check (quantity > 0),
  unit_price   numeric(18,4) not null default 0,
  discount_pct numeric(5,2) not null default 0,
  tax_rate     numeric(5,2) not null default 18,
  line_total   numeric(18,2) not null default 0
);
create index idx_quotelines_q on quotation_lines(quotation_id);

create table sales_orders (
  id            uuid primary key default gen_random_uuid(),
  org_id        uuid not null references organizations(id) on delete cascade,
  order_number  text not null,
  company_id    uuid not null references companies(id),
  contact_id    uuid references contacts(id),
  quotation_id  uuid references quotations(id),
  customer_po_ref text,
  status        text not null default 'CONFIRMED',
  currency      text not null default 'INR',
  exchange_rate numeric(18,6) not null default 1,
  delivery_date date,
  requires_drawing_approval boolean not null default false,
  subtotal      numeric(18,2) not null default 0,
  discount_total numeric(18,2) not null default 0,
  tax_total     numeric(18,2) not null default 0,
  grand_total   numeric(18,2) not null default 0,
  notes         text,
  created_by    uuid references users(id),
  updated_by    uuid references users(id),
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  version       integer not null default 1,
  unique (org_id, order_number)
);
create trigger t_orders before update on sales_orders for each row execute function touch_row();
create index idx_orders_org on sales_orders(org_id, status, created_at desc);

create table sales_order_lines (
  id            uuid primary key default gen_random_uuid(),
  sales_order_id uuid not null references sales_orders(id) on delete cascade,
  line_no       integer not null,
  product_id    uuid references products(id),
  description   text not null,
  quantity      numeric(18,3) not null check (quantity > 0),
  unit_price    numeric(18,4) not null default 0,
  discount_pct  numeric(5,2) not null default 0,
  tax_rate      numeric(5,2) not null default 18,
  line_total    numeric(18,2) not null default 0,
  delivered_qty numeric(18,3) not null default 0,
  invoiced_qty  numeric(18,3) not null default 0
);
create index idx_orderlines_o on sales_order_lines(sales_order_id);

-- ===========================================================================
-- INVENTORY
-- ===========================================================================

create table warehouses (
  id       uuid primary key default gen_random_uuid(),
  org_id   uuid not null references organizations(id) on delete cascade,
  code     text not null,
  name     text not null,
  is_default boolean not null default false,
  unique (org_id, code)
);

create table stock_items (
  id           uuid primary key default gen_random_uuid(),
  org_id       uuid not null references organizations(id) on delete cascade,
  product_id   uuid not null references products(id),
  warehouse_id uuid not null references warehouses(id),
  on_hand      numeric(18,3) not null default 0,
  reserved     numeric(18,3) not null default 0,
  incoming     numeric(18,3) not null default 0,
  damaged      numeric(18,3) not null default 0,
  rejected     numeric(18,3) not null default 0,
  updated_at   timestamptz not null default now(),
  version      integer not null default 1,
  unique (product_id, warehouse_id),
  check (on_hand >= 0),
  check (reserved >= 0),
  check (reserved <= on_hand)
);
create index idx_stock_org on stock_items(org_id, product_id);

create table stock_movements (
  id           bigserial primary key,
  org_id       uuid not null references organizations(id) on delete cascade,
  product_id   uuid not null references products(id),
  warehouse_id uuid not null references warehouses(id),
  kind         text not null,   -- RECEIPT|ISSUE|ADJUST|RESERVE|RELEASE
  quantity     numeric(18,3) not null,
  balance_after numeric(18,3) not null,
  ref_type     text,
  ref_id       text,
  reason       text,
  actor_id     uuid references users(id),
  created_at   timestamptz not null default now()
);
create index idx_movements on stock_movements(org_id, product_id, warehouse_id, created_at desc);

create table stock_reservations (
  id            uuid primary key default gen_random_uuid(),
  org_id        uuid not null references organizations(id) on delete cascade,
  product_id    uuid not null references products(id),
  warehouse_id  uuid not null references warehouses(id),
  sales_order_id uuid references sales_orders(id) on delete cascade,
  quantity      numeric(18,3) not null check (quantity > 0),
  status        text not null default 'ACTIVE',  -- ACTIVE|RELEASED
  created_at    timestamptz not null default now()
);

create table material_requirements (
  id            uuid primary key default gen_random_uuid(),
  org_id        uuid not null references organizations(id) on delete cascade,
  mr_number     text not null,
  sales_order_id uuid references sales_orders(id) on delete cascade,
  product_id    uuid not null references products(id),
  required_qty  numeric(18,3) not null,
  available_qty numeric(18,3) not null default 0,
  reserved_qty  numeric(18,3) not null default 0,
  incoming_qty  numeric(18,3) not null default 0,
  shortage_qty  numeric(18,3) not null default 0,
  status        text not null default 'OPEN',  -- OPEN|COVERED|CLOSED
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  version       integer not null default 1,
  unique (org_id, mr_number)
);
create trigger t_mr before update on material_requirements for each row execute function touch_row();

-- ===========================================================================
-- PROCUREMENT
-- ===========================================================================

create table purchase_orders (
  id            uuid primary key default gen_random_uuid(),
  org_id        uuid not null references organizations(id) on delete cascade,
  po_number     text not null,
  supplier_id   uuid not null references companies(id),
  status        text not null default 'DRAFT',
  currency      text not null default 'INR',
  expected_date date,
  subtotal      numeric(18,2) not null default 0,
  tax_total     numeric(18,2) not null default 0,
  grand_total   numeric(18,2) not null default 0,
  notes         text,
  created_by    uuid references users(id),
  updated_by    uuid references users(id),
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  version       integer not null default 1,
  unique (org_id, po_number)
);
create trigger t_po before update on purchase_orders for each row execute function touch_row();
create index idx_po_org on purchase_orders(org_id, status, created_at desc);

create table purchase_order_lines (
  id            uuid primary key default gen_random_uuid(),
  purchase_order_id uuid not null references purchase_orders(id) on delete cascade,
  line_no       integer not null,
  product_id    uuid references products(id),
  description   text not null,
  quantity      numeric(18,3) not null check (quantity > 0),
  received_qty  numeric(18,3) not null default 0,
  unit_price    numeric(18,4) not null default 0,
  tax_rate      numeric(5,2) not null default 18,
  line_total    numeric(18,2) not null default 0
);
create index idx_polines_po on purchase_order_lines(purchase_order_id);

create table goods_receipts (
  id            uuid primary key default gen_random_uuid(),
  org_id        uuid not null references organizations(id) on delete cascade,
  grn_number    text not null,
  purchase_order_id uuid references purchase_orders(id),
  supplier_id   uuid references companies(id),
  warehouse_id  uuid references warehouses(id),
  status        text not null default 'DRAFT',
  received_at   timestamptz not null default now(),
  created_by    uuid references users(id),
  created_at    timestamptz not null default now(),
  unique (org_id, grn_number)
);

create table goods_receipt_lines (
  id            uuid primary key default gen_random_uuid(),
  goods_receipt_id uuid not null references goods_receipts(id) on delete cascade,
  po_line_id    uuid references purchase_order_lines(id),
  product_id    uuid not null references products(id),
  ordered_qty   numeric(18,3) not null default 0,
  received_qty  numeric(18,3) not null default 0,
  accepted_qty  numeric(18,3) not null default 0,
  rejected_qty  numeric(18,3) not null default 0,
  damaged_qty   numeric(18,3) not null default 0,
  batch         text,
  check (accepted_qty + rejected_qty + damaged_qty <= received_qty)
);

-- ===========================================================================
-- PROJECTS
-- ===========================================================================

create table projects (
  id             uuid primary key default gen_random_uuid(),
  org_id         uuid not null references organizations(id) on delete cascade,
  project_number text not null,
  name           text not null,
  company_id     uuid references companies(id),
  sales_order_id uuid references sales_orders(id),
  status         text not null default 'PLANNING',
  progress_pct   numeric(5,2) not null default 0,
  start_date     date,
  end_date       date,
  budget         numeric(18,2),
  manager_id     uuid references users(id),
  created_by     uuid references users(id),
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now(),
  version        integer not null default 1,
  unique (org_id, project_number)
);
create trigger t_projects before update on projects for each row execute function touch_row();

create table project_tasks (
  id           uuid primary key default gen_random_uuid(),
  project_id   uuid not null references projects(id) on delete cascade,
  name         text not null,
  phase        text,
  status       text not null default 'TODO',  -- TODO|DOING|DONE
  progress_pct numeric(5,2) not null default 0,
  planned_start date,
  planned_end  date,
  assignee_id  uuid references users(id),
  is_mandatory_for_closure boolean not null default false,
  sort_order   integer not null default 0
);
create index idx_ptasks_project on project_tasks(project_id);

-- ===========================================================================
-- FINANCE
-- ===========================================================================

create table tax_rates (
  id       uuid primary key default gen_random_uuid(),
  org_id   uuid not null references organizations(id) on delete cascade,
  name     text not null,
  rate     numeric(5,2) not null,
  hsn_sac  text
);

create table invoices (
  id            uuid primary key default gen_random_uuid(),
  org_id        uuid not null references organizations(id) on delete cascade,
  invoice_number text not null,
  company_id    uuid not null references companies(id),
  sales_order_id uuid references sales_orders(id),
  status        text not null default 'DRAFT',
  currency      text not null default 'INR',
  invoice_date  date not null default current_date,
  due_date      date,
  place_of_supply text,
  is_export     boolean not null default false,
  subtotal      numeric(18,2) not null default 0,
  cgst          numeric(18,2) not null default 0,
  sgst          numeric(18,2) not null default 0,
  igst          numeric(18,2) not null default 0,
  round_off     numeric(18,2) not null default 0,
  grand_total   numeric(18,2) not null default 0 check (grand_total >= 0),
  paid_amount   numeric(18,2) not null default 0,
  notes         text,
  created_by    uuid references users(id),
  updated_by    uuid references users(id),
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  version       integer not null default 1,
  unique (org_id, invoice_number)
);
create trigger t_invoices before update on invoices for each row execute function touch_row();
create index idx_invoices_org on invoices(org_id, status, due_date);

create table invoice_lines (
  id           uuid primary key default gen_random_uuid(),
  invoice_id   uuid not null references invoices(id) on delete cascade,
  line_no      integer not null,
  product_id   uuid references products(id),
  description  text not null,
  hsn_sac      text,
  quantity     numeric(18,3) not null check (quantity > 0),
  unit_price   numeric(18,4) not null default 0,
  tax_rate     numeric(5,2) not null default 18,
  taxable_value numeric(18,2) not null default 0,
  tax_amount   numeric(18,2) not null default 0,
  line_total   numeric(18,2) not null default 0
);
create index idx_invlines_inv on invoice_lines(invoice_id);

create table payments (
  id            uuid primary key default gen_random_uuid(),
  org_id        uuid not null references organizations(id) on delete cascade,
  payment_number text not null,
  company_id    uuid references companies(id),
  amount        numeric(18,2) not null check (amount > 0),
  currency      text not null default 'INR',
  method        text,
  reference     text,
  paid_at       date not null default current_date,
  created_by    uuid references users(id),
  created_at    timestamptz not null default now(),
  unique (org_id, payment_number)
);

create table payment_allocations (
  id          uuid primary key default gen_random_uuid(),
  payment_id  uuid not null references payments(id) on delete cascade,
  invoice_id  uuid not null references invoices(id),
  amount      numeric(18,2) not null check (amount > 0)
);
create index idx_alloc_inv on payment_allocations(invoice_id);

create table expenses (
  id           uuid primary key default gen_random_uuid(),
  org_id       uuid not null references organizations(id) on delete cascade,
  expense_number text not null,
  category     text,
  description  text,
  amount       numeric(18,2) not null check (amount > 0),
  tax_amount   numeric(18,2) not null default 0,
  spent_at     date not null default current_date,
  status       text not null default 'SUBMITTED',
  created_by   uuid references users(id),
  created_at   timestamptz not null default now(),
  unique (org_id, expense_number)
);

create table import_batches (
  id          uuid primary key default gen_random_uuid(),
  org_id      uuid not null references organizations(id) on delete cascade,
  entity      text not null,
  status      text not null default 'PENDING',
  total_rows  integer not null default 0,
  ok_rows     integer not null default 0,
  error_rows  integer not null default 0,
  report      jsonb,
  created_by  uuid references users(id),
  created_at  timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- 0002 — Valve manufacturing: quality, production, subcontract, traceability,
-- shipping gates, engineering change, maker-checker, costing, interfaces.
-- Maps to the client's 12-stage process outline (see docs/CLIENT_COVERAGE.md).
-- ---------------------------------------------------------------------------

-- Commercial / compliance flags on companies (credit, export, supplier approval)
alter table companies
  add column if not exists approval_status text not null default 'APPROVED',   -- suppliers: APPROVED|CONDITIONAL|BLOCKED
  add column if not exists credit_limit    numeric(18,2) not null default 0,
  add column if not exists credit_hold    boolean not null default false,
  add column if not exists export_cleared boolean not null default true,
  add column if not exists supplier_rating numeric(3,1);

-- Stage 1: quote version history
create table quotation_versions (
  id            uuid primary key default gen_random_uuid(),
  quotation_id  uuid not null references quotations(id) on delete cascade,
  version_no    integer not null,
  snapshot      jsonb not null,
  note          text,
  created_by    uuid references users(id),
  created_at    timestamptz not null default now(),
  unique (quotation_id, version_no)
);

-- Stage 2: sales order review checklist
create table order_reviews (
  id             uuid primary key default gen_random_uuid(),
  org_id         uuid not null references organizations(id) on delete cascade,
  sales_order_id uuid not null unique references sales_orders(id) on delete cascade,
  po_ok          boolean not null default false,
  spec_ok        boolean not null default false,
  price_ok       boolean not null default false,
  terms_ok       boolean not null default false,
  credit_ok      boolean not null default false,
  capacity_ok    boolean not null default false,
  date_ok        boolean not null default false,
  differences    text,
  promise_date   date,
  acknowledged_at timestamptz,
  reviewed_by    uuid references users(id),
  updated_at     timestamptz not null default now()
);

-- Exceptions raised against orders (spec change, shortage, late supplier, ship block)
create table order_exceptions (
  id             uuid primary key default gen_random_uuid(),
  org_id         uuid not null references organizations(id) on delete cascade,
  exception_no   text not null,
  sales_order_id uuid references sales_orders(id) on delete cascade,
  type           text not null,   -- SPEC_CHANGE|MATERIAL_SHORTAGE|LATE_SUPPLIER|SHIPMENT_BLOCK|OTHER
  status         text not null default 'OPEN',  -- OPEN|IN_PROGRESS|RESOLVED
  description    text not null,
  action_taken   text,            -- EXPEDITE|ALTERNATE|DATE_CHANGE|CLARIFICATION|OTHER
  new_promise_date date,
  owner_id       uuid references users(id),
  created_by     uuid references users(id),
  created_at     timestamptz not null default now(),
  resolved_at    timestamptz,
  unique (org_id, exception_no)
);

-- Equipment & calibration (stage 7/10)
create table equipment (
  id            uuid primary key default gen_random_uuid(),
  org_id        uuid not null references organizations(id) on delete cascade,
  code          text not null,
  name          text not null,
  kind          text not null default 'GAUGE',  -- GAUGE|TEST_BENCH|CMM|OTHER
  calibration_due date,
  status        text not null default 'ACTIVE', -- ACTIVE|OUT_OF_CALIBRATION|RETIRED
  unique (org_id, code)
);

-- Stage 5/8: material lots — heat/lot/serial + certificate; quarantine until accepted
create table material_lots (
  id            uuid primary key default gen_random_uuid(),
  org_id        uuid not null references organizations(id) on delete cascade,
  lot_number    text not null,
  product_id    uuid not null references products(id),
  supplier_id   uuid references companies(id),
  goods_receipt_id uuid references goods_receipts(id),
  heat_number   text,
  certificate_ref text,           -- MTC / EN 10204 3.1 reference
  quantity      numeric(18,3) not null check (quantity >= 0),
  qty_available numeric(18,3) not null default 0 check (qty_available >= 0),
  location      text,
  status        text not null default 'QUARANTINE', -- QUARANTINE|RELEASED|REJECTED|CONSUMED
  received_at   timestamptz not null default now(),
  created_by    uuid references users(id),
  unique (org_id, lot_number)
);

-- Stages 7 & 10: inspections. A decided inspection is immutable (failed result is
-- preserved; a retest is a NEW row pointing at retest_of).
create table inspections (
  id            uuid primary key default gen_random_uuid(),
  org_id        uuid not null references organizations(id) on delete cascade,
  inspection_no text not null,
  stage         text not null,     -- INCOMING|IN_PROCESS|FINAL
  subject_type  text not null,     -- LOT|WORK_ORDER|SERIAL
  subject_id    uuid not null,
  subject_label text,
  checks        jsonb not null default '[]'::jsonb,   -- [{name, spec, measured, ok}]
  status        text not null default 'PENDING',      -- PENDING|PASSED|FAILED
  equipment_id  uuid references equipment(id),
  remarks       text,
  retest_of     uuid references inspections(id),
  inspector_id  uuid references users(id),
  decided_at    timestamptz,
  created_at    timestamptz not null default now(),
  unique (org_id, inspection_no)
);

-- Non-conformance reports
create table nonconformances (
  id            uuid primary key default gen_random_uuid(),
  org_id        uuid not null references organizations(id) on delete cascade,
  ncr_number    text not null,
  source_type   text not null,     -- LOT|INSPECTION|TEST|WORK_ORDER|SERIAL
  source_id     uuid,
  source_label  text,
  description   text not null,
  quantity      numeric(18,3) not null default 1,
  status        text not null default 'OPEN',  -- OPEN|PENDING_APPROVAL|APPROVED|CLOSED
  disposition   text,              -- REWORK|SCRAP|CONCESSION|RETEST|RETURN_TO_SUPPLIER
  disposition_note text,
  raised_by     uuid references users(id),
  approved_by   uuid references users(id),
  approved_at   timestamptz,
  created_at    timestamptz not null default now(),
  closed_at     timestamptz,
  unique (org_id, ncr_number)
);

-- Stage 6: production
create table work_orders (
  id            uuid primary key default gen_random_uuid(),
  org_id        uuid not null references organizations(id) on delete cascade,
  wo_number     text not null,
  sales_order_id uuid references sales_orders(id),
  product_id    uuid not null references products(id),
  quantity      numeric(18,3) not null check (quantity > 0),
  qty_completed numeric(18,3) not null default 0,
  qty_scrapped  numeric(18,3) not null default 0,
  status        text not null default 'PLANNED', -- PLANNED|RELEASED|IN_PROGRESS|ON_HOLD|COMPLETED
  hold_reason   text,
  planned_start date,
  due_date      date,
  planned_material_cost    numeric(18,2) not null default 0,
  planned_labor_cost       numeric(18,2) not null default 0,
  planned_subcontract_cost numeric(18,2) not null default 0,
  planned_overhead         numeric(18,2) not null default 0,
  created_by    uuid references users(id),
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  version       integer not null default 1,
  unique (org_id, wo_number)
);

create table work_order_operations (
  id            uuid primary key default gen_random_uuid(),
  work_order_id uuid not null references work_orders(id) on delete cascade,
  seq           integer not null,
  name          text not null,
  work_center   text,
  is_subcontract boolean not null default false,
  status        text not null default 'PENDING', -- PENDING|IN_PROGRESS|DONE
  planned_hours numeric(10,2) not null default 0,
  actual_hours  numeric(10,2) not null default 0,
  labor_rate    numeric(10,2) not null default 450,
  scrap_qty     numeric(18,3) not null default 0,
  rework_qty    numeric(18,3) not null default 0,
  downtime_minutes integer not null default 0,
  operator_name text,
  completed_at  timestamptz,
  unique (work_order_id, seq)
);

create table wo_material_issues (
  id            uuid primary key default gen_random_uuid(),
  work_order_id uuid not null references work_orders(id) on delete cascade,
  lot_id        uuid not null references material_lots(id),
  product_id    uuid not null references products(id),
  quantity      numeric(18,3) not null check (quantity > 0),
  unit_cost     numeric(18,4) not null default 0,
  issued_by     uuid references users(id),
  issued_at     timestamptz not null default now()
);

-- Subcontract reconciliation: sent = returned + scrapped + still at supplier
create table subcontract_orders (
  id            uuid primary key default gen_random_uuid(),
  org_id        uuid not null references organizations(id) on delete cascade,
  sc_number     text not null,
  work_order_id uuid references work_orders(id),
  supplier_id   uuid not null references companies(id),
  product_id    uuid references products(id),
  process       text not null,   -- e.g. Heat treatment, Hard-facing, Plating
  qty_sent      numeric(18,3) not null default 0,
  qty_returned  numeric(18,3) not null default 0,
  qty_processed numeric(18,3) not null default 0,
  qty_scrapped  numeric(18,3) not null default 0,
  cost          numeric(18,2) not null default 0,
  status        text not null default 'SENT',  -- SENT|PARTIAL|RECONCILED|MISMATCH
  sent_at       date not null default current_date,
  due_date      date,
  note          text,
  created_by    uuid references users(id),
  unique (org_id, sc_number)
);

-- Stage 9: finished serialised units with as-built genealogy
create table serial_units (
  id            uuid primary key default gen_random_uuid(),
  org_id        uuid not null references organizations(id) on delete cascade,
  serial_number text not null,
  tag_number    text,
  product_id    uuid not null references products(id),
  work_order_id uuid references work_orders(id),
  sales_order_id uuid references sales_orders(id),
  drawing_revision text,
  as_built      jsonb not null default '{}'::jsonb,
  status        text not null default 'IN_ASSEMBLY', -- IN_ASSEMBLY|AWAITING_FINAL|QUARANTINE|RELEASED|SHIPPED
  assembly_checks jsonb not null default '[]'::jsonb,
  created_at    timestamptz not null default now(),
  released_at   timestamptz,
  unique (org_id, serial_number)
);

create table unit_components (
  id            uuid primary key default gen_random_uuid(),
  serial_unit_id uuid not null references serial_units(id) on delete cascade,
  component_name text not null,
  lot_id        uuid references material_lots(id),
  subcontract_id uuid references subcontract_orders(id),
  is_critical   boolean not null default true,
  quantity      numeric(18,3) not null default 1
);

-- Stage 10: pressure / seat-leak / functional tests (append-only)
create table test_records (
  id            uuid primary key default gen_random_uuid(),
  org_id        uuid not null references organizations(id) on delete cascade,
  test_number   text not null,
  serial_unit_id uuid not null references serial_units(id),
  test_type     text not null,    -- SHELL_PRESSURE|SEAT_LEAK|FUNCTIONAL
  test_pressure_bar numeric(10,2),
  hold_minutes  integer,
  allowable     text,
  measured      text,
  result        text not null,    -- PASS|FAIL
  equipment_id  uuid references equipment(id),
  evidence_ref  text,             -- certificate / chart reference
  retest_of     uuid references test_records(id),
  performed_by  uuid references users(id),
  performed_at  timestamptz not null default now(),
  unique (org_id, test_number)
);

-- Stage 11: dispatch
create table shipments (
  id            uuid primary key default gen_random_uuid(),
  org_id        uuid not null references organizations(id) on delete cascade,
  shipment_number text not null,
  sales_order_id uuid not null references sales_orders(id),
  status        text not null default 'DRAFT',   -- DRAFT|BLOCKED|READY|SHIPPED
  is_partial    boolean not null default false,
  block_reason  text,
  block_owner_id uuid references users(id),
  carrier       text,
  tracking_ref  text,
  docs          jsonb not null default '{}'::jsonb,  -- {packing_list, coo, mtc, export_docs}
  shipped_at    timestamptz,
  invoice_id    uuid references invoices(id),
  created_by    uuid references users(id),
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  version       integer not null default 1,
  unique (org_id, shipment_number)
);

create table shipment_lines (
  id            uuid primary key default gen_random_uuid(),
  shipment_id   uuid not null references shipments(id) on delete cascade,
  serial_unit_id uuid not null references serial_units(id),
  unique (serial_unit_id)
);

-- Engineering change after release (impact analysis + maker/checker)
create table engineering_changes (
  id            uuid primary key default gen_random_uuid(),
  org_id        uuid not null references organizations(id) on delete cascade,
  ecn_number    text not null,
  product_id    uuid references products(id),
  drawing_id    uuid references drawings(id),
  title         text not null,
  reason        text,
  status        text not null default 'DRAFT',   -- DRAFT|IMPACT_ASSESSED|APPROVED|REJECTED|IMPLEMENTED
  impact        jsonb not null default '{}'::jsonb,
  disposition   text,                            -- how WIP/stock is handled
  effectivity   text,                            -- e.g. "from serial 120" / date
  maker_id      uuid references users(id),
  checker_id    uuid references users(id),
  decided_at    timestamptz,
  created_at    timestamptz not null default now(),
  unique (org_id, ecn_number),
  check (checker_id is null or checker_id <> maker_id)
);

-- Generic maker-checker approvals with approval limits
create table approval_requests (
  id            uuid primary key default gen_random_uuid(),
  org_id        uuid not null references organizations(id) on delete cascade,
  kind          text not null,   -- QUOTE_DISCOUNT|PO_VALUE|NCR_DISPOSITION|ECN|CREDIT_OVERRIDE|SHIPMENT_OVERRIDE
  entity_type   text not null,
  entity_id     uuid,
  entity_label  text,
  amount        numeric(18,2),
  reason        text,
  status        text not null default 'PENDING',  -- PENDING|APPROVED|REJECTED
  maker_id      uuid not null references users(id),
  checker_id    uuid references users(id),
  decision_note text,
  created_at    timestamptz not null default now(),
  decided_at    timestamptz,
  check (checker_id is null or checker_id <> maker_id)
);

-- Interface log with idempotency (duplicate prevention + safe retry)
create table integration_events (
  id            uuid primary key default gen_random_uuid(),
  org_id        uuid not null references organizations(id) on delete cascade,
  system        text not null,      -- WEBSITE|ACCOUNTING|EMAIL|CUSTOMER_PORTAL|SUPPLIER_EDI
  direction     text not null default 'OUTBOUND',
  event_type    text not null,
  reference     text,
  idempotency_key text not null,
  payload       jsonb not null default '{}'::jsonb,
  status        text not null default 'OK',   -- OK|FAILED|RETRIED
  error         text,
  attempts      integer not null default 1,
  owner_id      uuid references users(id),
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  unique (org_id, idempotency_key)
);

-- Stage 12: actual cost postings
create table cost_entries (
  id            uuid primary key default gen_random_uuid(),
  org_id        uuid not null references organizations(id) on delete cascade,
  work_order_id uuid not null references work_orders(id) on delete cascade,
  cost_type     text not null,   -- MATERIAL|LABOR|SUBCONTRACT|SCRAP|OVERHEAD
  amount        numeric(18,2) not null,
  description   text,
  created_at    timestamptz not null default now()
);

-- Immutability: decided inspections and all test records preserve original results
create or replace function inspection_guard() returns trigger as $$
begin
  if tg_op = 'DELETE' then raise exception 'inspections cannot be deleted'; end if;
  if old.status <> 'PENDING' then raise exception 'a decided inspection is immutable — record a retest instead'; end if;
  return new;
end;
$$ language plpgsql;
create trigger t_inspection_guard before update or delete on inspections
  for each row execute function inspection_guard();

create or replace function test_records_immutable() returns trigger as $$
begin
  raise exception 'test_records is append-only — record a retest instead';
end;
$$ language plpgsql;
create trigger t_test_records_immutable before update or delete on test_records
  for each row execute function test_records_immutable();

create trigger t_wo_touch before update on work_orders for each row execute function touch_row();
create trigger t_ship_touch before update on shipments for each row execute function touch_row();

create index on material_lots (org_id, status);
create index on inspections (org_id, status, stage);
create index on work_orders (org_id, status);
create index on serial_units (org_id, status);
create index on nonconformances (org_id, status);
create index on shipments (org_id, status);
create index on unit_components (lot_id);
create index on wo_material_issues (lot_id);
create index on order_exceptions (org_id, status);
create index on approval_requests (org_id, status);
