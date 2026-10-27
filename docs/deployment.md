# Deployment

## Environments
DEVELOPMENT (docker Postgres :55432) → STAGING → PRODUCTION. Never develop against production.
Secrets live only in `.env` (gitignored). Generate: `node -e "console.log(require('crypto').randomBytes(32).toString('base64'))"`.

## Production (Docker Compose)
1. Copy `.env.production.example` → `.env` and fill in strong secrets.
2. Build & start:
   ```bash
   docker compose -f docker-compose.prod.yml up -d --build
   ```
3. Apply migrations (first deploy and after schema changes):
   ```bash
   docker compose -f docker-compose.prod.yml exec app node scripts/... # or run npm run db:migrate against DATABASE_URL
   ```
   (Run `npm run db:migrate` with the production `DATABASE_URL` from a maintenance shell.)
4. Health: `GET /api/health` (process) and `GET /api/ready` (DB).

The app image is a Next.js **standalone** build (small, no dev deps). It runs as a non-root user with a Docker HEALTHCHECK hitting `/api/health`.

## CI/CD
`.github/workflows/ci.yml` runs on every push/PR: install → typecheck → lint → migrate (clean PG) → seed → unit tests → domain E2E chain → build. A red pipeline is not production-ready.

## Security headers
CSP is set per-request with a nonce in `src/middleware.ts` (strict in production: no `unsafe-eval`/`unsafe-inline` for scripts). Other headers (X-Frame-Options, nosniff, Referrer-Policy, Permissions-Policy) are in `next.config.mjs`. Set `COOKIE_SECURE=true` in production (compose does this).
