# Copilot Instructions for Ubuntu Backup System

## Project Overview
- This project provides a comprehensive backup and recovery solution for Ubuntu systems using Bash scripts.
- Major scripts are located in `homeserver/backups/btrfs-backup/`.
- Backups are stored in `/mnt/storage/system-backups/` (full system) and `/mnt/storage/config-backups/` (config/user data).

## Key Scripts & Workflows
- `system_backup.sh`: Full system backup using rsync. Run with `sudo`. Output directory uses date format `%d-%m-%Y_%I-%M_%p` (e.g., `28-07-2025_10-47_PM`).
- `config_backup.sh`: Quick backup of configuration and user data. Output directory uses the same date format as above.
- `remote_recovery.sh`: Emergency recovery script for restoring from the latest backup.
- `system_restore.sh`: Interactive restore helper for full system recovery.
- `backup_status.sh`: Shows backup status, disk usage, and recent backup directories.
- `test_backup_system.sh`: Verifies backup integrity and accessibility.

## Date/Time Naming Convention
- All backup directories and files must use the format: `%d-%m-%Y_%I-%M_%p` (day-month-year_hour-minute_AM/PM).
- Example: `config_backup_28-07-2025_10-47_PM`

## Patterns & Conventions
- All scripts are Bash and should be POSIX-compliant where possible.
- Use `sudo` for any operation that writes to backup locations or reads system files.
- Exclude temp, cache, and mount directories from backups (see rsync `--exclude` patterns in scripts).
- Manifest and package lists are generated for each backup.
- User-specific data is backed up from `/home/joey/`.

## Developer Workflows
- To create a backup, run the appropriate script from the `btrfs-backup` directory.
- To test backup integrity, use `test_backup_system.sh`.
- To restore, use `system_restore.sh` or `remote_recovery.sh` as appropriate.
- For automation, see cron examples in `documentation/new_backup_crontab.txt`.

## Documentation
- Main documentation: `homeserver/backups/btrfs-backup/documentation/README.md`
- Quick start and script list: `homeserver/backups/btrfs-backup/README.md`

## Integration Points
- Relies on local storage mounted at `/mnt/storage/`.
- Uses standard Linux tools: `rsync`, `btrfs`, `dpkg`, `systemctl`.
- No external network dependencies for backup/restore.

## Example: Creating a Config Backup
```bash
./config_backup.sh
# Output: /mnt/storage/config-backups/config_backup_28-07-2025_10-47_PM
```

## Example: Creating a System Backup
```bash
sudo ./system_backup.sh
# Output: /mnt/storage/system-backups/ubuntu_backup_28-07-2025_10-47_PM
```

---

> For all new scripts or features, follow the date/time naming convention and reference the documentation for workflow details.
