# Terraform Configuration for Azure Native Observability (Log Analytics & App Insights)
# Author: Angel Jesse Guevara Silvano

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  features {}
}

# 1. Dedicated Resource Group for Observability
resource "azurerm_resource_group" "rg_obs" {
  name     = "rg-${var.project_name}-observability-${var.location}"
  location = var.location
  tags     = var.tags
}

# 2. Azure Log Analytics Workspace (Centralized Telemetry & Logs)
resource "azurerm_log_analytics_workspace" "law" {
  name                = "log-${var.project_name}-${var.environment}"
  location            = azurerm_resource_group.rg_obs.location
  resource_group_name = azurerm_resource_group.rg_obs.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

# 3. Azure Application Insights (APM & Distributed Tracing)
resource "azurerm_application_insights" "appi" {
  name                = "appi-${var.project_name}-${var.environment}"
  location            = azurerm_resource_group.rg_obs.location
  resource_group_name = azurerm_resource_group.rg_obs.name
  workspace_id        = azurerm_log_analytics_workspace.law.id
  application_type    = "web"
  tags                = var.tags
}
