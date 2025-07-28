#!/bin/bash

echo "=================================================="
echo "Ubuntu Backup System Status"
echo "=================================================="

echo "1. FILESYSTEM OVERVIEW:"
echo "======================="
df -h /
echo ""
sudo btrfs filesystem usage /

echo ""
echo "2. SUBVOLUMES:"
echo "=============="
sudo btrfs subvolume list /

echo ""
echo "3. CURRENT SNAPSHOTS:"
echo "===================="
echo "Configuration snapshots:"
ls -la /mnt/snapshots/configs/ 2>/dev/null | grep configs_ || echo "No config snapshots yet"

echo ""
echo "System backups:"
ls -la /mnt/storage/system_backups/ 2>/dev/null | head -10 || echo "No system backups yet"

echo ""
echo "4. BACKUP SCRIPTS:"
echo "=================="
ls -la ~/system_backup.sh ~/config_snapshot.sh ~/system_restore_info.sh

echo ""
echo "5. DISK USAGE:"
echo "=============="
echo "Storage drive usage:"
df -h /mnt/storage

echo ""
echo "Snapshot directory usage:"
du -sh /mnt/snapshots/* 2>/dev/null || echo "No snapshot data yet"

echo ""
echo "=================================================="
echo "BACKUP SYSTEM READY!"
echo "=================================================="
echo "Available backup options:"
echo ""
echo "1. Configuration snapshots (btrfs): ~/config_snapshot.sh"
echo "   - Snapshots /etc, /usr/local, /opt configurations"
echo "   - Fast, space-efficient, instant recovery"
echo "   - Good for: config changes, software installs"
echo ""
echo "2. Full system backup (tar): ~/system_backup.sh"  
echo "   - Complete system backup excluding temp files"
echo "   - Slower but complete coverage"
echo "   - Good for: complete disaster recovery"
echo ""
echo "3. Setup automated backups:"
echo "   sudo crontab -e"
echo "   (Add contents from ~/new_backup_crontab.txt)"
echo ""
echo "4. View restore options: ~/system_restore_info.sh"
echo "=================================================="
