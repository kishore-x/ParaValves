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
