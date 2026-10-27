import 'dotenv/config';
import { Pool } from 'pg';
import { pgConfig } from './pg-config';
import { randomBytes, scrypt as _scrypt } from 'node:crypto';
import { promisify } from 'node:util';

const scrypt = promisify(_scrypt);

async function hashPassword(password: string): Promise<string> {
  const salt = randomBytes(16);
  const derived = (await (scrypt as any)(password, salt, 64, { N: 16384 })) as Buffer;
  return `scrypt$16384$${salt.toString('hex')}$${derived.toString('hex')}`;
}

const MODULES = [
  'lead', 'company', 'contact', 'product', 'partnumber', 'quote', 'order',
  'engineering', 'drawing', 'bom', 'inventory', 'mrp', 'procurement', 'grn',
  'project', 'task', 'invoice', 'payment', 'expense', 'document', 'report',
  'dashboard', 'search', 'admin', 'finance',
  'quality', 'production', 'subcontract', 'shipment', 'approval', 'integration',
];
const ACTIONS = ['view', 'create', 'edit', 'delete', 'approve', 'export', 'manage'];

async function main() {
  const pool = new Pool(pgConfig());
  const c = await pool.connect();
  try {
    await c.query('begin');

    // --- permissions ---
    const permCodes: string[] = [];
    for (const m of MODULES) {
      for (const a of ACTIONS) {
        const code = `${m}.${a}`;
        permCodes.push(code);
        await c.query(
          `insert into permissions(code, module, description) values ($1,$2,$3)
           on conflict (code) do nothing`,
          [code, m, `${a} ${m}`],
        );
      }
    }
    await c.query(
      `insert into permissions(code, module, description) values ('*','all','Full access')
       on conflict (code) do nothing`,
    );

    // --- roles ---
    const roleDefs: { code: string; name: string; perms: string[] }[] = [
      { code: 'super_admin', name: 'Super Admin', perms: ['*'] },
      { code: 'management', name: 'Management', perms: permCodes },
      { code: 'sales', name: 'Sales', perms: permCodes.filter((p) => /^(lead|company|contact|quote|order|dashboard|search|report|document|task|product)\.(view|create|edit|export)/.test(p)) },
      { code: 'engineering', name: 'Engineering', perms: permCodes.filter((p) => /^(product|partnumber|engineering|drawing|bom|order|dashboard|search|document|task)\.(view|create|edit|approve)/.test(p)) },
      { code: 'procurement', name: 'Procurement', perms: permCodes.filter((p) => /^(procurement|grn|company|product|inventory|mrp|dashboard|search|document|task|order)\.(view|create|edit|approve)/.test(p)) },
      { code: 'inventory', name: 'Inventory', perms: permCodes.filter((p) => /^(inventory|mrp|grn|product|dashboard|search|document|task)\.(view|create|edit)/.test(p)) },
      { code: 'accounts', name: 'Accounts', perms: permCodes.filter((p) => /^(invoice|payment|expense|finance|company|order|dashboard|search|report|document)\.(view|create|edit|approve|export)/.test(p)) },
      { code: 'quality', name: 'Quality', perms: permCodes.filter((p) => /^(quality|approval|production|shipment|inventory|grn|product|dashboard|search|document|task|order)\.(view|create|edit|approve)/.test(p)) },
      { code: 'production', name: 'Production', perms: permCodes.filter((p) => /^(production|subcontract|quality|inventory|product|order|dashboard|search|document|task|shipment)\.(view|create|edit)/.test(p)) },
      { code: 'project_manager', name: 'Project Manager', perms: permCodes.filter((p) => /^(project|task|order|dashboard|search|document)\.(view|create|edit|approve)/.test(p)) },
    ];

    const roleIds: Record<string, string> = {};
    for (const r of roleDefs) {
      const res = await c.query<{ id: string }>(
        `insert into roles(code, name) values ($1,$2)
         on conflict (code) do update set name = excluded.name returning id`,
        [r.code, r.name],
      );
      const id = res.rows[0]!.id;
      roleIds[r.code] = id;
      await c.query('delete from role_permissions where role_id = $1', [id]);
      for (const p of r.perms) {
        await c.query(
          `insert into role_permissions(role_id, permission_code) values ($1,$2)
           on conflict do nothing`,
          [id, p],
        );
      }
    }

    // --- organizations ---
    const orgIndia = await upsertOrg(c, 'IN', 'Paravalves India', 'IN', 'INR', '33', '33AABCP0000A1Z5');
    const orgSpain = await upsertOrg(c, 'ES', 'Paravalves Spain', 'ES', 'EUR', null, null);

    // --- users ---
    const adminPw = await hashPassword('admin123');
    const admin = await c.query<{ id: string }>(
      `insert into users(email, name, password_hash, is_global)
       values ($1,$2,$3,true)
       on conflict (email) do update set password_hash = excluded.password_hash, is_global = true
       returning id`,
      ['admin@paravalves.com', 'System Admin', adminPw],
    );
    const adminId = admin.rows[0]!.id;
    await link(c, adminId, roleIds['super_admin']!, [orgIndia, orgSpain]);

    const salesPw = await hashPassword('sales123');
    const sales = await c.query<{ id: string }>(
      `insert into users(email, name, password_hash)
       values ($1,$2,$3)
       on conflict (email) do update set password_hash = excluded.password_hash
       returning id`,
      ['sales@paravalves.com', 'Ravi Kumar (Sales)', salesPw],
    );
    await link(c, sales.rows[0]!.id, roleIds['sales']!, [orgIndia]);

    // --- warehouse + tax + numbering defaults + sample master data ---
    await c.query(
      `insert into warehouses(org_id, code, name, is_default) values ($1,'MAIN','Main Warehouse',true)
       on conflict (org_id, code) do nothing`,
      [orgIndia],
    );

    // sample products
    const products = [
      ['PV-BV-050', 'Ball Valve 50mm SS316', 'NOS', 'SS316', '84818090', 18, 1200, 2100, true],
      ['PV-GV-080', 'Gate Valve 80mm CF8M', 'NOS', 'CF8M', '84818090', 18, 3400, 5900, true],
      ['PV-SEAT-01', 'PTFE Seat Ring', 'NOS', 'PTFE', '84819090', 18, 90, 180, false],
      ['PV-STEM-01', 'Valve Stem SS316', 'NOS', 'SS316', '84819090', 18, 220, 420, false],
    ];
    const prodIds: Record<string, string> = {};
    for (const p of products) {
      const r = await c.query<{ id: string }>(
        `insert into products(org_id, product_code, name, uom, material, hsn_sac, tax_rate, standard_cost, selling_price, is_manufactured, min_stock, reorder_point)
         values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,5,10)
         on conflict (org_id, product_code) do update set name = excluded.name returning id`,
        [orgIndia, ...p],
      );
      prodIds[p[0] as string] = r.rows[0]!.id;
    }

    // opening stock
    const wh = await c.query<{ id: string }>(`select id from warehouses where org_id=$1 and code='MAIN'`, [orgIndia]);
    const whId = wh.rows[0]!.id;
    const opening: [string, number][] = [['PV-SEAT-01', 40], ['PV-STEM-01', 25], ['PV-BV-050', 13]];
    for (const [code, qty] of opening) {
      await c.query(
        `insert into stock_items(org_id, product_id, warehouse_id, on_hand) values ($1,$2,$3,$4)
         on conflict (product_id, warehouse_id) do update set on_hand = excluded.on_hand`,
        [orgIndia, prodIds[code], whId, qty],
      );
      await c.query(
        `insert into stock_movements(org_id, product_id, warehouse_id, kind, quantity, balance_after, reason)
         values ($1,$2,$3,'RECEIPT',$4,$4,'Opening stock')`,
        [orgIndia, prodIds[code], whId, qty],
      );
    }

    // sample company + contact
    const co = await c.query<{ id: string }>(
      `insert into companies(org_id, company_number, name, is_customer, country, state_code, city, gstin, owner_id)
       values ($1,'CUST-2026-000001','ABC Industries', true,'IN','29','Bengaluru','29AABCA1111A1Z5',$2)
       on conflict (org_id, company_number) do update set name=excluded.name returning id`,
      [orgIndia, sales.rows[0]!.id],
    );
    await c.query(
      `insert into contacts(org_id, company_id, name, designation, email, phone, is_primary)
       values ($1,$2,'Suresh Menon','Purchase Manager','suresh@abcindustries.com','+91 98400 12345', true)
       on conflict do nothing`,
      [orgIndia, co.rows[0]!.id],
    );
    // supplier
    await c.query(
      `insert into companies(org_id, company_number, name, is_customer, is_supplier, country, state_code)
       values ($1,'SUPP-2026-000001','Precision Castings Ltd', false, true,'IN','27')
       on conflict (org_id, company_number) do nothing`,
      [orgIndia],
    );

    // Sync numbering sequences with the manually-seeded document numbers so the
    // numbering engine never regenerates an already-used number (CUST/SUPP -000001).
    const year = String(new Date().getUTCFullYear());
    for (const [docType, prefix] of [['CUST', 'CUST'], ['SUPP', 'SUPP']] as const) {
      await c.query(
        `insert into number_sequences (org_id, doc_type, period_key, prefix, padding, current_value)
         values ($1,$2,$3,$4,6,1)
         on conflict (org_id, doc_type, period_key)
         do update set current_value = greatest(number_sequences.current_value, 1)`,
        [orgIndia, docType, year, prefix]);
    }

    await c.query('commit');
    console.log('✓ Seed complete.');
    console.log('  Login: admin@paravalves.com / admin123   (Super Admin, both orgs)');
    console.log('         sales@paravalves.com / sales123   (Sales, India)');
  } catch (e) {
    await c.query('rollback');
    throw e;
  } finally {
    c.release();
    await pool.end();
  }
}

async function upsertOrg(
  c: import('pg').PoolClient,
  code: string, name: string, country: string, currency: string,
  stateCode: string | null, gstin: string | null,
): Promise<string> {
  const r = await c.query<{ id: string }>(
    `insert into organizations(code, name, country, currency, state_code, gstin)
     values ($1,$2,$3,$4,$5,$6)
     on conflict (code) do update set name = excluded.name returning id`,
    [code, name, country, currency, stateCode, gstin],
  );
  return r.rows[0]!.id;
}

async function link(c: import('pg').PoolClient, userId: string, roleId: string, orgIds: string[]) {
  await c.query(`insert into user_roles(user_id, role_id) values ($1,$2) on conflict do nothing`, [userId, roleId]);
  for (const o of orgIds) {
    await c.query(`insert into user_organizations(user_id, org_id) values ($1,$2) on conflict do nothing`, [userId, o]);
  }
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
