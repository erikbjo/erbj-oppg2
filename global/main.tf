resource "azurerm_resource_group" "main" {
  name     = local.backend_config.resource_group_name
  location = var.location
  tags     = local.tags
}

resource "azurerm_storage_account" "main" {
  name                     = local.backend_config.storage_account_name
  location                 = azurerm_resource_group.main.location
  resource_group_name      = azurerm_resource_group.main.name
  account_replication_type = "GRS"
  account_tier             = "Standard"
  min_tls_version          = "TLS1_2"
}

resource "azurerm_storage_container" "main" {
  name                  = local.backend_config.container_name
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}
