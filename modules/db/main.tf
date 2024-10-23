data "azurerm_client_config" "current" {}

resource "azurerm_user_assigned_identity" "example" {
  name                = "example-admin"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_mssql_server" "main" {
  name                          = "example-sqlserver"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "12.0"
  administrator_login           = "4dm1n157r470r"
  administrator_login_password  = "4-v3ry-53cr37-p455w0rd"
  public_network_access_enabled = false
  minimum_tls_version           = "1.2"
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

  tags = var.tags

  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.example.id]
  }

  transparent_data_encryption_key_vault_key_id = azurerm_key_vault_key.generated.id

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}

# Create a key vault with access policies which allow for the current user to get, list, create, delete, update, recover, purge and getRotationPolicy
# for the key vault key and also add a key vault access policy for the Microsoft Sql Server instance User Managed Identity to get, wrap, and unwrap key(s)
resource "azurerm_key_vault" "db_key_vault" {
  name                          = "mssqltdeexample"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  enabled_for_disk_encryption   = true
  tenant_id                     = azurerm_user_assigned_identity.example.tenant_id
  soft_delete_retention_days    = 7
  purge_protection_enabled      = true
  public_network_access_enabled = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = ["Get", "List", "Create", "Delete", "Update", "Recover", "Purge", "GetRotationPolicy"]
  }

  access_policy {
    tenant_id = azurerm_user_assigned_identity.example.tenant_id
    object_id = azurerm_user_assigned_identity.example.principal_id

    key_permissions = ["Get", "WrapKey", "UnwrapKey"]
  }

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
  }
}

resource "azurerm_key_vault_key" "generated" {
  depends_on = [azurerm_key_vault.db_key_vault]

  name            = "mssql-tde-key"
  key_vault_id    = azurerm_key_vault.db_key_vault.id
  key_type        = "RSA"
  key_size        = 2048
  expiration_date = "2024-12-01T08:00:00+00:00"

  key_opts = ["unwrapKey", "wrapKey"]
}