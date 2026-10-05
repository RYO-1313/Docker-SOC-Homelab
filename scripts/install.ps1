$ErrorActionPreference = "Stop"
Set-Location (Split-Path -Parent $PSScriptRoot)

Write-Host "=== SOC Docker Lab ===" -ForegroundColor Cyan
docker version | Out-Null
docker compose version | Out-Null

if (-not (Test-Path .env)) {
    Copy-Item .env.example .env
    Write-Host "`nCreated .env from .env.example." -ForegroundColor Yellow
    Write-Host "Edit .env, fill in the four values, then run this installer again."
    exit 1
}

$envValues = @{}
Get-Content .env | ForEach-Object {
    if ($_ -match '^([^#][^=]*)=(.*)$') { $envValues[$matches[1]] = $matches[2] }
}
foreach ($name in @('WAZUH_API_PASSWORD','SPLUNK_PASSWORD','THEHIVE_SECRET')) {
    if (-not $envValues.ContainsKey($name) -or [string]::IsNullOrWhiteSpace($envValues[$name]) -or $envValues[$name] -like 'CHANGE_ME_*') {
        Write-Error "Set $name in .env."
    }
}
$theHiveApiKey = if ($envValues.ContainsKey('THEHIVE_API_KEY') -and $envValues['THEHIVE_API_KEY']) { $envValues['THEHIVE_API_KEY'] } else { 'CHANGE_ME_THEHIVE_API_KEY' }

$template = Get-Content wazuh/config/manager/ossec.conf.template -Raw
$template.Replace('__THEHIVE_API_KEY__', $theHiveApiKey) | Set-Content -NoNewline wazuh/config/manager/ossec.conf.generated

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
