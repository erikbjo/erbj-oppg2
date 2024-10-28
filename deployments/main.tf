resource "azurerm_resource_group" "main" {
  name = format("%s-%s", local.naming_conventions.resource_group, local.suffix_kebab_case)
  location = var.location
  tags     = local.tags
}

data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}

### Modules
module "network" {
  source              = "../modules/network"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.tags
  subnet_name_prefix  = local.naming_conventions.subnet

  vnet_name = format("%s-%s", local.naming_conventions.virtual_network, local.suffix_kebab_case)
  # subnet_count = 2
}

# module "app" {
#   source              = "../modules/app"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
#   tags                = local.tags
#
#   service_plan_name = format("%s-%s", local.naming_conventions.service_plan, local.suffix_kebab_case)
#   linux_web_app_name = format("%s-%s", local.naming_conventions.linux_web_app, local.suffix_kebab_case)
#   # worker_count = 3
# }

# module "keyvault" {
#   source                      = "../modules/keyvault"
#   location                    = azurerm_resource_group.main.location
#   resource_group_name         = azurerm_resource_group.main.name
#   tags                        = local.tags
#   subnet_id                   = module.network.subnet_ids[0]
#   vnet_id                     = module.network.vnet_id
#   storage_account_id          = module.storage.storage_account_id
#   storage_account_identity_id = module.storage.storage_account_identity_id
#   storage_container_id        = module.storage.storage_container_id
#   mssql_server_principal_id   = module.db.mssql_server_principal_id
#
#   key_vault_name = format("%s%s", local.naming_conventions.key_vault, local.suffix_mumblecase)
#
#   depends_on = [
#     module.network,
#   ]
# }


module "db" {
  source                        = "../modules/db"
  location                      = azurerm_resource_group.main.location
  resource_group_name           = azurerm_resource_group.main.name
  tags                          = local.tags
  key_vault_id                  = azurerm_key_vault.main.id
  storage_account_access_key    = module.storage.storage_account_primary_access_key
  storage_primary_blob_endpoint = module.storage.storage_account_blob_endpoint
  storage_account_id            = module.storage.storage_account_id
  storage_container_id          = module.storage.storage_container_id
  master_key_id                 = azurerm_key_vault_key.master.id

  depends_on = [
    module.network,
    azurerm_key_vault.main,
    azurerm_key_vault_key.master
  ]
}

module "storage" {
  source              = "../modules/storage"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = local.tags
  subnet_id           = module.network.subnet_ids[0]
  vnet_id             = module.network.vnet_id
  key_vault_id        = azurerm_key_vault.main.id
  key_name            = azurerm_key_vault_key.master.name
  key_version         = azurerm_key_vault_key.master.version

  private_endpoint_name = format("%s-%s", local.naming_conventions.private_endpoint, local.suffix_mumblecase)
  storage_account_name = format("%s%s", local.naming_conventions.storage_account, local.suffix_mumblecase)
  vnet_link_name = format("%s-%s", local.naming_conventions.vnet_link, local.suffix_kebab_case)

  depends_on = [
    module.network,
    azurerm_key_vault.main,
    azurerm_key_vault_key.master
  ]
}
