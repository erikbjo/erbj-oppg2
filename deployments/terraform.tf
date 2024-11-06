terraform {
  required_version = "~>1.9.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.8.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.6.3"
    }
  }

  backend "azurerm" {
    resource_group_name  = "operaterra-backend"
    storage_account_name = "saoperaterrabackend"
    container_name       = "terraformstate"
    key                  = "operaterra.tfstate"
  }
}