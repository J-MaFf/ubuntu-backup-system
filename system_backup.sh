#!/bin/bash

# Improved Ubuntu System Backup Script
# This script creates a backup strategy that works with live systems

BACKUP_DIR="/mnt/storage/system-backups"
SNAPSHOT_DIR="/mnt/snapshots/system"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_NAME="ubuntu_backup_$DATE"

echo "=================================================="
echo "Creating system backup: $BACKUP_NAME"
echo "=================================================="

# Create backup directories
sudo mkdir -p "$BACKUP_DIR"
sudo mkdir -p "$SNAPSHOT_DIR"

# Method 1: Use rsync for live system backup (works while system is running)
echo "Creating live system backup using rsync..."
BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"
sudo mkdir -p "$BACKUP_PATH"

# Backup critical system directories
echo "Backing up system directories..."
sudo rsync -aAXH --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/swapfile","/var/cache/*","/var/tmp/*"} / "$BACKUP_PATH/"

if [ $? -eq 0 ]; then
    echo "SUCCESS: System backup created at $BACKUP_PATH"
    
    # Create a manifest file
    echo "Backup created: $(date)" | sudo tee "$BACKUP_PATH/backup_info.txt"
    echo "Hostname: $(hostname)" | sudo tee -a "$BACKUP_PATH/backup_info.txt"
    echo "Kernel: $(uname -r)" | sudo tee -a "$BACKUP_PATH/backup_info.txt"
    echo "Backup method: rsync" | sudo tee -a "$BACKUP_PATH/backup_info.txt"
    
    # Create package list for easy restoration
    dpkg --get-selections | sudo tee "$BACKUP_PATH/installed_packages.txt" >/dev/null
    
    # Backup important configuration
    sudo cp /etc/fstab "$BACKUP_PATH/fstab.backup"
    sudo cp /etc/crypttab "$BACKUP_PATH/crypttab.backup" 2>/dev/null || true
    
    echo "Package list and configuration files backed up"
else
    echo "ERROR: Backup failed"
    exit 1
fi

# Show backup info
echo ""
echo "Backup completed successfully:"
echo "Location: $BACKUP_PATH"
echo "Size: $(sudo du -sh "$BACKUP_PATH" | cut -f1)"
echo ""

# List recent backups
echo "Recent backups:"
ls -lt "$BACKUP_DIR" | head -5

echo "=================================================="
echo "Backup completed successfully!"
echo "=================================================="
