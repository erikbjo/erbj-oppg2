output "storage_account_id" {
  value       = azurerm_storage_account.main.id
  description = "The ID of the storage account"
}

output "storage_account_identity_id" {
  value = azurerm_storage_account.main.identity.principal_id
}

output "storage_account_blob_endpoint" {
  value       = azurerm_storage_account.main.primary_blob_endpoint
  description = "The blob endpoint for the storage account"
}

output "storage_account_primary_access_key" {
  value       = azurerm_storage_account.main.primary_access_key
  description = "The primary access key for the storage account"
  sensitive   = true
}

output "storage_account_primary_connection_string" {
  value       = azurerm_storage_account.main.primary_connection_string
  description = "The primary connection string for the storage account"
  sensitive   = true
}
