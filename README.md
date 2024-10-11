# Matrix Synapse Setup Guide 🚀

## Environment Variables 📦

`.env`:
```dotenv
POSTGRES_DB=synapse
POSTGRES_USER=synapse_user
POSTGRES_PASSWORD=your_postgres_password

PGADMIN_DEFAULT_EMAIL=your_pgadmin_email
PGADMIN_DEFAULT_PASSWORD=your_pgadmin_password

AWS_ACCESS_KEY_ID=your_aws_access_key_id
AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key

ENCRYPTION_PASSWORD=your_encryption_password
ENCRYPTION_SALT=your_encryption_salt
```

> **Note**: Ensure your passwords are secure. Consider using a password manager to safely store and generate complex passwords.

## Docker Compose Configuration 🐳

### `docker-compose.yml`
This Docker Compose file sets up a Synapse server, PostgreSQL database, PGAdmin, Sliding Sync, and a backup system all within Docker containers, isolated on an internal network for security.

```yaml
version: '3.8'

networks:
  internal_net:
    driver: bridge

volumes:
  pg_data:
    driver: local
  synapse_data:
    driver: local
  pgadmin_data:
    driver: local
  backup_data:
    driver: local
  sliding_sync_data:
    driver: local
  rclone:
    driver: local

services:
  postgres:
    image: postgres:15
    networks:
      - internal_net
    environment:
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - ./pg_data:/var/lib/postgresql/data

  synapse:
    image: matrixdotorg/synapse:latest
    networks:
      - internal_net
    environment:
      SYNAPSE_CONFIG_PATH: /data/homeserver.yaml
    volumes:
      - ./synapse_data:/data
    depends_on:
      - postgres
    ports:
      - "8008:8008"
    command: >
      bash -c 'if [ ! -f /data/homeserver.yaml ]; then
                  python3 -m synapse.app.homeserver \
                    --server-name matrix.cloud.attraktor.org \
                    --config-path /data/homeserver.yaml \
                    --generate-config \
                    --report-stats=no; fi && \
                python3 -m synapse.app.homeserver \
                --config-path /data/homeserver.yaml'

  sliding_sync:
    image: ghcr.io/matrix-org/sliding-sync:latest
    networks:
      - internal_net
    depends_on:
      - synapse
    ports:
      - "8009:8009"
    environment:
      - SLIDING_SYNC_SERVER_NAME=matrix.cloud.attraktor.org
    volumes:
      - ./sliding_sync_data:/data

  pgadmin:
    image: dpage/pgadmin4
    networks:
      - internal_net
    environment:
      PGADMIN_DEFAULT_EMAIL: ${PGADMIN_DEFAULT_EMAIL}
      PGADMIN_DEFAULT_PASSWORD: ${PGADMIN_DEFAULT_PASSWORD}
    ports:
      - "5050:80"
    volumes:
      - ./pgadmin_data:/var/lib/pgadmin

  backup:
    image: rclone/rclone:latest
    networks:
      - internal_net
    volumes:
      - ./backup_data:/backup
      - ./pg_data:/pg_data:ro
      - ./synapse_data:/synapse_data:ro
      - ./rclone:/config/rclone
    environment:
      AWS_ACCESS_KEY_ID: your_aws_access_key_id
      AWS_SECRET_ACCESS_KEY: your_aws_secret_access_key
    entrypoint: /bin/sh -c
    command: >
      apk add --no-cache bash coreutils && \
      echo '0 2 * * * /backup/backup.sh' | crontab - && \
      crond -f
```

> **Important**: Replace `your_aws_access_key_id` and `your_aws_secret_access_key` with your actual AWS credentials. Ensure these have the proper permissions for your S3 bucket.

## Synapse Configuration 🛠️

### `homeserver.yaml`
This configuration file specifies critical settings for your Synapse instance, including database connections and listener ports.

```yaml
server_name: matrix.cloud.attraktor.org

listeners:
  - port: 8008
    type: http
    resources:
      - names: [client, federation]

  - port: 8009
    type: http
    resources:
      - names: [sliding_sync]

database:
  name: psycopg2
  args:
    user: ${POSTGRES_USER}
    password: ${POSTGRES_PASSWORD}
    database: ${POSTGRES_DB}
    host: postgres
    port: 5432
    cp_min: 5
    cp_max: 10

report_stats: False

logging:
  - module: synapse.storage.SQL
    level: INFO

use_x_forwarded: true
bind_addresses: ['127.0.0.1']
```

> **Note**: Ensure that your ports and domain names are correctly configured to match your deployment environment.

## Nginx Proxy Manager Configuration 🌐

### Custom Headers
These headers are necessary for proxying traffic through Nginx, ensuring correct protocol broadcasting.

```
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $scheme;
```

## Backup Configuration 🗄️

### Backup Script
Create this script in your `backup_data` directory to handle database and data backups, including encryption and upload to S3.

`backup.sh`:
```bash
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
```

> **Important**: Make this script executable: `chmod +x /backup_data/backup.sh`

## Rclone Configuration 🔒

### `rclone.conf`
Configure Rclone for secure encrypted backups to your S3 bucket.

```
[s3-remote]
type = s3
provider = AWS
access_key_id = your_aws_access_key_id
secret_access_key = your_aws_secret_access_key
region = your-region

[encrypted-remote]
type = crypt
remote = s3-remote:bucket-name
filename_encryption = standard
directory_name_encryption = true
# Passwords will be provided from the backup.sh script
```

---

These instructions guide you through setting up a full Matrix Synapse server with Sliding Sync and backups, ensuring robust, secure, and flexible deployment. Adjust configurations as needed to fit your exact deployment scenario and requirements. Good luck with your setup! 👍





Since i didnt keep this up to date, here are some references:

OIDC / SSO:
https://element-hq.github.io/matrix-authentication-service/setup/homeserver.html

Sliding Sync:
https://github.com/matrix-org/sliding-sync/blob/main/README.md