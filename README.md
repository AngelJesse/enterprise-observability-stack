# Enterprise Observability Stack: Prometheus, Grafana & Azure Monitor

[🇺🇸 Read in English](README.md) | [🇪🇸 Leer en Español](README.es.md)

![Prometheus](https://img.shields.io/badge/Metrics-Prometheus%20Time--Series-E6522C?style=for-the-badge&logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Visualization-Grafana%20Analytics-F46800?style=for-the-badge&logo=grafana&logoColor=white)
![Azure Monitor](https://img.shields.io/badge/Cloud-Azure%20Log%20Analytics-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)
![SRE](https://img.shields.io/badge/SRE-4%20Golden%20Signals%20%7C%20SLO%2099.9%25-brightgreen?style=for-the-badge&logo=datadog&logoColor=white)
![Alertmanager](https://img.shields.io/badge/Alerting-Alertmanager%20Incident%20Router-critical?style=for-the-badge&logo=pagerduty&logoColor=white)

---

## 📌 Executive Summary & Business Case

In large-scale production environments, service health cannot be simplified to "server up or down." Silent degradations (latency spikes, memory leaks, and surging HTTP 500 error rates) cause direct business loss if not flagged before end users encounter disruptions.

In **Site Reliability Engineering (SRE) and Platform Engineering**, observability is anchored in the **M.E.L.T. model (Metrics, Events, Logs, Traces)** and the **Google SRE 4 Golden Signals**:
1. **Latency:** Response time percentiles (p50, p90, p99).
2. **Traffic:** System demand measured in requests per second (RPS).
3. **Errors:** Rate of failing requests (HTTP 5xx / 4xx) against total traffic.
4. **Saturation:** Resource fullness across constrained subsystems (CPU, RAM, Disk I/O).

This repository implements a modular, production-ready observability architecture.

---

## 🏗️ Observability Architecture

```
                              ENTERPRISE OBSERVABILITY ARCHITECTURE
                                                │
          ┌─────────────────────────────────────┴─────────────────────────────────────┐
          │                                                                           │
          ▼                                                                           ▼
┌─────────────────────────────────────────────┐             ┌─────────────────────────────────────────────┐
│          TIME-SERIES METRICS ENGINE         │             │        ANALYTICS, DASHBOARDS & ALERTS       │
├─────────────────────────────────────────────┤             ├─────────────────────────────────────────────┤
│ • Prometheus Server (Scrape: 5s interval)   │──Telemetry─▶│ • Grafana UI (Golden Signals Dashboard)    │
│ • Node Exporter (Host CPU, RAM, Disk, Net)  │             │ • Alertmanager (Incident Router & Pager)    │
│ • Cloud Microservice API (/api/v1/metrics)  │             │ • PromQL Rules (SLOs: 99.9% Availability)   │
│ • Azure Log Analytics & App Insights (APM)  │             │ • Automated Synthetic Traffic Generator     │
└─────────────────────────────────────────────┘             └─────────────────────────────────────────────┘
```

---

## 🔐 PromQL Alerting Rules & SRE SLOs

| Alert Name | PromQL Expression | Severity | Operational Impact |
| :--- | :--- | :--- | :--- |
| **`ServiceDown`** | `up == 0` for 15s | **Critical** | Target down; triggers immediate on-call notification. |
| **`HostHighCpuUsage`** | `CPU Saturation > 85%` for 1m | **Warning** | Worker node saturation; latency degradation risk. |
| **`HostMemorySaturation`** | `RAM Usage > 90%` for 1m | **Critical** | Imminent container OOMKill risk. |
| **`HighHttpErrorRate5xx`** | `HTTP 5xx Rate > 5%` for 30s | **Critical** | SLO breach; logic or database connection failure. |
| **`HostDiskFillingUp`** | `Disk Space > 85%` for 2m | **Warning** | Log write freeze risk. |

---

## 📂 Repository Structure

```
enterprise-observability-stack/
├── README.md                               # English Documentation
├── README.es.md                            # Spanish Documentation
├── .gitignore                              # Exclusions
├── docker-compose.yml                      # Prometheus, Grafana, Alertmanager, Node Exporter
├── prometheus/
│   ├── prometheus.yml                      # Central scraping configuration
│   └── alert_rules.yml                     # PromQL Golden Signals alerting rules
├── alertmanager/
│   └── alertmanager.yml                    # Alert routing & deduplication
├── grafana/
│   ├── dashboards/
│   │   └── sre-golden-signals.json         # Declarative SRE dashboard
│   └── provisioning/
│       ├── datasources/datasource.yml      # Automated Prometheus connection
│       └── dashboards/dashboards.yml       # Automated dashboard loader
├── terraform/
│   ├── main.tf                             # Azure Log Analytics & Application Insights
│   ├── variables.tf                        # Variables & tags
│   └── outputs.tf                          # Workspace IDs & connection strings
└── scripts/
    ├── start-observability.ps1             # Suite startup & health verification
    └── generate-traffic-load.ps1           # SRE synthetic traffic generator
```

---

## 🚀 Quickstart & Verification Guide

### 1. Launch Observability Suite
```powershell
.\scripts\start-observability.ps1
```

### 2. Generate Synthetic Traffic for Live Graphs
```powershell
.\scripts\generate-traffic-load.ps1 -TotalRequests 200 -DelayMs 25
```

### 3. Portal Endpoints
* 📊 **Grafana Dashboard:** `http://localhost:3000` (User: `admin` / Password: `admin`)
* 📈 **Prometheus Server:** `http://localhost:9090`
* 🚨 **Alertmanager UI:** `http://localhost:9093`
* 🖥️ **Node Exporter:** `http://localhost:9100/metrics`

### 4. Deploy Azure Monitor via Terraform (Cloud Native)
```bash
cd terraform
terraform init
terraform apply -auto-approve
```
