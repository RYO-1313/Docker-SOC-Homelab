# SOC Docker Lab

A disposable SOC learning environment built with Docker Compose.

It brings up **Wazuh, Splunk, TheHive, Cassandra, and Elasticsearch** as one local lab.

> **Learning lab only.** Do not expose this deployment directly to the Internet.
> The repository includes lab TLS material. Your `.env` file contains your local credentials and is ignored by Git.

## Requirements

- **Windows:** Docker Desktop + PowerShell
- **Linux:** Docker Engine + Docker Compose plugin
- Recommended: **8–12 GB RAM** available to Docker

## First-time setup

Before starting the lab, create your local `.env` file:

### Linux

```bash
cp .env.example .env
nano .env
```

### Windows PowerShell

```powershell
Copy-Item .env.example .env
notepad .env
```

Fill in these four values:

```dotenv
WAZUH_API_PASSWORD=your-wazuh-password
SPLUNK_PASSWORD=your-splunk-password
THEHIVE_SECRET=your-long-random-secret
THEHIVE_API_KEY=your-thehive-api-key
```

**Important:** `THEHIVE_API_KEY` is created inside TheHive. On the first boot, leave the example placeholder in place; the lab will start, but Wazuh → TheHive integration will not authenticate yet. Create an API key in TheHive, replace the placeholder in `.env`, then run the installer again. The installer regenerates the Wazuh integration configuration from your `.env`.

Never commit `.env`. It is already listed in `.gitignore`. Docker Compose automatically reads `.env` next to `compose.yaml`.

## Windows — Quick Start

1. Clone the repository:

```powershell
git clone https://github.com/RYO-1313/Docker-SOC-Homelab.git
cd Docker-SOC-Homelab
```

2. Complete the **First-time setup** above.

3. Make sure Docker Desktop is running.

4. Start the lab:

```powershell
.\scripts\install.ps1
```

If PowerShell blocks the script:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\install.ps1
```

5. Check the containers:

```powershell
docker compose ps
```

6. Open the services:

- **Wazuh:** https://localhost
- **Splunk:** http://localhost:8000
- **TheHive:** http://localhost:9000

The first startup can take several minutes.

## Linux — Quick Start

1. Clone the repository:

```bash
git clone https://github.com/RYO-1313/Docker-SOC-Homelab.git
cd Docker-SOC-Homelab
```

2. Complete the **First-time setup** above.

3. Make the installer executable and run it:

```bash
chmod +x scripts/install.sh
./scripts/install.sh
```

4. Check the containers:

```bash
docker compose ps
```

5. Open:

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

This lab is intentionally disposable. Resetting deletes the containers and all named Docker volumes, then creates a fresh environment.

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
