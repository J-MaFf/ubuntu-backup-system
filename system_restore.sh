#!/bin/bash

# Ubuntu System Restore Script
# This script helps restore from backups

BACKUP_DIR="/mnt/storage/system-backups"

echo "=================================================="
echo "Ubuntu System Restore Helper"
echo "=================================================="

echo "Available system backups:"
echo "========================="
if ls "$BACKUP_DIR"/ubuntu_backup_* >/dev/null 2>&1; then
    for backup in "$BACKUP_DIR"/ubuntu_backup_*; do
        if [ -d "$backup" ]; then
            backup_name=$(basename "$backup")
            size=$(du -sh "$backup" 2>/dev/null | cut -f1)
            if [ -f "$backup/backup_info.txt" ]; then
                date=$(grep "Backup created:" "$backup/backup_info.txt" | cut -d: -f2-)
                echo "  $backup_name - Size: $size - Created:$date"
            else
                echo "  $backup_name - Size: $size"
            fi
        fi
    done
else
    echo "No backups found in $BACKUP_DIR"
fi

echo ""
echo "=================================================="
echo "RESTORE INSTRUCTIONS:"
echo "=================================================="
echo ""
echo "IMPORTANT: Full system restore should be done from a Live USB!"
echo ""
echo "Method 1: FULL SYSTEM RESTORE (Use Live USB):"
echo "=============================================="
echo "1. Boot from Ubuntu Live USB"
echo "2. Open terminal and become root: sudo -i"
echo "3. Mount your main drive:"
echo "   mkdir -p /mnt/system"
echo "   mount /dev/mapper/ubuntu--vg-ubuntu--lv /mnt/system"
echo "4. Mount your storage drive:"
echo "   mkdir -p /mnt/storage" 
echo "   mount /dev/sda1 /mnt/storage  # Adjust device as needed"
echo "5. Backup current system (optional):"
echo "   mv /mnt/system /mnt/system_old_\$(date +%Y%m%d)"
echo "6. Restore from backup:"
echo "   rsync -aAXH /mnt/storage/system-backups/CHOSEN_BACKUP/ /mnt/system/"
echo "7. Reinstall GRUB:"
echo "   mount /dev/nvme0n1p2 /mnt/system/boot  # Adjust device as needed"
echo "   mount /dev/nvme0n1p1 /mnt/system/boot/efi  # Adjust device as needed"
echo "   chroot /mnt/system"
echo "   grub-install /dev/nvme0n1  # Adjust device as needed"
echo "   update-grub"
echo "   exit"
echo "8. Reboot"
echo ""
echo "Method 2: SELECTIVE FILE RESTORE (Safe to do while running):"
echo "==========================================================="
echo "1. Mount backup as read-only:"
echo "   sudo mkdir -p /mnt/restore"
echo "   sudo mount --bind /mnt/storage/system-backups/CHOSEN_BACKUP /mnt/restore"
echo "2. Copy specific files you need:"
echo "   sudo cp /mnt/restore/path/to/file /path/to/destination"
echo "3. Unmount when done:"
echo "   sudo umount /mnt/restore"
echo ""
echo "Method 3: RESTORE PACKAGES FROM BACKUP:"
echo "======================================="
echo "1. Find the package list in your backup:"
echo "   cat /mnt/storage/system-backups/CHOSEN_BACKUP/installed_packages.txt"
echo "2. Restore packages:"
echo "   sudo dpkg --set-selections < /mnt/storage/system-backups/CHOSEN_BACKUP/installed_packages.txt"
echo "   sudo apt-get dselect-upgrade"
echo ""
echo "=================================================="
echo "TESTING BEFORE YOU NEED IT:"
echo "=================================================="
echo "Practice restore procedures in a VM first!"
echo "Test selective file restore to verify backups work"
echo "=================================================="

# Show current disk usage
echo ""
echo "Current system status:"
echo "====================="
df -h /
echo ""
echo "Available storage space:"
df -h /mnt/storage
