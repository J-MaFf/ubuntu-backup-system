#!/bin/bash

# Quick backup test script
# This creates a small test and verifies the backup system works

BACKUP_DIR="/mnt/storage/system-backups"
TEST_FILE="/tmp/backup_test_$(date +%s).txt"
TEST_CONTENT="Backup test created at $(date)"

echo "=================================================="
echo "Testing Backup System"
echo "=================================================="

# Create a test file
echo "$TEST_CONTENT" > "$TEST_FILE"
echo "Created test file: $TEST_FILE"

# Check if we have any existing backups
echo ""
echo "Checking existing backups..."
if ls "$BACKUP_DIR"/ubuntu_backup_* >/dev/null 2>&1; then
    LATEST_BACKUP=$(ls -t "$BACKUP_DIR"/ubuntu_backup_* | head -1)
    echo "Latest backup found: $(basename "$LATEST_BACKUP")"
    
    # Test if we can access backup contents
    if [ -f "$LATEST_BACKUP/etc/hostname" ]; then
        echo "✓ Backup contains system files (verified /etc/hostname)"
        echo "  Hostname in backup: $(cat "$LATEST_BACKUP/etc/hostname")"
    else
        echo "✗ Backup may be incomplete (missing /etc/hostname)"
    fi
    
    if [ -f "$LATEST_BACKUP/backup_info.txt" ]; then
        echo "✓ Backup info file exists"
        echo "  Backup details:"
        cat "$LATEST_BACKUP/backup_info.txt" | sed 's/^/    /'
    fi
    
    if [ -f "$LATEST_BACKUP/installed_packages.txt" ]; then
        echo "✓ Package list saved"
        PACKAGE_COUNT=$(wc -l < "$LATEST_BACKUP/installed_packages.txt")
        echo "  $PACKAGE_COUNT packages recorded"
    fi
    
    # Show backup size
    BACKUP_SIZE=$(du -sh "$LATEST_BACKUP" 2>/dev/null | cut -f1)
    echo "  Backup size: $BACKUP_SIZE"
    
else
    echo "No backups found. Run the backup script first."
fi

# Clean up test file
rm -f "$TEST_FILE"

echo ""
echo "=================================================="
echo "Test completed"
echo "=================================================="
