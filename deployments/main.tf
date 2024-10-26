resource "azurerm_resource_group" "main" {
  name = format("%s-%s", local.naming_conventions.resource_group, local.suffix_kebab_case)
  location = var.location
  tags     = local.tags
}

resource "azurerm_user_assigned_identity" "main" {
  name = format("%s-%s", local.naming_conventions.user_assigned_identity, local.suffix_kebab_case)
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
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

module "app" {
  source              = "../modules/app"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.tags

  service_plan_name = format("%s-%s", local.naming_conventions.service_plan, local.suffix_kebab_case)
  linux_web_app_name = format("%s-%s", local.naming_conventions.linux_web_app, local.suffix_kebab_case)
  # worker_count = 3
}

module "db" {
  source                        = "../modules/db"
  location                      = azurerm_resource_group.main.location
  resource_group_name           = azurerm_resource_group.main.name
  tags                          = local.tags
  key_vault_id                  = module.keyvault.key_vault_id
  storage_account_access_key    = module.storage.storage_account_primary_access_key
  storage_primary_blob_endpoint = module.storage.storage_account_blob_endpoint
  uai_id                        = azurerm_user_assigned_identity.main.id
}

module "storage" {
  source              = "../modules/storage"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = local.tags
  subnet_id           = module.network.subnet_ids[0]
  vnet_id             = module.network.vnet_id
  key_vault_id        = module.keyvault.key_vault_id
  key_name            = module.keyvault.key_name
  key_version         = module.keyvault.key_version
  uai_principal_id    = azurerm_user_assigned_identity.main.principal_id

  private_endpoint_name = format("%s-%s", local.naming_conventions.private_endpoint, local.suffix_mumblecase)
  storage_account_name = format("%s%s", local.naming_conventions.storage_account, local.suffix_mumblecase)
  vnet_link_name = format("%s-%s", local.naming_conventions.vnet_link, local.suffix_kebab_case)
}

module "keyvault" {
  source                      = "../modules/keyvault"
  location                    = azurerm_resource_group.main.location
  resource_group_name         = azurerm_resource_group.main.name
  tags                        = local.tags
  subnet_id                   = module.network.subnet_ids[0]
  storage_account_id          = module.storage.storage_account_id
  storage_account_identity_id = module.storage.storage_account_identity_id
  uai_principal_id            = azurerm_user_assigned_identity.main.principal_id

  key_vault_name = format("%s%s", local.naming_conventions.key_vault, local.suffix_mumblecase)
}
