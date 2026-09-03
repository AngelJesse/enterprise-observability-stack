# Outputs Definition for Azure Observability Infrastructure

output "log_analytics_workspace_id" {
  value       = azurerm_log_analytics_workspace.law.workspace_id
  description = "The Workspace ID of Azure Log Analytics"
}

output "application_insights_connection_string" {
  value       = azurerm_application_insights.appi.connection_string
  description = "Application Insights Connection String for OpenTelemetry / SRE SDKs"
  sensitive   = true
}

output "application_insights_app_id" {
  value       = azurerm_application_insights.appi.app_id
  description = "The App ID of Application Insights"
}
