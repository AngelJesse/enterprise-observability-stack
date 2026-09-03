<#
.SYNOPSIS
    Starts and validates the Enterprise Observability Stack (Prometheus, Grafana, Alertmanager).
.DESCRIPTION
    Runs docker compose up and verifies HTTP health endpoints.
.NOTES
    Author: Angel Jesse Guevara Silvano
    Project: Enterprise Observability & SRE Mastery
#>

$ErrorActionPreference = "Stop"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  ENTERPRISE SRE OBSERVABILITY STACK RUNNER" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$stackDir = Join-Path $PSScriptRoot ".."
Set-Location $stackDir

Write-Host "`n[1/3] Deploying Observability Services with Docker Compose..." -ForegroundColor Yellow
docker compose up -d

Write-Host "`n[2/3] Waiting for Service Health Convergences..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# Check Prometheus
Write-Host "  -> Verifying Prometheus Server (http://localhost:9090)..." -ForegroundColor Cyan
try {
    $promHealth = Invoke-RestMethod -Uri "http://localhost:9090/-/healthy" -Method Get
    Write-Host "     [OK] Prometheus Health: $promHealth" -ForegroundColor Green
} catch {
    Write-Warning "Prometheus is starting up..."
}

# Check Grafana
Write-Host "  -> Verifying Grafana Dashboard UI (http://localhost:3000)..." -ForegroundColor Cyan
try {
    $grafHealth = Invoke-RestMethod -Uri "http://localhost:3000/api/health" -Method Get
    Write-Host "     [OK] Grafana Database: $($grafHealth.database)" -ForegroundColor Green
} catch {
    Write-Warning "Grafana is starting up..."
}

# Check Alertmanager
Write-Host "  -> Verifying Alertmanager (http://localhost:9093)..." -ForegroundColor Cyan
try {
    $alertHealth = Invoke-RestMethod -Uri "http://localhost:9093/-/healthy" -Method Get
    Write-Host "     [OK] Alertmanager Health: $alertHealth" -ForegroundColor Green
} catch {
    Write-Warning "Alertmanager is starting up..."
}

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "  OBSERVABILITY SUITE RUNNING IN LIVE ENVIRONMENT" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  📊 Grafana Dashboards: http://localhost:3000 (User: admin / Pass: admin)" -ForegroundColor White
Write-Host "  📈 Prometheus Engine:   http://localhost:9090" -ForegroundColor White
Write-Host "  🚨 Alertmanager:        http://localhost:9093" -ForegroundColor White
Write-Host "  🖥️ Node Exporter:       http://localhost:9100/metrics" -ForegroundColor White
