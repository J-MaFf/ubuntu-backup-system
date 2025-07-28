#!/bin/bash

# Configuration Files Backup Script
# Backs up important config files and user data

CONFIG_BACKUP_DIR="/mnt/storage/config-backups"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_NAME="config_backup_$DATE"

echo "=================================================="
echo "Creating configuration backup: $BACKUP_NAME"
echo "=================================================="

# Create backup directory
sudo mkdir -p "$CONFIG_BACKUP_DIR"
BACKUP_PATH="$CONFIG_BACKUP_DIR/$BACKUP_NAME"
sudo mkdir -p "$BACKUP_PATH"

# Backup important configuration directories
echo "Backing up system configuration..."
sudo rsync -aAX /etc/ "$BACKUP_PATH/etc/"
echo "✓ /etc backed up"

echo "Backing up user configurations..."
sudo mkdir -p "$BACKUP_PATH/home/joey"
sudo rsync -aAX /home/joey/ "$BACKUP_PATH/home/joey/" --exclude='.cache' --exclude='.local/share/Trash' --exclude='snap'
echo "✓ Home directory backed up"

echo "Backing up additional important locations..."
sudo rsync -aAX /usr/local/ "$BACKUP_PATH/usr/local/" 2>/dev/null || true
sudo rsync -aAX /opt/ "$BACKUP_PATH/opt/" 2>/dev/null || true
echo "✓ Additional locations backed up"

# Create backup manifest
echo "Creating backup manifest..."
{
    echo "Configuration Backup Created: $(date)"
    echo "Hostname: $(hostname)"
    echo "User: $(whoami)"
    echo "Kernel: $(uname -r)"
    echo "Uptime: $(uptime)"
    echo ""
    echo "Backup contents:"
    echo "- /etc (system configuration)"
    echo "- /home/joey (user data and config)"
    echo "- /usr/local (local installations)"
    echo "- /opt (optional software)"
} | sudo tee "$BACKUP_PATH/backup_manifest.txt" >/dev/null

# Create a list of installed packages
dpkg --get-selections | sudo tee "$BACKUP_PATH/installed_packages.txt" >/dev/null

# Create service status backup
systemctl list-unit-files --type=service | sudo tee "$BACKUP_PATH/service_status.txt" >/dev/null

# Show backup info
BACKUP_SIZE=$(sudo du -sh "$BACKUP_PATH" | cut -f1)
echo ""
echo "Configuration backup completed:"
echo "Location: $BACKUP_PATH"
echo "Size: $BACKUP_SIZE"

# List recent config backups
echo ""
echo "Recent configuration backups:"
ls -lt "$CONFIG_BACKUP_DIR" | head -5

echo "=================================================="
echo "Configuration backup completed successfully!"
echo "=================================================="
