terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.0.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }

  backend "azurerm" {
    resource_group_name  = "operaterra-backend"
    storage_account_name = "saoperaterrabackend"
    container_name       = "terraformstate"
    key                  = "operaterra.tfstate"
  }
}