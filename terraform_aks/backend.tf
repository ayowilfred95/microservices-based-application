terraform {
  # Configure AzureRM as the backend for storing Terraform state
  backend "azurerm" {
    resource_group_name  = "backendrg"              # Name of the resource group for the backend storage account
    storage_account_name = "microservicebackend"    # Name of the storage account for storing Terraform state
    container_name       = "tfstate"                # Name of the blob container within the storage account
    key                  = "prod.terraform.tfstate" # Name of the Terraform state file
  }
}
