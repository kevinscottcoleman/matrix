#!/bin/bash

export RCLONE_PASSWORD=${ENCRYPTION_PASSWORD}
export RCLONE_SALT=${ENCRYPTION_SALT}

date=$(date +'%Y-%m-%d-%H-%M-%S')
backup_folder="/backup/$date"
mkdir -p "$backup_folder"

echo "Starting backup at $date"

# Database backup
pg_dump -h postgres -U ${POSTGRES_USER} -d ${POSTGRES_DB} -F c > "$backup_folder/db_backup.dump"

# Synapse data backup
tar -czvf "$backup_folder/synapse_data_backup.tar.gz" -C /synapse_data .

# Rclone sync to encrypted remote
rclone --password-command "echo $RCLONE_PASSWORD" --password2-command "echo $RCLONE_SALT" copy "$backup_folder" encrypted-remote:matrix-backups/$date --config /config/rclone/rclone.conf

echo "Backup completed at $(date +'%Y-%m-%d-%H-%M-%S')"

# Clean up after successful backup
rm -rf "$backup_folder"