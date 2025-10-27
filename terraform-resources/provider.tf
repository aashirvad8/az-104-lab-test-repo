terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}
