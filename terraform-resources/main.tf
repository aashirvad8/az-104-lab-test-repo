###############################################
# Variables from Workflow
###############################################
variable "email_prefix" {
  description = "Prefix derived from user email (before @)"
  type        = string
}

###############################################
# Try to find existing Resource Group (optional)
###############################################
data "azurerm_resource_group" "existing" {
  count = 1
  name  = var.rg_Name
}

# We’ll use a try() expression later so Terraform doesn’t fail
# if the RG doesn’t exist yet.

###############################################
# Create Resource Group if not found
###############################################
resource "azurerm_resource_group" "rg" {
  count    = try(data.azurerm_resource_group.existing[0].name, null) == null ? 1 : 0
  name     = var.rg_Name
  location = var.location
}

locals {
  effective_rg_name = try(
    data.azurerm_resource_group.existing[0].name,
    azurerm_resource_group.rg[0].name
  )
}

###############################################
# VNET & SUBNET Module
###############################################
module "vnet01" {
  source             = "../terraform-modules/network"
  vnet_Name          = "${var.email_prefix}-vnet"
  rg_Name            = local.effective_rg_name
  location           = var.location
  vnet_Address       = var.vnet_Address
  subnet_NameList    = var.subnet_NameList
  subnet_AddressList = var.subnet_AddressList
}

###############################################
# Azure Windows Virtual Machine Module
###############################################
module "winvm" {
  source               = "../terraform-modules/virtual_machine"
  vm_pip               = "${var.email_prefix}-public-ip"
  rg_Name              = local.effective_rg_name
  location             = var.location
  pip_allocation       = var.pip_allocation
  vm_nic               = "${var.email_prefix}-nic"
  ip_configuration     = var.ip_configuration
  vm_name              = "${var.email_prefix}-vm"
  vm_size              = var.vm_size
  vm_username          = var.vm_username
  vm_password          = var.vm_password
  vm_image_publisher   = var.vm_image_publisher
  vm_image_offer       = var.vm_image_offer
  vm_image_sku         = var.vm_image_sku
  vm_image_version     = var.vm_image_version
  vm_os_disk_strg_type = var.vm_os_disk_strg_type
  vm_os_disk_caching   = var.vm_os_disk_caching
  vm_subnetid          = module.vnet01.subnet_Id[3]
}
