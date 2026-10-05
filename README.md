# SOC Docker Lab

A disposable SOC learning environment built with Docker Compose.

It brings up **Wazuh, Splunk, TheHive, Cassandra, and Elasticsearch** as one local lab.

> **Learning lab only.** Do not expose this deployment directly to the Internet.
> The repository contains disposable lab credentials and lab TLS material so a fresh
> clone can start without a secrets-management setup. Never reuse them elsewhere.

## Requirements

- **Windows:** Docker Desktop + PowerShell
- **Linux:** Docker Engine + Docker Compose plugin
- Recommended: **8–12 GB RAM** available to Docker

## Windows — Quick Start

1. Clone the repository (or download and extract it).

```powershell
git clone <YOUR-GITHUB-REPO-URL>
cd soc-docker-lab
```

2. Make sure Docker Desktop is running.

3. Start the lab:

```powershell
.\scripts\install.ps1
```

If PowerShell blocks the script:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\install.ps1
```

4. Check the containers:

```powershell
docker compose ps
```

5. Open the services:

- **Wazuh:** https://localhost
- **Splunk:** http://localhost:8000
- **TheHive:** http://localhost:9000

The first startup can take several minutes.

## Linux — Quick Start

1. Clone the repository:

```bash
git clone <YOUR-GITHUB-REPO-URL>
cd soc-docker-lab
```

2. Make the installer executable and run it:

```bash
chmod +x scripts/install.sh
./scripts/install.sh
```

3. Check the containers:

```bash
docker compose ps
```

4. Open:

- **Wazuh:** https://localhost
- **Splunk:** http://localhost:8000
- **TheHive:** http://localhost:9000

## Stop / Start

Stop without deleting lab data:

```bash
docker compose stop
```

Start again:

```bash
docker compose start
```

## Reset the Lab

This lab is intentionally disposable. Resetting deletes the containers and all
named Docker volumes, then creates a fresh environment.

**Windows:**

```powershell
.\scripts\reset-lab.ps1
```

**Linux:**

```bash
docker compose down -v --remove-orphans
docker compose up -d
```

## Documentation

- **[LAB.md](LAB.md)** — what the lab contains, architecture, services, ports, and learning workflow.
- **[details.md](details.md)** — detailed configuration, operations, troubleshooting, backups, and security notes.
