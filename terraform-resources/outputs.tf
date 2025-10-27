output "backend_rg_name" {
  value = azurerm_resource_group.backend_rg.name
}

output "backend_sa_name" {
  value = azurerm_storage_account.backend_sa.name
}

output "backend_container_name" {
  value = azurerm_storage_container.backend_container.name
}
