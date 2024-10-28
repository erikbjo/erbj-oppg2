# Principal
resource "azurerm_key_vault_access_policy" "principal_access" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Get", "Create", "Delete", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Purge", "Encrypt", "Decrypt",
    "Sign", "Verify"
  ]
  secret_permissions = [
    "Get", "Set", "Delete", "List"
  ]

  depends_on = [
    azurerm_key_vault.main,
    azurerm_private_endpoint.main
  ]
}

# Storage
resource "azurerm_key_vault_access_policy" "storage_account_access" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.storage_account_identity_id

  key_permissions = [
    "Get", "Create", "Delete", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Purge", "Encrypt", "Decrypt",
    "Sign", "Verify"
  ]
  secret_permissions = ["Get"]

  depends_on = [
    azurerm_key_vault.main,
    azurerm_private_endpoint.main
  ]
}

# Database
resource "azurerm_key_vault_access_policy" "db_access" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.mssql_server_principal_id

  key_permissions = [
    "Get", "Create", "Delete", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Purge", "Encrypt", "Decrypt",
    "Sign", "Verify"
  ]
  secret_permissions = ["Get"]

  depends_on = [
    azurerm_key_vault.main,
    azurerm_private_endpoint.main
  ]
}

resource "azurerm_role_assignment" "blob_contributor" {
  scope                = var.storage_container_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.mssql_server_principal_id
}

resource "azurerm_role_assignment" "kv_crypto_officer_sql" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = var.mssql_server_principal_id
}

resource "azurerm_role_assignment" "kv_secrets_user_sql" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.mssql_server_principal_id
}
