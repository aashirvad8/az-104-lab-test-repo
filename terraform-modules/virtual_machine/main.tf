variable "vm_name_prefix" {
  type        = string
  description = "Prefix used for VM name"
}

variable "location" {
  type        = string
  description = "Azure region for the VM"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group where the VM will be deployed"
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet to attach the VM NIC"
}

variable "admin_username" {
  type        = string
  default     = "azureuser"
  description = "Administrator username for the VM"
}

variable "admin_password" {
  type        = string
  default     = "Password123!" # Replace or use secure secrets
  description = "Administrator password for the VM"
}

provider "azurerm" {
  features {}
}

# Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_name_prefix}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "vm" {
  name                = "${var.vm_name_prefix}-vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B1s"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
