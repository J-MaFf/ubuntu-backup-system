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
echo "Root filesystem info:"
sudo btrfs subvolume list / 2>/dev/null || echo "Not a btrfs root filesystem"

echo ""
echo "3. CURRENT BACKUPS:"
echo "==================="
echo "Configuration backups:"
ls -la /mnt/storage/config-backups/ 2>/dev/null | head -5 || echo "No config backups yet"

echo ""
echo "System backups:"
ls -la /mnt/storage/system-backups/ 2>/dev/null | head -5 || echo "No system backups yet"

echo ""
echo "4. BACKUP SCRIPTS:"
echo "=================="
ls -la /home/joey/btrfs-backup/*.sh

echo ""
echo "5. DISK USAGE:"
echo "=============="
echo "Storage drive usage:"
df -h /mnt/storage

echo ""
echo "Backup directory usage:"
du -sh /mnt/storage/* 2>/dev/null || echo "No backup data yet"

echo ""
echo "=================================================="
echo "BACKUP SYSTEM STATUS COMPLETE!"
echo "=================================================="
echo "Available backup scripts:"
echo ""
echo "1. Configuration backup (rsync): ./config_backup.sh"
echo "   - Backs up /etc, /home/joey, /usr/local configurations"
echo "   - Quick backup of important config files"
echo "   - Good for: config changes, user data protection"
echo ""
echo "2. Full system backup (rsync): ./system_backup.sh"  
echo "   - Complete system backup excluding temp files"
echo "   - Comprehensive coverage of entire system"
echo "   - Good for: complete disaster recovery"
echo ""
echo "3. Emergency recovery: ./remote_recovery.sh"
echo "   - Remote-friendly recovery without Live USB"
echo ""
echo "4. View restore guide: ./system_restore.sh"
echo "=================================================="
