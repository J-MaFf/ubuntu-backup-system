#!/bin/bash
# To use Telegram alerts everywhere, add send_notification.py to your PATH:
#   chmod +x /home/joey/homeserver/automation/notification/send_notification.py
#   ln -s /home/joey/homeserver/automation/notification/send_notification.py ~/bin/send_notification
# Now you can call 'send_notification' from any script.


# Ubuntu System Backup Script
# This script creates a complete system backup using rsync

BACKUP_DIR="/mnt/storage/system-backups"
# Use d-m-yyyy_H:MM AM/PM format
DATE=$(date +%d-%m-%Y_%I-%M_%p)
BACKUP_NAME="ubuntu_backup_$DATE"

echo "=================================================="
echo "Creating system backup: $BACKUP_NAME"
echo "=================================================="


# Create backup directory
mkdir -p "$BACKUP_DIR"

echo "Creating live system backup using rsync..."
BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"

mkdir -p "$BACKUP_PATH"

echo "Backing up system directories..."

# Backup critical system directories
echo "Backing up system directories..."
rsync -aAXH --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/swapfile","/var/cache/*","/var/tmp/*"} / "$BACKUP_PATH/"

# Check if backup succeeded
if [ $? -eq 0 ]; then
    echo "SUCCESS: System backup created at $BACKUP_PATH"

    # Create a manifest file
    echo "Backup created: $(date)" | tee "$BACKUP_PATH/backup_info.txt"
    echo "Hostname: $(hostname)" | tee -a "$BACKUP_PATH/backup_info.txt"
    echo "Kernel: $(uname -r)" | tee -a "$BACKUP_PATH/backup_info.txt"
    echo "Backup method: rsync" | tee -a "$BACKUP_PATH/backup_info.txt"

    # Create package list for easy restoration
    dpkg --get-selections | tee "$BACKUP_PATH/installed_packages.txt" >/dev/null

    # Backup important configuration
    cp /etc/fstab "$BACKUP_PATH/fstab.backup"
    cp /etc/crypttab "$BACKUP_PATH/crypttab.backup" 2>/dev/null || true

    echo "Package list and configuration files backed up"

    # Get backup size
    BACKUP_SIZE=$(du -sh "$BACKUP_PATH" | cut -f1)
    # Send Telegram alert for success
    send_notification "✅ System backup completed successfully!\nBackup: $BACKUP_NAME\nLocation: $BACKUP_PATH\nSize: $BACKUP_SIZE\nDate: $(date)\nHostname: $(hostname)"
else
    echo "ERROR: Backup failed"
    # Send Telegram alert for failure
    send_notification "❌ System backup FAILED!\nBackup: $BACKUP_NAME\nLocation: $BACKUP_PATH\nDate: $(date)\nHostname: $(hostname)"
    exit 1
fi

# Show backup info
echo ""
echo "Backup completed successfully:"
echo "Location: $BACKUP_PATH"
echo "Size: $(du -sh "$BACKUP_PATH" | cut -f1)"
echo ""

# List recent backups
echo "Recent backups:"
ls -lt "$BACKUP_DIR" | head -5

echo "=================================================="
echo "Backup completed successfully!"
echo "=================================================="
