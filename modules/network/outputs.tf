output "vnet_id" {
  value       = azurerm_virtual_network.main.id
  description = "The ID of the created virtual network"
}

output "main_subnet_id" {
  value       = azurerm_subnet.main.id
  description = "The ID of the main subnet"
}

output "app_subnet_id" {
  value       = azurerm_subnet.app.id
  description = "The ID of the app subnet"
}
