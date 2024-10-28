data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                          = var.key_vault_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
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

  depends_on = [
    #azurerm_key_vault_access_policy.storage_account_access,
    azurerm_private_endpoint.main,
    azurerm_private_dns_a_record.keyvault_dns_record
  ]
}

resource "azurerm_private_endpoint" "main" {
  name                = "keyvault-private-endpoint"
  resource_group_name = azurerm_key_vault.main.resource_group_name
  location            = azurerm_key_vault.main.location
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "keyvault-private-endpoint-connection"
    private_connection_resource_id = azurerm_key_vault.main.id
    is_manual_connection           = false
    subresource_names = ["vault"]
  }
}

resource "azurerm_private_dns_zone" "keyvault_dns_zone" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "keyvault_dns_zone_link" {
  name                  = "keyvault-dns-zone-link"
  private_dns_zone_name = azurerm_private_dns_zone.keyvault_dns_zone.name
  resource_group_name   = var.resource_group_name
  virtual_network_id    = var.vnet_id
  depends_on = [azurerm_private_dns_zone.keyvault_dns_zone]
}

resource "azurerm_private_dns_a_record" "keyvault_dns_record" {
  name                = azurerm_key_vault.main.name
  zone_name           = azurerm_private_dns_zone.keyvault_dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records = [azurerm_private_endpoint.main.private_service_connection[0].private_ip_address]

  depends_on = [
    azurerm_private_endpoint.main,
    azurerm_private_dns_zone.keyvault_dns_zone
  ]
}

# resource "azurerm_key_vault_access_policy" "sql_server_access" {
#   key_vault_id = azurerm_key_vault.main.id
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   object_id    = var.uai_principal_id
#
#   key_permissions = ["Get", "WrapKey", "UnwrapKey"]
# }