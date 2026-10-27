# Backup & Restore

## Backup (nightly)
```bash
DATABASE_URL=postgres://... ./scripts/backup.sh /var/backups/paravalves
```
Writes `paravalves_<timestamp>.sql.gz` and keeps the 7 most recent. Schedule via cron:
```
0 2 * * *  DATABASE_URL=postgres://... /opt/app/scripts/backup.sh /var/backups/paravalves >> /var/log/pv-backup.log 2>&1
```
For managed Postgres, also enable the provider's point-in-time recovery (PITR).

## Restore (and DRILL)
```bash
DATABASE_URL=postgres://SCRATCH ./scripts/restore.sh paravalves_20260901_020000.sql.gz
npm run db:verify   # sanity checks
```
**A backup that has never been restored is not a backup.** Run a quarterly restore drill into a scratch database and sign off a checklist. Retention target: 7 daily / 4 weekly / 12 monthly.
