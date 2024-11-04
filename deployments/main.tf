resource "azurerm_resource_group" "main" {
  name = format("%s-%s", local.naming_conventions.resource_group, local.suffix_kebab_case)
  location = var.location
  tags     = local.tags
}

### Modules
module "network" {
  source              = "../modules/network"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_name_prefix  = local.naming_conventions.subnet
  tags                = local.tags

  vnet_name = format("%s-%s", local.naming_conventions.virtual_network, local.suffix_kebab_case)
}

module "app" {
  source              = "../modules/app"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = module.network.app_subnet_id
  subnet_prefix       = module.network.app_subnet_prefix
  tags                = local.tags

  app_gateway_name = format("%s-%s", local.naming_conventions.app_gateway, local.suffix_kebab_case)
  public_ip_name = format("%s-%s", local.naming_conventions.public_ip, local.suffix_kebab_case)
  service_plan_name = format("%s-%s", local.naming_conventions.service_plan, local.suffix_kebab_case)
  linux_web_app_name = format("%s-%s", local.naming_conventions.linux_web_app, local.suffix_kebab_case)
  # worker_count = 3

  depends_on = [
    module.network,
  ]
}

module "storage" {
  source              = "../modules/storage"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  subnet_id           = module.network.main_subnet_id
  tags                = local.tags

  private_endpoint_name = format("%s-storage-%s", local.naming_conventions.private_endpoint, local.suffix_mumblecase)
  storage_account_name = format("%s%s", local.naming_conventions.storage_account, local.suffix_mumblecase)

  depends_on = [
    module.network,
  ]
}

module "db" {
  source                        = "../modules/db"
  location                      = azurerm_resource_group.main.location
  resource_group_name           = azurerm_resource_group.main.name
  tags                          = local.tags
  storage_account_access_key    = module.storage.storage_account_primary_access_key
  storage_primary_blob_endpoint = module.storage.storage_account_blob_endpoint
  subnet_id                     = module.network.main_subnet_id

  private_endpoint_name = format("%s-db-%s", local.naming_conventions.private_endpoint, local.suffix_mumblecase)

  depends_on = [
    module.network,
    module.storage,
  ]
}
