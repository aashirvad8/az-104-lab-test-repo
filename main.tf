provider "azurerm" {
  features {}
}

# -------------------------------
# Resource Group for Deployment
# -------------------------------
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

# -------------------------------
# Resource Group for TF State Backend
# -------------------------------
resource "azurerm_resource_group" "backend_rg" {
  name     = var.backend_rg_name
  location = var.location
}

# -------------------------------
# Storage Account for TF State
# -------------------------------
resource "azurerm_storage_account" "backend_sa" {
  name                     = var.backend_sa_name
  resource_group_name      = azurerm_resource_group.backend_rg.name
  location                 = azurerm_resource_group.backend_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  kind                     = "StorageV2"
}

# -------------------------------
# Container for TF State
# -------------------------------
resource "azurerm_storage_container" "backend_container" {
  name                  = var.backend_container_name
  storage_account_name  = azurerm_storage_account.backend_sa.name
  container_access_type = "private"
}

# -------------------------------
# Example Resource: Virtual Network
# -------------------------------
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = [var.vnet_address]
}

# -------------------------------
# Example Resource: Subnet
# -------------------------------
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_address]
}
