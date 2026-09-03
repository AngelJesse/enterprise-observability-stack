# Suite de Observabilidad Enterprise: Prometheus, Grafana & Azure Monitor

[🇺🇸 Read in English](README.md) | [🇪🇸 Leer en Español](README.es.md)

![Prometheus](https://img.shields.io/badge/Metrics-Prometheus%20Time--Series-E6522C?style=for-the-badge&logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Visualization-Grafana%20Analytics-F46800?style=for-the-badge&logo=grafana&logoColor=white)
![Azure Monitor](https://img.shields.io/badge/Cloud-Azure%20Log%20Analytics-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)
![SRE](https://img.shields.io/badge/SRE-4%20Golden%20Signals%20%7C%20SLO%2099.9%25-brightgreen?style=for-the-badge&logo=datadog&logoColor=white)
![Alertmanager](https://img.shields.io/badge/Alerting-Alertmanager%20Incident%20Router-critical?style=for-the-badge&logo=pagerduty&logoColor=white)

---

## 📌 Resumen Ejecutivo y Caso de Negocio

En operaciones de producción a gran escala, la disponibilidad de un sistema no puede medirse únicamente por "servidor encendido o apagado". Los fallos silenciosos (degradación de latencia, fugas de memoria y picos de errores HTTP 500) impactan directamente el negocio si no se detectan antes de que los usuarios reporten el incidente.

En la ingeniería de **Site Reliability Engineering (SRE) y Platform Engineering**, la observabilidad se sustenta en el modelo **M.E.L.T. (Metrics, Events, Logs, Traces)** y en los **4 Golden Signals de Google SRE**:
1. **Latencia:** Tiempo de respuesta por percentiles (p50, p90, p99).
2. **Tráfico:** Demanda del sistema medida en peticiones por segundo (RPS).
3. **Errores:** Tasa de peticiones fallidas (HTTP 5xx / 4xx) respecto al total.
4. **Saturación:** Grado de consumo de los recursos más restringidos (CPU, Memoria RAM, I/O Disco).

Este repositorio implementa una suite de observabilidad completa, desacoplada y automatizada.

---

## 🏗️ Arquitectura de la Solución de Telemetría

```
                              ARQUITECTURA DE OBSERVABILIDAD ENTERPRISE
                                                 │
          ┌──────────────────────────────────────┴──────────────────────────────────────┐
          │                                                                             │
          ▼                                                                             ▼
┌──────────────────────────────────────────────┐              ┌──────────────────────────────────────────────┐
│          TIME-SERIES METRICS ENGINE          │              │        ANALYTICS, DASHBOARDS & ALERTS        │
├──────────────────────────────────────────────┤              ├──────────────────────────────────────────────┤
│ • Prometheus Server (Scrape Interval: 5s)    │──Telemetry──▶│ • Grafana UI (Golden Signals Dashboard)     │
│ • Node Exporter (Host CPU, RAM, Disk, Net)   │              │ • Alertmanager (Incident Router & Pager)     │
│ • Cloud Microservice API (/api/v1/metrics)   │              │ • PromQL Rules (SLOs: 99.9% Availability)    │
│ • Azure Log Analytics & App Insights (APM)   │              │ • Automated Synthetic Traffic Generator      │
└──────────────────────────────────────────────┘              └──────────────────────────────────────────────┘
```

---

## 🔐 Reglas de Alerta PromQL y SLOs Definidos

| Nombre de Alerta | Condición PromQL | Severidad | Impacto Operativo |
| :--- | :--- | :--- | :--- |
| **`ServiceDown`** | `up == 0` por 15s | **Critical** | Servicio o contenedor caído; notificación inmediata a guardia SRE. |
| **`HostHighCpuUsage`** | `CPU Saturation > 85%` por 1m | **Warning** | Sobrecarga de cómputo en nodo worker; riesgo de degradación de latencia. |
| **`HostMemorySaturation`** | `RAM Usage > 90%` por 1m | **Critical** | Riesgo inminente de OOMKill (*Out Of Memory*) en contenedores. |
| **`HighHttpErrorRate5xx`** | `HTTP 5xx Rate > 5%` por 30s | **Critical** | Ruptura de SLA/SLO; fallo lógico o colapso de base de datos. |
| **`HostDiskFillingUp`** | `Disk Space > 85%` por 2m | **Warning** | Riesgo de bloqueo de escritura de logs del sistema. |

---

## 📂 Estructura del Repositorio

```
enterprise-observability-stack/
├── README.md                               # Documentación en Inglés
├── README.es.md                            # Documentación en Español
├── .gitignore                              # Exclusión de bases de datos y temporales
├── docker-compose.yml                      # Orquestación Prometheus, Grafana, Alertmanager, Node Exporter
├── prometheus/
│   ├── prometheus.yml                      # Configuración central de scraping
│   └── alert_rules.yml                     # Reglas de alerta PromQL (Golden Signals)
├── alertmanager/
│   └── alertmanager.yml                    # Enrutamiento y agrupación de incidentes
├── grafana/
│   ├── dashboards/
│   │   └── sre-golden-signals.json         # Dashboard declarativo con paneles SRE
│   └── provisioning/
│       ├── datasources/datasource.yml      # Conexión automática con Prometheus
│       └── dashboards/dashboards.yml       # Carga automática de tableros JSON
├── terraform/
│   ├── main.tf                             # Log Analytics Workspace & Application Insights en Azure
│   ├── variables.tf                        # Parametrización y FinOps tags
│   └── outputs.tf                          # IDs de conexión y workspace
└── scripts/
    ├── start-observability.ps1             # Lanzador y verificador de salud de la suite
    └── generate-traffic-load.ps1           # Generador de carga sintética para telemetría
```

---

## 🚀 Guía de Despliegue y Ejecución

### 1. Iniciar la Suite de Observabilidad
```powershell
.\scripts\start-observability.ps1
```

### 2. Generar Tráfico Sintético para Telemetría en Vivo
```powershell
.\scripts\generate-traffic-load.ps1 -TotalRequests 200 -DelayMs 25
```

### 3. Acceso a los Portales
* 📊 **Grafana Dashboard:** `http://localhost:3000` (Usuario: `admin` / Password: `admin`)
* 📈 **Prometheus Server:** `http://localhost:9090`
* 🚨 **Alertmanager UI:** `http://localhost:9093`
* 🖥️ **Node Exporter:** `http://localhost:9100/metrics`

### 4. Aprovisionar Azure Monitor con Terraform (Nativo en Cloud)
```bash
cd terraform
terraform init
terraform apply -auto-approve
```
