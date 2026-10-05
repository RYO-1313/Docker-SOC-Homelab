#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

echo "=== SOC Docker Lab ==="
docker version >/dev/null
docker compose version >/dev/null

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
