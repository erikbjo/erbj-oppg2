output "gateway_public_ip" {
  description = "The public IP address of the application gateway"
  value       = azurerm_public_ip.public_ip.ip_address
}