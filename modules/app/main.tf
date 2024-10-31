resource "azurerm_service_plan" "main" {
  name                   = var.service_plan_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  os_type                = "Linux"
  sku_name               = "P1v2"
  zone_balancing_enabled = true
  worker_count           = var.worker_count

  tags = var.tags
}

resource "azurerm_linux_web_app" "main" {
  location            = var.location
  name                = var.linux_web_app_name
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.main.id
  tags                = var.tags

  public_network_access_enabled = false
  client_certificate_enabled    = true
  https_only                    = true

  # storage_account {}
  # TODO: implement storage account
  # TODO: Health check path

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
    ftps_state    = "FtpsOnly"
  }

  auth_settings {
    enabled = true
  }
}