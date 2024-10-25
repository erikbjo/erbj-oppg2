resource "azurerm_resource_group" "main" {
  name = format("%s-%s", local.naming_conventions.resource_group, local.suffix_kebab_case)
  location = var.location
}

module "network" {
  source              = "../modules/network"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  vnet_name = format("%s-%s", local.naming_conventions.virtual_network, local.suffix_kebab_case)
  subnet_name_prefix = local.naming_conventions.subnet
  # subnet_count = 2
  tags                = local.tags
}

module "app" {
  source              = "../modules/app"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_name = format("%s-%s", local.naming_conventions.service_plan, local.suffix_kebab_case)
  linux_web_app_name = format("%s-%s", local.naming_conventions.linux_web_app, local.suffix_kebab_case)
  # worker_count = 3
  tags                = local.tags
}

module "db" {
  source              = "../modules/db"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.tags
}

module "storage" {
  source              = "../modules/storage"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  subnet_id           = module.network.subnet_ids[0]
  vnet_id             = module.network.vnet_id
  tags                = local.tags
  private_endpoint_name = format("%s-%s", local.naming_conventions.private_endpoint, local.suffix_mumblecase)
  storage_account_name = format("%s%s", local.naming_conventions.storage_account, local.suffix_mumblecase)
  vnet_link_name = format("%s-%s", local.naming_conventions.vnet_link, local.suffix_kebab_case)
}