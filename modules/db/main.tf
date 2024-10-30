data "azurerm_client_config" "current" {}

resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
  numeric = false
}

resource "azurerm_mssql_server" "main" {
  name                          = format("erbjmssql-%s", random_string.random.result)
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

  # depends_on = [
  #   azurerm_role_assignment.blob_contributor,
  #   # Other roles to control resourfce creation
  #   azurerm_role_assignment.kv_crypto_officer_sql,
  #   azurerm_role_assignment.kv_secrets_user_sql
  # ]
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

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}
