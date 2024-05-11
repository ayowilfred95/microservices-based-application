# Specify required providers and their versions
terraform {
  required_providers {
    azuread = "~> 2.9.0" # Azure Active Directory provider version constraint
    random  = "~> 3.1"   # Random provider version constraint
    azurerm = "~> 3.0.0" # AzureRM provider version constraint
  }
}
