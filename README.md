# Ubuntu Backup System

A comprehensive backup and recovery solution for Ubuntu systems.

## Quick Start

1. **Full Backup**: `sudo ./system_backup.sh`
2. **Config Backup**: `./config_backup.sh`
3. **Emergency Recovery**: `./remote_recovery.sh`
4. **Check Status**: `./backup_status.sh`

## Documentation

All detailed documentation is in the `documentation/` folder:

- **[Complete Guide](documentation/README.md)** - Full system documentation
- **[Cron Examples](documentation/new_backup_crontab.txt)** - Automation setup

## Main Scripts

- `system_backup.sh` - Full system backup (15GB)
- `config_backup.sh` - Quick config backup (7-8MB)
- `remote_recovery.sh` - Emergency remote recovery
- `system_restore.sh` - Comprehensive restore guide
- `backup_status.sh` - Check backup status and disk usage
- `test_backup_system.sh` - Test backup integrity

## Storage Locations

- **System Backups**: `/mnt/storage/system-backups/`
- **Config Backups**: `/mnt/storage/config-backups/`
- **Scripts**: `/home/joey/homeserver/backups/btrfs-backup/`

Your system is protected with tested, working backups on your 7.3TB drive!
