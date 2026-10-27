#!/usr/bin/env bash
# Restore a backup into DATABASE_URL. Usage: DATABASE_URL=... ./scripts/restore.sh <file.sql.gz>
set -euo pipefail
FILE="${1:?usage: restore.sh <file.sql.gz>}"
: "${DATABASE_URL:?set DATABASE_URL}"
echo "!! This will overwrite the target database. Ctrl-C to abort."; sleep 3
gunzip -c "$FILE" | psql "$DATABASE_URL"
echo "Restore complete. Verify with: npm run db:verify"
