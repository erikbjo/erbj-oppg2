module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.1"
  suffix = [
    "erbj",
    "operaterra",
    terraform.workspace,
  ]
}

resource "azurerm_resource_group" "main" {
  name     = module.naming.resource_group.name
  location = var.location
  tags     = local.tags
}

### Modules
module "network" {
  source              = "../modules/network"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  subnet_name_prefix = module.naming.subnet.name
  vnet_name          = module.naming.virtual_network.name

  tags = local.tags
}

module "app" {
  source              = "../modules/app"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = module.network.app_subnet_id
  subnet_prefix       = module.network.app_subnet_prefix

  app_gateway_name   = module.naming.application_gateway.name
  linux_web_app_name = module.naming.app_service.name
  public_ip_name     = module.naming.public_ip.name
  service_plan_name  = module.naming.app_service_plan.name

  depends_on = [
    module.network,
  ]

  tags = local.tags
}

module "storage" {
  source              = "../modules/storage"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  storage_account_name = module.naming.storage_account.name

  depends_on = [
    module.network,
  ]

  tags = local.tags
}

module "db" {
  source                        = "../modules/db"
  location                      = azurerm_resource_group.main.location
  resource_group_name           = azurerm_resource_group.main.name
  storage_account_access_key    = module.storage.storage_account_primary_access_key
  storage_primary_blob_endpoint = module.storage.storage_account_blob_endpoint
  subnet_id                     = module.network.main_subnet_id

  private_endpoint_name = module.naming.private_endpoint.name
  mssql_database_name   = module.naming.mssql_database.name
  mssql_server_name     = module.naming.mssql_server.name

  depends_on = [
    module.network,
    module.storage,
  ]

  tags = local.tags
}
