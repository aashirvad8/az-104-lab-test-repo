##############################################
# Resource Group (Create if not exists)
##############################################

data "azurerm_resource_group" "existing" {
  name = "${var.email_prefix}-rg"
}

resource "azurerm_resource_group" "rg" {
  count    = length(data.azurerm_resource_group.existing.name) > 0 ? 0 : 1
  name     = "${var.email_prefix}-rg"
  location = var.location
}

locals {
  rg_name = length(data.azurerm_resource_group.existing.name) > 0 ? data.azurerm_resource_group.existing.name : azurerm_resource_group.rg[0].name
}

##############################################
# VNET & Subnets
##############################################

module "vnet01" {
  source             = "../terraform-modules/network"
  vnet_Name          = "${var.email_prefix}-vnet"
  rg_Name            = local.rg_name
  location           = var.location
  vnet_Address       = "178.29.192.0/20"
  subnet_NameList    = ["${var.email_prefix}-snet-aks", "${var.email_prefix}-snet-agw", "${var.email_prefix}-snet-shared", "${var.email_prefix}-snet-vm", "GatewaySubnet"]
  subnet_AddressList = ["178.29.192.0/26", "178.29.192.64/26", "178.29.192.128/26", "178.29.192.192/26", "178.29.193.0/26"]
}

##############################################
# Windows VM Deployment
##############################################

module "winvm" {
  source               = "../terraform-modules/virtual_machine"
  vm_pip               = "${var.email_prefix}-vm-pip"
  rg_Name              = local.rg_name
  location             = var.location
  pip_allocation       = "Static"
  vm_nic               = "${var.email_prefix}-vm-nic"
  ip_configuration     = "ipconfig1"
  vm_name              = "${var.email_prefix}-vm"
  vm_size              = "Standard_B2s"
  vm_username          = "AdminUser"
  vm_password          = "Admin@12356"
  vm_image_publisher   = "MicrosoftWindowsServer"
  vm_image_offer       = "WindowsServer"
  vm_image_sku         = "2016-Datacenter"
  vm_image_version     = "latest"
  vm_os_disk_strg_type = "Standard_LRS"
  vm_os_disk_caching   = "ReadWrite"
  vm_subnetid          = module.vnet01.subnet_Id[3]
}

##############################################
# Outputs
##############################################

output "rg_name" {
  value = local.rg_name
}

output "vm_public_ip" {
  value = module.winvm.vm_public_ip
}
