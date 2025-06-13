#!/bin/bash

BACKUP_LOCATION="/backup"
RESTORE_DIR="/"

# Please run as root!
if [ "$EUID" -ne 0 ]; then
    echo "Please run script as root!"
    exit 1
fi
# Check that backup directory exists
if [ ! -d "$BACKUP_LOCATION" ]; then
    echo "Backup location not found.."
    echo "Creating backup location: $BACKUP_LOCATION"
    if ! mkdir -p "$BACKUP_LOCATION"; then
        echo "ERROR: Failed to create backup location at $BACKUP_LOCATION"
        exit 1
    fi
    echo "Backup location created successfully!"
fi
# Confirmation
read -p "WARNING: This script will restore files directly to /. Continue? (y/n): " CONFIRM
if [[ ! "$CONFIRM" =~ ^[yY](es)?$ ]]; then
    echo "Script aborted by user."
    exit 1
fi
# Loop through each backup file
for FILE in "$BACKUP_LOCATION"/*.tar.gz; do
# Get directory name 
    DIRECTORY_NAME=$(basename "$FILE" .tar.gz)
    # Check that file is a valid backup
    if [ -f "$FILE" ]; then
        # Restore
        echo "Extracting $DIRECTORY_NAME backup.."
        pv "$FILE" | tar -xz -C "$RESTORE_DIR"
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
