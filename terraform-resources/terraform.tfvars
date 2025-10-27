subscription_id = "d0866d00-eb92-4775-bfeb-d6fc94acd94e"
location        = "eastus"
rg_Name         = "Demo-Test"

# Backend
backend_rg_name        = "tfstate-rg-new"
backend_sa_name        = "tfstatejayesh4890patil1"
backend_container_name = "tfstate"

# VNET / Subnets
vnet_Name          = "vnet-terraform-modulesdev"
vnet_Address       = "178.29.192.0/20"
subnet_NameList    = ["snet-aks", "snet-agw", "snet-shared", "snet-vm", "GatewaySubnet"]
subnet_AddressList = ["178.29.192.0/26", "178.29.192.64/26", "178.29.192.128/26", "178.29.192.192/26", "178.29.193.0/26"]

# Windows VM
vm_pip               = "public_ip_win"
pip_allocation       = "Dynamic"
vm_nic               = "win_vm_nic"
ip_configuration     = "ip_config"
vm_name              = "win-terra-vm"
vm_size              = "Standard_B2s"
vm_username          = "AdminUser"
vm_password          = "Admin@12356"
vm_image_publisher   = "MicrosoftWindowsServer"
vm_image_offer       = "WindowsServer"
vm_image_sku         = "2016-Datacenter"
vm_image_version     = "latest"
vm_os_disk_strg_type = "Standard_LRS"
vm_os_disk_caching   = "ReadWrite"
