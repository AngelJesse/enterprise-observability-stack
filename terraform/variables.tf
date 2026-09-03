# Input Variables for Observability IaC

variable "project_name" {
  type        = string
  description = "Project name prefix"
  default     = "corplab"
}

variable "environment" {
  type        = string
  description = "Target environment (dev, staging, prod)"
  default     = "prod"
}

variable "location" {
  type        = string
  description = "Azure datacenter region"
  default     = "eastus2"
}

variable "tags" {
  type        = map(string)
  description = "FinOps and Governance Tags"
  default = {
    Environment = "Production"
    ManagedBy   = "Terraform"
    Project     = "Enterprise Observability & SRE"
    CostCenter  = "DevOps-Core"
  }
}
