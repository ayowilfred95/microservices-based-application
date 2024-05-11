# Name of the Azure Resource Group
variable "rgname" {
  type        = string                # Type of the variable
  description = "resource group name" # Description of the variable
}

# Location where Azure resources will be deployed
variable "location" {
  type    = string    # Type of the variable
  default = "westus3" # Default value for the variable
}

# Name of the service principal for authentication
variable "service_principal_name" {
  type = string # Type of the variable
}

# Name of the Azure Key Vault for storing secrets
variable "keyvault_name" {
  type = string # Type of the variable
}

# Name of the Azure Container Registry for storing Docker images
variable "acr_name" {
  type        = string     # Type of the variable
  description = "ACR name" # Description of the variable
}
