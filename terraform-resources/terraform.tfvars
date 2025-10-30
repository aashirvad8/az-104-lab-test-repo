subscription_id = "8a430bad-846b-42a4-b674-138436f67a00"

## VNET - SUBNET
rg_Name            = "Demo-Test"
location           = "eastus"
vnet_Name          = "vnet-terraform-modulesdev-eus"
vnet_Address       = "178.29.192.0/20"
subnet_NameList    = ["snet-aks-terraform-modulesdev-eus", "snet-agw-terraform-modulesdev-eus", "snet-shared-terraform-modulesdev-eus", "snet-vm-terraform-modulesdev-eus", "GatewaySubnet"]
subnet_AddressList = ["178.29.192.0/26", "178.29.192.64/26", "178.29.192.128/26", "178.29.192.192/26", "178.29.193.0/26"]
vm_pip                 = "public_ip_win"
pip_allocation         = "Dynamic"
vm_nic                 = "win_vm_nic"
ip_configuration       = "ip_config"

### Windows Virtual Machine Deployment
vm_name                = "win-terra-vm"
vm_size                = "Standard_B2s"
vm_username            = "AdminUser"
vm_password            = "Admin@12356"
vm_image_publisher     = "MicrosoftWindowsServer"
vm_image_offer         = "WindowsServer"
vm_image_sku           = "2016-Datacenter"
vm_image_version       = "latest"
vm_os_disk_strg_type   = "Standard_LRS"
vm_os_disk_caching     = "ReadWrite"
