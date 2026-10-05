$ErrorActionPreference = "Stop"
Set-Location (Split-Path -Parent $PSScriptRoot)
$files = Get-ChildItem "images\*.tar" -File -ErrorAction SilentlyContinue
if (!$files) { throw "No image archives found in .\images\" }
foreach ($file in $files) { docker image load -i $file.FullName }
docker compose up -d
docker compose ps
