#!/bin/bash

# Extract environment variables for database
POSTGRES_SYNAPSE_USER="${POSTGRES_SYNAPSE_USER:-your_postgres_user}"
POSTGRES_SYNAPSE_PASSWORD="${POSTGRES_SYNAPSE_PASSWORD:-your_postgres_password}"
POSTGRES_SYNAPSE_DB="${POSTGRES_SYNAPSE_DB:-your_postgres_db}"
POSTGRES_SYNAPSE_HOST="${POSTGRES_SYNAPSE_HOST:-postgres-synapse}"
POSTGRES_SYNAPSE_PORT="${POSTGRES_SYNAPSE_PORT:-5432}"
POSTGRES_SYNAPSE_CP_MIN="${POSTGRES_SYNAPSE_CP_MIN:-5}"
POSTGRES_SYNAPSE_CP_MAX="${POSTGRES_SYNAPSE_CP_MAX:-10}"

# Extract environment variables for email configuration
SMTP_HOST="${SMTP_HOST:-your.email.server}"
SMTP_PORT="${SMTP_PORT:-587}"
SMTP_USER="${SMTP_USER:-your-email@address.com}"
SMTP_PASS="${SMTP_PASS:-your-email-password}"
SMTP_REQUIRE_TRANSPORT_SECURITY="${SMTP_REQUIRE_TRANSPORT_SECURITY:-true}"
SMTP_NOTIFY_FROM="${SMTP_NOTIFY_FROM:-your-from-address@address.com}"
SMTP_APP_NAME="${SMTP_APP_NAME:-Attraktor Matrix}"

# Extract environment variables for OIDC configuration
OIDC_IDP_ID="${OIDC_IDP_ID:-keycloak}"
OIDC_IDP_NAME="${OIDC_IDP_NAME:-Attraktor Single Sign-on}"
OIDC_ISSUER="${OIDC_ISSUER:-https://accounts.attraktor.org/realms/attraktor}"
OIDC_CLIENT_ID="${OIDC_CLIENT_ID:-synapse}"
OIDC_CLIENT_SECRET="${OIDC_CLIENT_SECRET:-your-secret}"
OIDC_SCOPES="${OIDC_SCOPES:-["openid", "profile"]}"
OIDC_LOCALPART_TEMPLATE="${OIDC_LOCALPART_TEMPLATE:-{{ user.preferred_username }}}"
OIDC_DISPLAY_NAME_TEMPLATE="${OIDC_DISPLAY_NAME_TEMPLATE:-{{ user.given_name }}}"
OIDC_BACKCHANNEL_LOGOUT="${OIDC_BACKCHANNEL_LOGOUT:-true}"

echo "OLD db.yaml:"
cat ./synapse_data/config/db.yaml.example

# Replace placeholders in db.yaml.example and output to db.yaml
sed -e "s|your_postgres_user|$POSTGRES_SYNAPSE_USER|g" \
    -e "s|your_postgres_password|$POSTGRES_SYNAPSE_PASSWORD|g" \
    -e "s|your_postgres_db|$POSTGRES_SYNAPSE_DB|g" \
    -e "s|postgres|$POSTGRES_SYNAPSE_HOST|g" \
    -e "s|5432|$POSTGRES_SYNAPSE_PORT|g" \
    -e "s|5|$POSTGRES_SYNAPSE_CP_MIN|g" \
    -e "s|10|$POSTGRES_SYNAPSE_CP_MAX|g" \
    ./synapse_data/config/db.yaml.example > ./synapse_data/config/db.yaml

echo "db.yaml has been generated with provided environment variables."
echo "NEW db.yaml:"
cat ./synapse_data/config/db.yaml

echo "OLD email.yaml:"
cat ./synapse_data/config/email.yaml.example

# Replace placeholders in email.yaml.example and output to email.yaml
sed -e "s|your.email.server|$SMTP_HOST|g" \
    -e "s|587|$SMTP_PORT|g" \
    -e "s|your-email@address.com|$SMTP_USER|g" \
    -e "s|your-email-password|$SMTP_PASS|g" \
    -e "s|true|$SMTP_REQUIRE_TRANSPORT_SECURITY|g" \
    -e "s|your-from-address@address.com|$SMTP_NOTIFY_FROM|g" \
    -e "s|Attraktor Matrix|$SMTP_APP_NAME|g" \
    ./synapse_data/config/email.yaml.example > ./synapse_data/config/email.yaml

echo "email.yaml has been generated with provided environment variables."
echo "NEW email.yaml:"
cat ./synapse_data/config/email.yaml

echo "OLD oidc.yaml:"
cat ./synapse_data/config/oidc.yaml.example

# Replace placeholders in oidc.yaml.example and output to oidc.yaml
sed -e "s|keycloak|$OIDC_IDP_ID|g" \
    -e "s|Attraktor Single Sign-on|$OIDC_IDP_NAME|g" \
    -e "s|https://accounts.attraktor.org/realms/attraktor|$OIDC_ISSUER|g" \
    -e "s|synapse|$OIDC_CLIENT_ID|g" \
    -e "s|your-secret|$OIDC_CLIENT_SECRET|g" \
    -e "s|\[\(\"openid\", \"profile\"\)\]|$OIDC_SCOPES|g" \
    -e "s|{{ user.preferred_username }}|$OIDC_LOCALPART_TEMPLATE|g" \
    -e "s|{{ user.given_name }}|$OIDC_DISPLAY_NAME_TEMPLATE|g" \
    -e "s|true|$OIDC_BACKCHANNEL_LOGOUT|g" \
    ./synapse_data/config/oidc.yaml.example > ./synapse_data/config/oidc.yaml

echo "oidc.yaml has been generated with provided environment variables."
echo "NEW oidc.yaml:"
cat ./synapse_data/config/oidc.yaml