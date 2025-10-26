terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"    # 🔹 existing RG for backend storage
    storage_account_name = "tfstatejayesh4890patil1"     # 🔹 must be globally unique
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

#💡 Make sure the storage account + container exist beforehand:
# az storage account create --name tfstatebackendstore --resource-group rg-terraform-backend --location eastus2 --sku Standard_LRS
# az storage container create --name tfstate --account-name tfstatebackendstore
