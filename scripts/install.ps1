$ErrorActionPreference = "Stop"
Set-Location (Split-Path -Parent $PSScriptRoot)

Write-Host "=== SOC Docker Lab ===" -ForegroundColor Cyan
docker version | Out-Null
docker compose version | Out-Null

Write-Host "`nValidating Compose configuration..."
docker compose config | Out-Null

Write-Host "`nPulling lab images..."
docker compose pull

Write-Host "`nStarting the lab..."
docker compose up -d

Write-Host "`nCurrent status:"
docker compose ps

Write-Host "`nOpen:"
Write-Host "  Wazuh:  https://localhost"
Write-Host "  Splunk: http://localhost:8000"
Write-Host "  TheHive: http://localhost:9000"
