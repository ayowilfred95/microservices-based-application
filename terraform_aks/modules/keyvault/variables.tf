# Name of the Azure Key Vault
variable "keyvault_name" {
    type = string  # Type: string
}

# Location where Azure resources will be created
variable "location" {
    type = string  # Type: string
}

# Name of the Azure Resource Group
variable "resource_group_name" {
    type = string  # Type: string
}

# Name of the service principal to be used for authentication
variable "service_principal_name" {
    type = string  # Type: string
}

# Object ID of the service principal
variable "service_principal_object_id" {
    # Type: string
}

# Tenant ID of the service principal
variable "service_principal_tenant_id" {
    # Type: string
}
