#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

echo "=== SOC Docker Lab ==="
docker version >/dev/null
docker compose version >/dev/null

if [ ! -f .env ]; then
  cp .env.example .env
  echo
  echo "Created .env from .env.example."
  echo "Edit .env, fill in the four values, then run this installer again."
  exit 1
fi

get_env() { sed -n "s/^$1=//p" .env | head -n 1; }
for var in WAZUH_API_PASSWORD SPLUNK_PASSWORD THEHIVE_SECRET; do
  value=$(get_env "$var")
  if [ -z "$value" ] || [ "$value" = "CHANGE_ME_WAZUH_PASSWORD" ] || [ "$value" = "CHANGE_ME_SPLUNK_PASSWORD" ] || [ "$value" = "CHANGE_ME_THEHIVE_SECRET" ]; then
    echo "ERROR: Set $var in .env." >&2
    exit 1
  fi
done

THEHIVE_API_KEY=$(get_env THEHIVE_API_KEY)
if [ -z "$THEHIVE_API_KEY" ]; then
  THEHIVE_API_KEY=CHANGE_ME_THEHIVE_API_KEY
fi
THEHIVE_API_KEY_ESCAPED=$(printf "%s" "$THEHIVE_API_KEY" | sed 's/[&|\\]/\\&/g')

# Generate the Wazuh integration config from the tracked template.
sed "s|__THEHIVE_API_KEY__|$THEHIVE_API_KEY_ESCAPED|g" \
  wazuh/config/manager/ossec.conf.template \
  > wazuh/config/manager/ossec.conf.generated

echo "Validating Compose configuration..."
docker compose config >/dev/null

echo "Pulling lab images..."
docker compose pull
echo "Starting the lab..."
docker compose up -d
echo "Current status:"
docker compose ps
echo "Open:"
echo "  Wazuh:  https://localhost"
echo "  Splunk: http://localhost:8000"
echo "  TheHive: http://localhost:9000"
