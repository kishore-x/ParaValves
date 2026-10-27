# Runbook

## Local dev
```bash
npm install
npm run db:up && npm run db:migrate && npm run db:seed
npm run db:demo      # optional: rich demo dataset
npm run dev          # http://localhost:3000  (admin@paravalves.com / admin123)
```

## Tests
- `npm run typecheck` · `npm run lint`
- `npm run test`             unit (money, state machines)
- `npm run test:e2e`         full domain lifecycle (24 assertions)
- `npm run test:e2e:browser` Playwright smoke (needs the app running)

## Common issues
- **Blank page 2nd tab / client buttons dead**: check CSP allows the app's scripts (middleware nonce). In dev, `unsafe-eval` is required by Next HMR.
- **`.next` EPERM on Windows**: never run `npm run build` while `npm run dev` is live; stop dev first.
- **DB connection refused**: `docker compose up -d db`; confirm port 55432.

## Health
`GET /api/health` (process up), `GET /api/ready` (DB reachable).
