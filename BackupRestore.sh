#!/bin/bash

BACKUP_FILE="*.tar.gz"
RESTORE_DIR="/"
# Check that backup file exists
if [ ! -f "$BACKUP_FILE" ]; then
    echo "ERROR: Backup file not found."
    exit 1
fi
# Extracting backup
echo "Extracting backup.."
tar -xvf "$BACKUP_FILE" -C "$RESTORE_DIR"
# Restore system files
echo "Restoring system files.."
