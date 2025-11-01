
output "vm_public_ip" {
  value = azurerm_public_ip.vm_pip.ip_address
}

output "vm_name" {
  description = "Name of the created Windows VM"
  value       = azurerm_windows_virtual_machine.vm.name
}

output "vm_private_ip" {
  description = "Private IP address of the VM"
  value       = azurerm_network_interface.nic.private_ip_address
}
