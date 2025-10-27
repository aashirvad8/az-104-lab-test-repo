# -------------------------------
# Resource Group
# -------------------------------
resource "azurerm_resource_group" "rg" {
  name     = var.rg_Name
  location = var.location
}

# -------------------------------
# Backend Storage (TF State)
# -------------------------------
resource "azurerm_resource_group" "backend_rg" {
  name     = var.backend_rg_name
  location = var.location
}

resource "azurerm_storage_account" "backend_sa" {
  name                     = var.backend_sa_name
  resource_group_name      = azurerm_resource_group.backend_rg.name
  location                 = azurerm_resource_group.backend_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  #kind                     = "StorageV2"
}

resource "azurerm_storage_container" "backend_container" {
  name                  = var.backend_container_name
  storage_account_id    = azurerm_storage_account.backend_sa.id
  container_access_type = "private"
}

# -------------------------------
# VNET Module
# -------------------------------
module "vnet01" {
  source             = "../terraform-modules/network"
  vnet_Name          = var.vnet_Name
  rg_Name            = azurerm_resource_group.rg.name
  location           = azurerm_resource_group.rg.location
  vnet_Address       = var.vnet_Address
  subnet_NameList    = var.subnet_NameList
  subnet_AddressList = var.subnet_AddressList
}

# -------------------------------
# Windows VM Module
# -------------------------------
module "winvm" {
  source               = "../terraform-modules/virtual_machine"
  vm_pip               = var.vm_pip
  rg_Name              = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  pip_allocation       = var.pip_allocation
  vm_nic               = var.vm_nic
  ip_configuration     = var.ip_configuration
  vm_name              = var.vm_name
  vm_size              = var.vm_size
  vm_username          = var.vm_username
  vm_password          = var.vm_password
  vm_image_publisher   = var.vm_image_publisher
  vm_image_offer       = var.vm_image_offer
  vm_image_sku         = var.vm_image_sku
  vm_image_version     = var.vm_image_version
  vm_os_disk_strg_type = var.vm_os_disk_strg_type
  vm_os_disk_caching   = var.vm_os_disk_caching

  # safer: use name lookup or variable instead of fixed index
  vm_subnetid          = module.vnet01.subnet_Id[length(var.subnet_NameList) - 2]
}
