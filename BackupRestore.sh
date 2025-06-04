#!/bin/bash

BACKUP_LOCATION="/backup"
RESTORE_DIR="/"
# Check that backup directory exists
if [ ! -d "$BACKUP_LOCATION" ]; then
    echo "ERROR: Backup directory not found."
    exit 1
fi
# Loop through each backup file
for FILE in "$BACKUP_LOCATION"/*.tar.gz; do
# Get directory name 
    DIRECTORY_NAME=$(basename "$FILE" | cut -d '-' -f 1)
    # Check that file is a valid backup
    if [ -f "$FILE" ]; then
        # Restore
        echo "Extracting $DIRECTORY_NAME backup.."
        tar -xvf "$FILE" -C "$RESTORE_DIR"
        # Check status
        if [ $? -eq 0 ]; then
            echo "Restoration of $DIRECTORY_NAME successful."
        else
            echo "ERROR: Restoration of $DIRECTORY_NAME failed."
        fi
    else
        echo "WARNING: $FILE does not exist or is not a file."
    fi
done
echo "Restoration script complete."
