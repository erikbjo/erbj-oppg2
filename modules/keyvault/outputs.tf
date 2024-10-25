output "key_vault_id" {
  value       = azurerm_key_vault.main.id
  description = "The ID of the key vault"
}

output "key_name" {
  value = azurerm_key_vault_key.master.name
}

output "key_version" {
  value = azurerm_key_vault_key.master.version
}