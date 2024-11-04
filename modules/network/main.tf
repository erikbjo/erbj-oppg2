resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]

  tags = var.tags
}

resource "azurerm_subnet" "main" {
  name                 = format("%s-main", var.subnet_name_prefix)
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "app" {
  name                 = format("%s-app", var.subnet_name_prefix)
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]

  # delegation {
  #   name = "appServiceDelegation"
  #
  #   service_delegation {
  #     name = "Microsoft.Web/serverFarms"
  #     actions = [
  #       "Microsoft.Network/virtualNetworks/subnets/action"
  #     ]
  #   }
  # }
}
