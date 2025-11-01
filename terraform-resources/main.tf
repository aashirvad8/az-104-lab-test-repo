###############################################
# Variables from Workflow
###############################################
variable "email_prefix" {
  description = "Prefix derived from user email (before @)"
  type        = string
}

###############################################
# Try to find existing Resource Group
###############################################
data "azurerm_resource_group" "existing" {
  name = var.rg_Name
  count = try(length(var.rg_Name), 0) > 0 ? 1 : 0

  # Ignore errors if it doesn't exist
  # (Terraform will just create it)
  lifecycle {
    postcondition {
      condition     = true
      error_message = ""
    }
  }
}

###############################################
# Create RG only if not found
###############################################
resource "azurerm_resource_group" "rg" {
  count    = length(data.azurerm_resource_group.existing) > 0 ? 0 : 1
  name     = var.rg_Name
  location = var.location
}

locals {
  effective_rg_name = length(data.azurerm_resource_group.existing) > 0 ? data.azurerm_resource_group.existing[0].name : azurerm_resource_group.rg[0].name
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
