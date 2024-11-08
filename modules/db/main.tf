resource "random_string" "username" {
  length  = 8
  special = false
  numeric = false
  upper   = false
}

resource "random_string" "password" {
  length  = 16
  special = true
  numeric = true
  upper   = true
}

resource "azurerm_mssql_server" "main" {
  name                          = var.mssql_server_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "12.0"
  administrator_login           = var.mssql_administrator_login
  administrator_login_password  = var.mssql_administrator_login_password
  public_network_access_enabled = false
  minimum_tls_version           = "1.2"

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

resource "azurerm_mssql_server_extended_auditing_policy" "audit" {
  server_id                               = azurerm_mssql_server.main.id
  storage_endpoint                        = var.storage_primary_blob_endpoint
  storage_account_access_key              = var.storage_account_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = 90
}

resource "azurerm_mssql_database" "main" {
  name           = var.mssql_database_name
  server_id      = azurerm_mssql_server.main.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 1
  sku_name       = "S0"
  enclave_type   = "VBS"
  read_scale     = false
  zone_redundant = false
  ledger_enabled = true

  lifecycle {
    prevent_destroy = false
  }

  tags = var.tags
}
