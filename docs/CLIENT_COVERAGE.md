# Valve ERP — coverage against the client process outline

Source: *ERP Process Outline for Valve Manufacturing* (client "Final Draft_ERP.docx").
Status key: **Built** = working screen + business rule + demo data · **Partial** = works, with a stated limit · **Not built** = outside this release.

Demo logins (all passwords are demo-only — change before any real use):
`admin@paravalves.com / admin123` · `manager@paravalves.com / manager123` (senior approver) · `quality@paravalves.com / quality123` · `production@paravalves.com / production123` · `sales@paravalves.com / sales123`

## 1. End-to-end process (12 stages)

| # | Stage | Status | Where | Notes |
|---|---|---|---|---|
| 1 | Enquiry & quotation | **Built / Partial** | Leads, Quotations | Requirements capture, pricing, approval states and a **frozen version of every quote when sent** (`quotation_versions`) are built. *Partial:* there is no rules engine that validates a valve configuration or estimates lead time automatically. |
| 2 | Sales order & review | **Built** | Sales Orders → *Order review* | Quote→order in one click. Checklist for PO, spec, price, terms, credit, capacity, date; differences recorded; **acknowledgement cannot be issued until every item is validated**. |
| 3 | Engineering release | **Built / Partial** | Drawings, **Bills of Material**, **Engineering Changes** | Drawing revisions & approval, revision-controlled BOM with effectivity and cost roll-up, standard routing generated on each work order. *Not built:* work-instruction documents; routing is a template, not an editable per-product routing. |
| 4 | Planning & supply | **Partial** | Inventory (MRP), Exceptions | Required / available / incoming / shortage per order, with shortages surfaced in Exceptions and a buyer action recorded. *Not built:* finite-capacity scheduling; netting does not yet include WIP quantities. |
| 5 | Procurement & receiving | **Built** | Suppliers, Procurement | Approved / conditional / **blocked** suppliers (blocked cannot take subcontract work), PO approval, goods receipt. **Every accepted receipt creates a traceable lot (lot, heat, certificate ref) held in QUARANTINE.** |
| 6 | Production & subcontract | **Built** | Production, Subcontract | Work orders with **release gates** (released drawing, credit hold, open spec change). Operation progress with hours, scrap, rework, downtime; material issued **only from released lots**; subcontract reconciliation (sent / returned / processed / scrapped / at-supplier) with mismatch detection. |
| 7 | Component inspection & testing | **Built** | Inspections, Non-conformances | Check sheets per stage; failure quarantines the lot and raises an NCR; **calibration-lapsed equipment is blocked** from recording results. |
| 8 | Stores & inventory | **Partial** | Inventory, lots | Status (quarantine / released / rejected / consumed), lot-level quantity and traceability, reservation and issue. *Not built:* bin-level locations and cycle counting. |
| 9 | Assembly & traceability | **Built** | Assembly & Serials, Traceability | Serial/tag, critical-component genealogy (body, stem, seat, bonnet lots + subcontract step), **as-built drawing revision**. Quarantined/rejected lots cannot be assembled. Trace in either direction (serial ⇄ lot/heat ⇄ supplier ⇄ customer). |
| 10 | Final inspection & testing | **Built** | Inspections, Valve Tests | Shell-pressure, seat/leak, functional tests recorded against the serial with equipment and evidence reference. **Release only when final inspection passed, all three tests pass, and no NCR is open.** |
| 11 | Dispatch & invoicing | **Built / Partial** | Dispatch, Invoices | Gates: quality release, credit, export clearance, customer documents. Blocked shipments name the failing gate **and an owner**. Partial shipments tracked against order balance. *Partial:* the invoice is generated from the order, not from shipment quantities or milestones. |
| 12 | Costing & reporting | **Partial** | Costing, Dashboard | Planned vs actual material, labour, subcontract and scrap per work order; inventory ↔ cost reconciliation view. *Partial:* planned cost uses illustrative standard-cost ratios; **no overhead absorption rule is configured**, so actual overhead is zero until finance defines one. |

## 2. Roles & essential controls

| Control | Status | How |
|---|---|---|
| Role-based access | **Built** | 10 roles incl. Quality and Production; permissions enforced server-side on every action. |
| Approval limits & maker-checker | **Built** | Nobody can approve their own request. Requests above ₹5,00,000 need senior (`approval.manage`) authority. Applies to NCR disposition, engineering change, and manual requests. |
| Searchable audit history | **Built** | Append-only audit log; admin screen. |
| Block downstream release when prerequisites are missing | **Built** | Work-order release, lot issue, assembly, unit release, shipment — each checked in code, not just in the UI. |
| Preserve failed inspection / test results | **Built** | Enforced **in the database**: decided inspections cannot be edited or deleted; test records are append-only. A retest is a new record linked to the original. |
| Trace lots/serials supplier → customer | **Built** | `/traceability` |

## 3. Exceptions to demonstrate (all seeded in the demo data)

| Scenario | Status | Where to see it |
|---|---|---|
| Incomplete / changed specification | **Built** | Order review (SO-…003 has an open spec difference) + Exceptions: SPEC_CHANGE; unresolved spec change blocks work-order release. |
| Material shortage / late supplier | **Built** | Exceptions: shortage + late-supplier cases; resolution = expedite / alternate / date change (updates the promise date). |
| Engineering change after release | **Built** | Engineering Changes: impact across open orders, open POs, stock & lots, WIP; approval by a different user; implementation raises the drawing revision. |
| Failed inspection or test | **Built** | Non-conformances: quarantine, NCR, proposed disposition → approval → close; one unit retested after a seat-leak failure with the original failure preserved. |
| Subcontract mismatch | **Built** | Subcontract: one order shows 5 processed vs 4 received → MISMATCH. |
| Shipment block / partial shipment | **Built** | Dispatch: four blocked shipments (documents, credit hold, export clearance, quality) and one partial shipment. |
| Interface failure | **Partial** | Interfaces: log with owner, failed events, **safe retry**, duplicate prevention by idempotency key. *Not built:* real connectors to an accounting system or customer portal — the log and retry mechanics are real, the external endpoints are not. |

## Known gaps (to agree with the client)

1. Certificates and test charts are stored as **references**, not uploaded files (no file-upload UI yet).
2. Configuration validation / lead-time estimation at quote stage.
3. Work instructions; editable per-product routing.
4. Finite-capacity planning; WIP-aware netting.
5. Invoice-from-shipment / milestone billing; overhead absorption.
6. Bin-level stock locations.
7. Real external interfaces (accounting, portal, supplier EDI).
8. Demo passwords and the demo-only seed are for evaluation; production needs real users and a clean database.

## Demo data volume

15 leads · 14 customers · 8 suppliers · 15 products · 16 quotations (14 sent) · 12 orders · 20 receiving lots · 35 inspections · 4 NCRs · 15 work orders · 10 subcontract orders · 21 serialised valves · 49 tests · 8 shipments · 3 invoices · 3 engineering changes · 8 approvals · 8 exceptions · 8 interface events · 7 equipment records · 9 BOMs.
