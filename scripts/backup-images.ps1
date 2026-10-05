$ErrorActionPreference = "Stop"
Set-Location (Split-Path -Parent $PSScriptRoot)
New-Item -ItemType Directory -Force -Path "images" | Out-Null
$images = @(
  "wazuh/wazuh-indexer:4.9.2",
  "wazuh/wazuh-manager:4.9.2",
  "wazuh/wazuh-dashboard:4.9.2",
  "splunk/splunk:10.4.3",
  "splunk/universalforwarder:10.4.3",
  "cassandra:4.1",
  "docker.elastic.co/elasticsearch/elasticsearch:7.17.24",
  "strangebee/thehive:5.4"
)
foreach ($image in $images) { docker pull $image }
foreach ($image in $images) {
  $safe = $image -replace '[/:]', '_'
  docker image save -o (Join-Path "images" "$safe.tar") $image
}
Write-Host "Offline image backup created in .\images\"
