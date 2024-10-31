locals {
  backend_config = {
    resource_group_name  = "operaterra-backend"
    storage_account_name = "saoperaterrabackend"
    container_name       = "terraformstate"
    key                  = "operaterra.tfstate"
  }

  tags = {
    owner = "erbj"
  }
}