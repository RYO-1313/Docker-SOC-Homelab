# Lab Details

This document is for users who want to understand, troubleshoot, or modify the lab.

## Compose Network

All services use the `soc-net` Docker bridge network:

```text
172.28.0.0/16
```

Static addresses:

```text
172.28.0.10  Wazuh Indexer
172.28.0.11  Wazuh Manager
172.28.0.12  Wazuh Dashboard
172.28.0.20  Splunk
172.28.0.21  Splunk Forwarder
172.28.0.30  Cassandra
172.28.0.31  TheHive Elasticsearch
172.28.0.32  TheHive
```

## Images

The Compose file pins the images used by the lab:

```text
wazuh/wazuh-indexer:4.9.2
wazuh/wazuh-manager:4.9.2
wazuh/wazuh-dashboard:4.9.2
splunk/splunk:10.4.3
splunk/universalforwarder:10.4.3
cassandra:4.1
docker.elastic.co/elasticsearch/elasticsearch:7.17.24
strangebee/thehive:5.4
```

Pinning versions makes fresh installs more reproducible than using `latest`.

## Resource Requirements

The stack is relatively heavy. Give Docker around **8 GB minimum**, with **12 GB preferred**.
If containers are killed or fail during startup, check:

```bash
docker stats
```

and increase Docker Desktop memory if necessary.

## Published Ports

| Host port | Service |
|---:|---|
| 443 | Wazuh Dashboard |
| 514/udp | Wazuh syslog |
| 1514/tcp+udp | Wazuh agent traffic |
| 1515/tcp | Wazuh enrollment |
| 55000/tcp | Wazuh API |
| 8000/tcp | Splunk Web |
| 8088/tcp | Splunk HEC |
| 8089/tcp | Splunk management API |
| 9997/tcp | Splunk receiving |
| 9000/tcp | TheHive |
| 9042/tcp | Cassandra |
| 9200/tcp | Wazuh Indexer |
| 9201/tcp | TheHive Elasticsearch |

The web UIs, APIs, databases, and data ports are bound to `127.0.0.1` by default. Wazuh agent
ports `1514/tcp+udp` and enrollment port `1515/tcp` remain available on the host for optional
remote lab agents. Do not expose the remaining services directly to the Internet.

## Credentials and TLS Material

Credentials are supplied through a local `.env` file. Start by copying `.env.example` to `.env` and
fill in `WAZUH_API_PASSWORD`, `SPLUNK_PASSWORD`, and `THEHIVE_SECRET`. The `THEHIVE_API_KEY` value
is used by the Wazuh-to-TheHive integration; for a first boot it may be left as the placeholder,
then replaced with a real API key created in TheHive. The installer regenerates
`wazuh/config/manager/ossec.conf.generated` from the template and `.env`.

The repository also includes disposable lab TLS material needed to make the stack self-contained.
Do not:

- reuse these credentials elsewhere;
- trust the included certificates outside this lab;
- expose the lab directly to the Internet;
- put real secrets or sensitive data into this repository.

If adapting the project for real use, generate new certificates, passwords, API keys, and use
proper secret management.

## Volumes

Important named volumes include:

```text
wazuh-indexer-data
wazuh-manager-logs
wazuh-manager-etc
wazuh-manager-queue
splunk-data
splunk-etc
splunk-forwarder-data
cassandra-data
elasticsearch-thehive-data
thehive-data
thehive-logs
```

Normal `stop`/`start` operations preserve them. A full reset removes them:

```bash
docker compose down -v --remove-orphans
docker compose up -d
```

## Useful Commands

Validate the configuration:

```bash
docker compose config
```

Check status:

```bash
docker compose ps
```

Follow logs:

```bash
docker compose logs -f
```

Follow one service:

```bash
docker compose logs -f wazuh.manager
```

Restart a service:

```bash
docker compose restart wazuh.manager
```

Inspect resource use:

```bash
docker stats
```

Inspect the network:

```bash
docker network inspect soc-net
```

## Troubleshooting

### Exit code 137

Investigate memory pressure first. Increase Docker memory allocation if necessary.

### Bind-mount errors

Make sure you are running `docker compose` from the repository root and that the referenced
files exist under `wazuh/`, `splunk/`, and `thehive/`.

### Startup takes a long time

That is expected on first launch. Wazuh, Splunk, Cassandra, and Elasticsearch all need
initialization time.

### Inspect service logs

```bash
docker compose logs --tail=200 wazuh.indexer
docker compose logs --tail=200 wazuh.manager
docker compose logs --tail=200 wazuh.dashboard
docker compose logs --tail=200 splunk
docker compose logs --tail=200 splunk-forwarder
docker compose logs --tail=200 cassandra
docker compose logs --tail=200 elasticsearch-thehive
docker compose logs --tail=200 thehive
```

## Offline Image Backup

The normal installation pulls the pinned images from their registries. If you want a completely
offline copy of the images, use:

```powershell
.\scripts\backup-images.ps1
```

The generated `images/*.tar` files are intentionally ignored by Git because they are large.
On another machine, place them in `images/` and run:

```powershell
.\scripts\restore-offline.ps1
```

## Reset Workflow

The intended exercise cycle is:

```text
Start lab
  -> generate activity
  -> investigate
  -> create/manage cases
  -> finish exercise
  -> docker compose down -v
  -> docker compose up -d
  -> fresh lab
```
