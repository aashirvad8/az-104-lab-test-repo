terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"           # Make sure this RG exists for backend
    storage_account_name = "tfstatestgacfortesting"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# ---------------------------
# Variables
# ---------------------------
variable "rg_Name" {
  type        = string
  description = "Resource Group Name"
}

variable "location" {
  type        = string
  description = "Azure Region"
}

variable "vnet_Name" {
  type        = string
  description = "Virtual Network Name"
}

variable "email_prefix" {
  type        = string
  description = "Email prefix for resources"
}

# ---------------------------
# Resource Group
# ---------------------------
resource "azurerm_resource_group" "rg" {
  name     = var.rg_Name
  location = var.location
}

# ---------------------------
# Virtual Network
# ---------------------------
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_Name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

# ---------------------------
# Windows VM module
# ---------------------------
module "winvm" {
  source              = "../terraform-modules/virtual_machine"
  rg_name             = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  vnet_name           = azurerm_virtual_network.vnet.name
  email_prefix        = var.email_prefix
}
