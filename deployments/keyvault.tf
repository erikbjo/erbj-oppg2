data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name = format("%s%s", local.naming_conventions.key_vault, local.suffix_mumblecase)
  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption   = true
  public_network_access_enabled = false
  sku_name                      = "standard"
  purge_protection_enabled      = true
  soft_delete_retention_days    = 7

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }
}

resource "azurerm_key_vault_key" "master" {
  name            = "master-key"
  key_vault_id    = azurerm_key_vault.main.id
  key_type        = "RSA"
  key_size        = 2048
  expiration_date = "2024-12-01T08:00:00+00:00"
  key_opts = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
}

resource "azurerm_private_endpoint" "main" {
  name                = "keyvault-private-endpoint"
  resource_group_name = azurerm_key_vault.main.resource_group_name
  location            = azurerm_key_vault.main.location
  subnet_id           = module.network.subnet_ids[0]

  private_service_connection {
    name                           = "keyvault-private-endpoint-connection"
    private_connection_resource_id = azurerm_key_vault.main.id
    is_manual_connection           = false
    subresource_names = ["vault"]
  }

  private_dns_zone_group {
    name = "keyvault-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.keyvault_dns_zone.id]
  }
}

resource "azurerm_private_dns_zone" "keyvault_dns_zone" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "keyvault_dns_zone_link" {
  name                  = "keyvault-dns-zone-link"
  private_dns_zone_name = azurerm_private_dns_zone.keyvault_dns_zone.name
  resource_group_name   = azurerm_resource_group.main.name
  virtual_network_id    = module.network.vnet_id
  depends_on = [azurerm_private_dns_zone.keyvault_dns_zone]
}

resource "azurerm_private_dns_a_record" "keyvault_dns_record" {
  name                = azurerm_key_vault.main.name
  zone_name           = azurerm_private_dns_zone.keyvault_dns_zone.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 300
  records = [azurerm_private_endpoint.main.private_service_connection[0].private_ip_address]

  depends_on = [
    azurerm_private_endpoint.main,
    azurerm_private_dns_zone.keyvault_dns_zone
  ]
}

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
  object_id    = module.storage.storage_account_identity_id

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
  object_id    = module.db.mssql_server_principal_id

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
  scope                = module.storage.storage_container_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.db.mssql_server_principal_id
}

resource "azurerm_role_assignment" "kv_crypto_officer_sql" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = module.db.mssql_server_principal_id
}

resource "azurerm_role_assignment" "kv_secrets_user_sql" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.db.mssql_server_principal_id
}

resource "azurerm_role_assignment" "kv_crypto_officer_storage" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = module.storage.storage_account_identity_id
}
