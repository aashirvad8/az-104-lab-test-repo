variable "location" {
  description = "Azure region for resources"
  default     = "East US"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  default     = "az104-sandbox-rg"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default = "AzuerAdmin"
}

variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
  default = "Admin@12345"
  sensitive   = true
}

variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}

variable "tenant_id" {
  type        = string
  description = "Azure Tenant ID"
}

variable "client_id" {
  type        = string
  description = "Azure Client ID (Service Principal)"
}

variable "client_secret" {
  type        = string
  description = "Azure Client Secret"
  sensitive   = true
}
