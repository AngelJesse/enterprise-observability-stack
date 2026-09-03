<#
.SYNOPSIS
    SRE Synthetic Traffic Generator for Golden Signals Telemetry Verification.
.DESCRIPTION
    Generates distributed HTTP requests against the microservice endpoints to
    populate Prometheus metrics and Grafana graphs in real-time.
.NOTES
    Author: Angel Jesse Guevara Silvano
    Project: Enterprise Observability & SRE Mastery
#>

param(
    [string]$TargetUrl = "http://localhost:8080",
    [int]$TotalRequests = 100,
    [int]$DelayMs = 50
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  SRE SYNTHETIC LOAD & TELEMETRY GENERATOR" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "Target URL: $TargetUrl | Total Requests: $TotalRequests" -ForegroundColor Yellow

$endpoints = @(
    "/",
    "/healthz",
    "/api/v1/info",
    "/api/v1/metrics",
    "/non-existent-endpoint"
)

$successCount = 0
$errorCount = 0

for ($i = 1; $i -le $TotalRequests; $i++) {
    $endpoint = $endpoints | Get-Random
    $fullUrl = "$TargetUrl$endpoint"
    
    try {
        $response = Invoke-WebRequest -Uri $fullUrl -Method Get -TimeoutSec 2 -UseBasicParsing -ErrorAction Stop
        $successCount++
        Write-Host "[$i/$TotalRequests] HTTP $($response.StatusCode) -> $endpoint" -ForegroundColor Green
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        if ($statusCode -eq 404) {
            $errorCount++
            Write-Host "[$i/$TotalRequests] HTTP 404 (Expected Client Error) -> $endpoint" -ForegroundColor DarkYellow
        } else {
            $errorCount++
            Write-Host "[$i/$TotalRequests] Connection Error: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    
    Start-Sleep -Milliseconds $DelayMs
}

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "  LOAD GENERATION COMPLETED" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Successful Requests: $successCount" -ForegroundColor Green
Write-Host "  4xx/5xx Errors:      $errorCount" -ForegroundColor Yellow
Write-Host "  Check live metrics at: http://localhost:3000" -ForegroundColor Cyan
