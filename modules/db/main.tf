resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
  numeric = false
}

resource "azurerm_mssql_server" "main" {
  name                          = format("mssql-%s", random_string.random.result)
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "12.0"
  administrator_login           = "4dm1n157r470r"
  administrator_login_password  = "4-v3ry-53cr37-p455w0rd"
  public_network_access_enabled = false
  minimum_tls_version           = "1.2"
  tags                          = var.tags

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_mssql_server_extended_auditing_policy" "audit" {
  server_id                               = azurerm_mssql_server.main.id
  storage_endpoint                        = var.storage_primary_blob_endpoint
  storage_account_access_key              = var.storage_account_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = 90
}

resource "azurerm_mssql_database" "main" {
  name           = "operaterra-db"
  server_id      = azurerm_mssql_server.main.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 1
  sku_name       = "S0"
  enclave_type   = "VBS"
  read_scale     = false
  zone_redundant = false
  ledger_enabled = true
  tags           = var.tags

  lifecycle {
    prevent_destroy = false
  }
}
