resource "azurerm_service_plan" "main" {
  name                = var.service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location

  os_type                = "Linux"
  sku_name               = "P1v2"
  zone_balancing_enabled = true
  worker_count           = var.worker_count

  tags = var.tags
}

resource "azurerm_linux_web_app" "main" {
  name                = var.linux_web_app_name
  resource_group_name = var.resource_group_name
  location            = var.location

  service_plan_id               = azurerm_service_plan.main.id
  public_network_access_enabled = true
  # client_certificate_enabled    = true

  # Gateway not implemented with https
  https_only = false

  storage_account {
    name         = var.storage_account_resource_name
    access_key   = var.storage_account_access_key
    account_name = var.storage_account_name
    share_name   = var.storage_container_name
    type         = "AzureBlob"
  }

  # No health check endpoint

  identity {
    type = "SystemAssigned"
  }

  logs {
    detailed_error_messages = true
    failed_request_tracing  = true

    http_logs {
      file_system {
        retention_in_days = 25
        retention_in_mb   = 50
      }
    }
  }

  site_config {
    http2_enabled = true
    # ftps_state    = "FtpsOnly"
    # always_on = true

    application_stack {
      go_version = "1.19"
    }
  }

  auth_settings {
    enabled = true
  }

  tags = var.tags
}

# See deploy_web_app.yml workflow for how this is used
resource "azurerm_linux_web_app_slot" "restapi" {
  app_service_id = azurerm_linux_web_app.main.id
  name           = "restapi"

  public_network_access_enabled = true

  site_config {
    application_stack {
      go_version = "1.19"
    }
  }

  auth_settings {
    enabled = false
  }
}