resource "azurerm_resource_group" "main" {
  name = format("%s-%s", local.naming_conventions.resource_group, local.suffix_kebab_case)
  location = var.location
}

module "network" {
  source              = "./modules/network"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  vnet_name = format("%s-%s", local.naming_conventions.virtual_network, local.suffix_kebab_case)
  subnet_name_prefix = local.naming_conventions.subnet
  # subnet_count = 2
  tags                = local.tags
}
