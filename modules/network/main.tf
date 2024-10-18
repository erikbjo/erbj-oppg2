resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  address_space = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet" "subnet" {
  count                = var.subnet_count
  name = format("%s%d", var.subnet_name_prefix, count.index)
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes = format("[10.0.%d.0/24]", count.index)
}
