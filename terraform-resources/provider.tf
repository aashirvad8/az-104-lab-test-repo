terraform {
  required_version = ">= 1.3.0"

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatestgacfortesting"
    container_name       = "tfstate"
    key                  = "${var.email_prefix}-terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.70.0"
    }
  }
}

provider "azurerm" {
  features {}
}
