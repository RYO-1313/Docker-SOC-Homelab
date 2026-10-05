$ErrorActionPreference = "Stop"
Set-Location (Split-Path -Parent $PSScriptRoot)
Write-Host "This deletes all containers and named lab volumes." -ForegroundColor Yellow
$answer = Read-Host "Type RESET to continue"
if ($answer -ne "RESET") { exit 1 }
docker compose down -v --remove-orphans
docker compose up -d
docker compose ps
