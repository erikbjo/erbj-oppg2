resource "azurerm_storage_account" "main" {
  name                            = var.storage_account_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "GRS"
  min_tls_version                 = "TLS1_2"
  local_user_enabled              = false
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false
  https_traffic_only_enabled      = true
  tags                            = var.tags

  identity {
    type = "SystemAssigned"
  }

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

  queue_properties {
    logging {
      delete                = true
      read                  = true
      write                 = true
      version               = "1.0"
      retention_policy_days = 10
    }
  }

  network_rules {
    default_action = "Deny"
    bypass = ["AzureServices"]
  }
}

resource "azurerm_role_assignment" "sql_blob_data_contributor" {
  principal_id         = var.uai_principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = azurerm_storage_account.main.id
}

resource "azurerm_storage_account_customer_managed_key" "encryption" {
  storage_account_id = azurerm_storage_account.main.id
  key_vault_id       = var.key_vault_id
  key_name           = var.key_name
  key_version        = var.key_version
}

resource "azurerm_storage_container" "main" {
  name                  = "blobs"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_private_endpoint" "storage" {
  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "storage-endpoint-connection"
    private_connection_resource_id = azurerm_storage_account.main.id
    subresource_names = ["blob"]
    is_manual_connection           = false
  }

  depends_on = [
    azurerm_storage_account.main
  ]
}
