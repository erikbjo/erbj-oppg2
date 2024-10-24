output "subnet_ids" {
  value       = azurerm_subnet.subnet[*].id
  description = "The IDs of the created subnets"
}

output "vnet_id" {
  value       = azurerm_virtual_network.main.id
  description = "The ID of the created virtual network"
}