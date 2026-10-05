# Lab Contents

## Overview

This is a disposable local SOC learning environment combining endpoint/security monitoring,
log analysis, SIEM workflows, and incident/case management.

## Components

| Component | Image | Purpose | Host port(s) |
|---|---|---|---|
| Wazuh Indexer | `wazuh/wazuh-indexer:4.9.2` | Wazuh search/index backend | `9200` |
| Wazuh Manager | `wazuh/wazuh-manager:4.9.2` | Agents, alerts, monitoring and integrations | `1514/tcp+udp`, `1515`, `514/udp`, `55000` |
| Wazuh Dashboard | `wazuh/wazuh-dashboard:4.9.2` | Wazuh web interface | `443` |
| Splunk | `splunk/splunk:10.4.3` | SIEM/search/log analysis | `8000`, `8088`, `8089`, `9997` |
| Splunk Universal Forwarder | `splunk/universalforwarder:10.4.3` | Forwards Wazuh alert logs to Splunk | internal |
| Cassandra | `cassandra:4.1` | TheHive database | `9042` |
| TheHive Elasticsearch | `docker.elastic.co/elasticsearch/elasticsearch:7.17.24` | TheHive search/index backend | `9201` |
| TheHive | `strangebee/thehive:5.4` | Incident/case management | `9000` |

## Architecture

```text
                         Wazuh Dashboard :443
                                  |
                           Wazuh Manager
                                  |
                        Wazuh Indexer :9200
                                  |
                         Wazuh alert logs
                                  |
                       Splunk Forwarder
                                  |
                           Splunk :8000

              Wazuh alert/integration workflow
                                  |
                              TheHive :9000
                               /         \
                        Cassandra       Elasticsearch
                          :9042             :9201
```

## Learning Goals

- Wazuh agent enrollment and security telemetry
- File Integrity Monitoring (FIM)
- System inventory and SCA
- Vulnerability monitoring concepts
- Wazuh alert investigation
- Forwarding Wazuh alerts into Splunk
- SIEM search and analysis
- Wazuh-to-TheHive integration
- Incident and case management
- Docker networking and service dependencies
- Persistent volumes and clean lab resets

## Configuration Layout

```text
wazuh/config/
├── dashboard/
├── indexer/
└── manager/
    ├── certs/
    ├── integrations/
    └── ossec.conf

splunk/forwarder/
├── inputs.conf
└── outputs.conf

thehive/config/
└── application.conf
```

## Runtime Data

Runtime data lives in Docker named volumes and is intentionally **not stored in GitHub**.
This includes Wazuh data/logs, Splunk data, Cassandra data, TheHive data, and Elasticsearch indexes.

Deleting the volumes resets the lab, which is intentional for learning exercises.

## Typical Exercise

1. Start the lab.
2. Connect/enroll a Wazuh endpoint.
3. Generate endpoint activity.
4. Investigate the resulting Wazuh alerts.
5. Search the forwarded data in Splunk.
6. Send a qualifying alert to TheHive.
7. Investigate/manage it as a case.
8. Reset the lab for the next exercise.
