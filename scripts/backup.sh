#!/usr/bin/env bash
# Nightly database backup. Usage: DATABASE_URL=... ./scripts/backup.sh [outdir]
set -euo pipefail
OUT="${1:-./backups}"
mkdir -p "$OUT"
TS=$(date +%Y%m%d_%H%M%S)
FILE="$OUT/paravalves_$TS.sql.gz"
: "${DATABASE_URL:?set DATABASE_URL}"
echo "Backing up to $FILE"
pg_dump "$DATABASE_URL" --no-owner --no-privileges | gzip > "$FILE"
# retention: keep 7 daily
ls -1t "$OUT"/paravalves_*.sql.gz | tail -n +8 | xargs -r rm -f
echo "Done. $(du -h "$FILE" | cut -f1)"
