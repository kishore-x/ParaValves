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
