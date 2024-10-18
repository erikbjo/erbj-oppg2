output "subnet_ids" {
  value       = azurerm_subnet.subnet[*].id
  description = "The IDs of the created subnets"
}