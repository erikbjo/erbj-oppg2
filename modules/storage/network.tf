resource "azurerm_private_endpoint" "storage" {
  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "storage-endpoint-connection"
    private_connection_resource_id = azurerm_storage_account.main.id
    is_manual_connection           = false
    subresource_names = ["blob"]
  }

  depends_on = [
    azurerm_storage_account.main
  ]
}
