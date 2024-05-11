# Location where Azure resources will be created
variable "location" {
  # Type: string
}

# Name of the Azure Resource Group
variable "resource_group_name" {
  # Type: string
}

# Name of the service principal to be used for authentication
variable "service_principal_name" {
  # Type: string
}

# Path to the SSH public key used for AKS node authentication
variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"  # Default path to SSH public key
}

# Client ID of the service principal used for AKS authentication
variable "client_id" {
  # Type: string
}

# Client secret of the service principal used for AKS authentication
variable "client_secret" {
  # Type: string
  # Sensitive: true
}
