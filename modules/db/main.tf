data "azurerm_client_config" "current" {}

resource "azurerm_mssql_server" "main" {
  name                          = "example-sqlserver"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "12.0"
  administrator_login           = "4dm1n157r470r"
  administrator_login_password  = "4-v3ry-53cr37-p455w0rd"
  public_network_access_enabled = false
  minimum_tls_version           = "1.2"
  tags                          = var.tags
}

resource "azurerm_mssql_server_extended_auditing_policy" "main" {
  server_id                  = azurerm_mssql_server.main.id
  storage_endpoint           = var.storage_primary_blob_endpoint
  storage_account_access_key = var.storage_account_access_key
  retention_in_days          = 90

  timeouts {
    create = "1h"
    update = "1h"
    delete = "1h"
  }

}

resource "azurerm_mssql_database" "main" {
  name           = "example-db"
  server_id      = azurerm_mssql_server.main.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 4
  read_scale     = true
  sku_name       = "S0"
  zone_redundant = true
  enclave_type   = "VBS"
  ledger_enabled = true
  tags           = var.tags

  #identity {
  #  type = "UserAssigned"
  #  identity_ids = [
  # ??? TODO: Add the identity id here
  #  ]
  #}

  transparent_data_encryption_key_vault_key_id = azurerm_key_vault_key.generated.id

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_key_vault_key" "generated" {
  name            = "mssql-tde-key"
  key_vault_id    = var.key_vault_id
  key_type        = "RSA"
  key_size        = 2048
  expiration_date = "2024-12-01T08:00:00+00:00"

  key_opts = ["unwrapKey", "wrapKey"]
}