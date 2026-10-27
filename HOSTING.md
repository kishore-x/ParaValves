# Hosting the Paravalves Platform

**Status: the previous Supabase project (`wtxdmxgnczjvonzwkznt`) has been deleted, so no database is
provisioned yet.** The application is unchanged — it talks to any PostgreSQL through `DATABASE_URL`.
To host it, create a new Supabase project and load the SQL bundle in [`deploy/`](deploy/):

| File | Purpose |
|---|---|
| `deploy/01_schema.sql` | Core schema (CRM, sales, inventory, procurement, finance) |
| `deploy/02_schema_manufacturing.sql` | Valve manufacturing: quality, production, subcontract, traceability, dispatch |
| `deploy/03_demo_data.sql` | Demo dataset for the client (see `docs/CLIENT_COVERAGE.md`). **Run with `set session_replication_role = replica;` first** (circular foreign keys). Demo logins only — omit for a production database. |

Apply them in order (SQL editor, `psql`, or the Supabase MCP). The bundle was verified by restoring it into a
blank PostgreSQL database. After loading, enable RLS on every table (deny-by-default — the app uses its own
auth and a direct `postgres` connection, not the Supabase Data API).

**Demo logins:** `admin@paravalves.com / admin123` · `manager@paravalves.com / manager123` ·
`quality@paravalves.com / quality123` · `production@paravalves.com / production123` ·
`sales@paravalves.com / sales123`. Change or remove these before sharing beyond a demo.

### Why RLS is enabled with no policies
This app does **not** use Supabase Auth or the PostgREST/Data API — it connects with a
plain `pg` client using its own session-based auth (see `src/server/auth/`). Enabling
RLS with zero policies means: if anyone ever obtained the project's public anon key,
they could query **nothing** over the REST API. The app's own connection (via
`DATABASE_URL`, the `postgres` role) is unaffected and works exactly as before.

---

## The one thing only you can do: get the database password

Supabase never exposes the database password through the API after project creation
(by design). Get it from the dashboard:

1. Open the project → **Project Settings → Database**.
2. Under **Connection string**, pick **Transaction pooler** (not Direct — see why below).
3. Copy the password into the string, or click **Reset database password** if you don't have it.

You'll get something shaped like:
```
postgres://postgres.<NEW-PROJECT-REF>:[YOUR-PASSWORD]@aws-0-<region>.pooler.supabase.com:6543/postgres
```

### Why the pooler, not the direct connection
Vercel's serverless functions run on **IPv4-only** networks. Supabase's direct
connection (`db.<NEW-PROJECT-REF>.supabase.co:5432`) is **IPv6-only** on the free
tier — Vercel literally cannot reach it. You must use the **Shared Pooler (Supavisor)
in transaction mode**, port **6543**, which is IPv4. This app is already compatible
with it (it uses unnamed prepared statements, which transaction-mode pooling supports).

---

## Deploy to Vercel

1. **Push to GitHub:**
   ```bash
   git remote add origin https://github.com/<you>/paravalves.git
   git push -u origin main
   ```

2. **Import the repo** at <https://vercel.com/new>. Framework: Next.js (auto-detected).

3. **Add these Environment Variables** (Production + Preview):

   | Name | Value |
   |---|---|
   | `DATABASE_URL` | `postgres://postgres.<NEW-PROJECT-REF>:<PASSWORD>@aws-0-<region>.pooler.supabase.com:6543/postgres` |
   | `SESSION_SECRET` | generate: `node -e "console.log(require('crypto').randomBytes(32).toString('base64'))"` |
   | `FILE_TOKEN_SECRET` | generate another one the same way |
   | `APP_URL` | `https://<your-project>.vercel.app` (update after first deploy if the name differs) |
   | `COOKIE_SECURE` | `true` |
   | `WEBSITE_INQUIRY_API_KEY` | any long random string — only share it with whoever wires the website contact form |
   | `MAIL_DRIVER` | `log` (emails are logged, not sent — fine for a demo; see below to enable real email) |

4. **Deploy.** The build runs `next build` only — the database is already migrated, so
   there's nothing else to do. First deploy typically takes ~1–2 minutes.

5. **Open the URL** → sign in with `admin@paravalves.com` / `admin123`.

That's it — no separate migration step, no seeding step. Everything is already in place.

### Optional: real outbound email
Set `MAIL_DRIVER=smtp` plus `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASS`, `MAIL_FROM`.
Any standard SMTP provider works (Resend, SendGrid, Postmark, etc.).

---

## Alternative: Docker (self-hosted)

If Paravalves ever want this on their own server instead of Vercel:
```bash
cp .env.production.example .env     # fill in strong secrets
docker compose -f docker-compose.prod.yml up -d --build
```
This spins up its own Postgres container — it does not need Supabase at all. See
`docs/deployment.md`.

---

## What was made deployment-ready in the code

- **Edge-safe middleware** — the CSP nonce uses Web Crypto + `btoa` (no `Buffer`), so it
  runs on Vercel's Edge runtime.
- **Conditional build output** — `output: 'standalone'` only applies when
  `BUILD_TARGET=docker` (the Dockerfile sets this); Vercel uses its own build output.
- **PDF generation on serverless** — pdfkit's font metric files are explicitly traced
  via `outputFileTracingIncludes`, so invoice/quote PDFs render correctly on Vercel.
- **TLS auto-detection** — the `pg` pool enables TLS automatically for any non-local
  host (Supabase, Neon, Render, …); no config needed.
- **No build-time DB dependency** — `vercel-build` is plain `next build`. Migrations run
  once via the Supabase MCP/SQL editor, not on every deploy — faster, cheaper builds,
  and no risk of a build failing because Vercel can't reach an IPv6-only direct connection.

---

## Before you share the link with the client

1. **Change the admin password.** Easiest: edit the two password constants in
   `scripts/seed.ts`, or update directly:
   ```js
   // node -e, using the same scrypt format the app expects:
   node -e "const c=require('crypto');const s=c.randomBytes(16);const d=c.scryptSync('YOUR_NEW_PASSWORD',s,64,{N:16384});console.log('scrypt$16384$'+s.toString('hex')+'$'+d.toString('hex'))"
   ```
   Then update the `password_hash` for `admin@paravalves.com` via the Supabase SQL editor
   or ask me to do it through the connected MCP.
2. **Rotate `WEBSITE_INQUIRY_API_KEY`** before giving it to whoever wires up the website form.
3. Decide whether to load the richer demo dataset (`npm run db:demo` locally against this
   same `DATABASE_URL`, or ask me to seed it via MCP) — good for a walkthrough, but it's
   fake data and should be cleared before real use.

---

## Costs

| Service | Free tier | Enough for a client demo? |
|---|---|---|
| Vercel Hobby | 100 GB bandwidth/mo | Yes |
| Supabase Free | 500 MB DB, project pauses after ~1 week idle | Yes, for active demos — not for "leave it running unattended" |

For a real ongoing pilot (client using it daily, unattended), upgrade Supabase to
**Pro (~$25/mo)** to remove the pause-on-idle behavior, or self-host with Docker.
