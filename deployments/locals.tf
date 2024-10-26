resource "random_string" "random_string_locals" {
  length  = 8
  special = false
  upper   = false
  numeric = false
}

locals {
  tags = {
    owner   = "erbj"
    project = "oppg2"
    client  = "OperaTerra"
  }

  random_string = random_string.random_string_locals.result
  suffix_kebab_case = format("%s-%s-%s-%s", local.tags.owner, local.tags.project, terraform.workspace, local.random_string)
  # mumblecase is used for Azure resources that require only lowercase letters (storage account names, etc.)
  suffix_mumblecase = format("%s%s%s%s", local.tags.owner, local.tags.project, terraform.workspace, local.random_string)

  naming_conventions = {
    resource_group         = "rg"
    storage_account        = "sa"
    virtual_network        = "vnet"
    subnet                 = "subnet"
    service_plan           = "asp"
    load_balancer          = "lb"
    linux_web_app          = "app"
    sql_database           = "sql"
    blob_storage           = "blob"
    mssql_server           = "mssql"
    mssql_db               = "mssqldb"
    private_endpoint       = "pe"
    vnet_link              = "vnetlink"
    key_vault              = "kv"
    user_assigned_identity = "uai"
  }
}
