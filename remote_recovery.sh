#!/bin/bash
# Emergency remote recovery script - FIXED VERSION

echo "=== EMERGENCY REMOTE RECOVERY ==="
echo "This script helps recover without physical access"

# Function to restore specific directories
restore_directory() {
    local source_dir="$1"
    local target_dir="$2"
    local backup_path="$3"
    
    if [ -d "$backup_path/$source_dir" ]; then
        echo "Restoring $source_dir..."
        sudo cp -r "$backup_path/$source_dir"/* "$target_dir/" 2>/dev/null || true
        echo "✓ $source_dir restored"
    else
        echo "✗ $source_dir not found in backup"
    fi
}

# Get latest backup directory (not files)
LATEST_BACKUP=$(find /mnt/storage/system-backups/ -maxdepth 1 -type d -name "ubuntu_backup_*" | sort -r | head -1)

if [ -z "$LATEST_BACKUP" ] || [ ! -d "$LATEST_BACKUP" ]; then
    echo "❌ No backup directories found!"
    echo "Available items in system-backups:"
    ls -la /mnt/storage/system-backups/ 2>/dev/null || echo "Directory not accessible"
    exit 1
fi

echo "Using backup: $(basename "$LATEST_BACKUP")"
echo "Backup size: $(sudo du -sh "$LATEST_BACKUP" 2>/dev/null | cut -f1)"
echo ""

echo "Available recovery options:"
echo "1. Restore /etc (system configuration) - SAFE PREVIEW MODE"
echo "2. Restore /home (user data)"
echo "3. Restore packages"
echo "4. Show backup contents"
echo "5. Exit"

read -p "Choose option (1-5): " choice

case $choice in
    1)
        echo "SAFE MODE: Showing what would be restored from /etc..."
        if [ -d "$LATEST_BACKUP/etc" ]; then
            echo "✓ /etc directory found in backup"
            echo "Sample contents:"
            sudo ls -la "$LATEST_BACKUP/etc/" | head -10
            echo ""
            echo "To actually restore (BE CAREFUL - could break remote access):"
            echo "sudo cp -r $LATEST_BACKUP/etc/SPECIFIC_FILE /etc/"
        else
            echo "✗ /etc not found in backup"
        fi
        ;;
    2)
        echo "Checking home directory backup..."
        if [ -d "$LATEST_BACKUP/home" ]; then
            echo "✓ Home directory found in backup"
            sudo ls -la "$LATEST_BACKUP/home/"
            read -p "Restore home directory? (y/N): " confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                restore_directory "home" "/home" "$LATEST_BACKUP"
            fi
        else
            echo "✗ /home not found in backup"
        fi
        ;;
    3)
        echo "Checking package list..."
        if [ -f "$LATEST_BACKUP/installed_packages.txt" ]; then
            echo "✓ Package list found"
            PACKAGE_COUNT=$(wc -l < "$LATEST_BACKUP/installed_packages.txt")
            echo "Found $PACKAGE_COUNT packages"
            read -p "Restore package selection? (y/N): " confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                sudo dpkg --set-selections < "$LATEST_BACKUP/installed_packages.txt"
                sudo apt-get dselect-upgrade
            fi
        else
            echo "✗ Package list not found"
        fi
        ;;
    4)
        echo "Backup contents:"
        sudo ls -la "$LATEST_BACKUP/"
        echo ""
        echo "Backup info:"
        if [ -f "$LATEST_BACKUP/backup_info.txt" ]; then
            sudo cat "$LATEST_BACKUP/backup_info.txt"
        fi
        ;;
    5)
        echo "Exiting recovery script"
        exit 0
        ;;
    *)
        echo "Invalid option"
        ;;
esac

echo "Recovery operation completed"
