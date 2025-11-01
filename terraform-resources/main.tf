terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.3.0"

  backend "azurerm" {
    resource_group_name   = "tfstate-rg"                      # must exist beforehand
    storage_account_name  = "tfstatestgacfortesting"         # must exist beforehand
    container_name        = "tfstate"
    key                   = "${var.email_prefix}-terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Variables
variable "email_prefix" {
  type        = string
  description = "Prefix used for resource names"
}

variable "location" {
  type        = string
  default     = "eastus"
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.email_prefix}-rg"
  location = var.location
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.email_prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "${var.email_prefix}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Optional: Windows VM Module (example)
module "winvm" {
  source              = "../terraform-modules/virtual_machine"
  vm_name_prefix      = var.email_prefix
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet.id
}
