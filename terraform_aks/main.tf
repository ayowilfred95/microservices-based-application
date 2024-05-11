# Configure Azure provider
provider "azurerm" {
  features {
    # Specify additional features if needed
  }
}

# Create Azure Resource Group
resource "azurerm_resource_group" "rg1" {
  name     = var.rgname   # Name of the Azure Resource Group
  location = var.location # Location where the Azure Resource Group will be created
}

# Assign a role to allow pulling from Azure Container Registry
resource "azurerm_role_assignment" "role_acrpull" {
  scope                            = azurerm_container_registry.acr.id                           # Scope of the role assignment (Azure Container Registry)
  role_definition_name             = "AcrPull"                                                   # Role definition to be assigned (allowing pulling from ACR)
  principal_id                      = module.ServicePrincipal.service_principal_object_id  # ID of the principal (Kubernetes cluster)
  skip_service_principal_aad_check = true                                                        # Skip Azure Active Directory check for service principal
}

# Create Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name                    # Name of the Azure Container Registry
  resource_group_name = azurerm_resource_group.rg1.name # Name of the Azure Resource Group where ACR will be created
  location            = var.location                    # Location where the Azure Container Registry will be created
  sku                 = "Standard"                      # SKU (pricing tier) for the Azure Container Registry
  admin_enabled       = false                           # Disable admin user for the Azure Container Registry

  depends_on = [
    azurerm_resource_group.rg1 # Ensure the Azure Resource Group is created before creating ACR
  ]
}

# Create Service Principal
module "ServicePrincipal" {
  source                 = "./modules/ServicePrincipal"
  service_principal_name = var.service_principal_name # Name of the service principal

  # Ensure the Azure Resource Group is created before creating the service principal
  depends_on = [
    azurerm_resource_group.rg1
  ]
}

# Assign a role to the Service Principal
resource "azurerm_role_assignment" "rolespn" {
  scope                = "/subscriptions/5f5470df-f806-47ee-8f78-6520f817df59" # Scope of the role assignment (Subscription level)
  role_definition_name = "Contributor"                                         # Role definition to be assigned (Contributor role)
  principal_id         = module.ServicePrincipal.service_principal_object_id   # ID of the service principal

  depends_on = [
    module.ServicePrincipal
  ]
}

# Create Azure Key Vault
module "keyvault" {
  source                      = "./modules/keyvault"
  keyvault_name               = var.keyvault_name                                   # Name of the Azure Key Vault
  location                    = var.location                                        # Location where the Azure Key Vault will be created
  resource_group_name         = var.rgname                                          # Name of the Azure Resource Group where Key Vault will be created
  service_principal_name      = var.service_principal_name                          # Name of the service principal
  service_principal_object_id = module.ServicePrincipal.service_principal_object_id # Object ID of the service principal
  service_principal_tenant_id = module.ServicePrincipal.service_principal_tenant_id # Tenant ID of the service principal

  depends_on = [
    module.ServicePrincipal
  ]
}

# Create Key Vault Secret
resource "azurerm_key_vault_secret" "example" {
  name         = module.ServicePrincipal.client_id     # Name of the secret (Client ID)
  value        = module.ServicePrincipal.client_secret # Value of the secret (Client Secret)
  key_vault_id = module.keyvault.keyvault_id           # ID of the Azure Key Vault

  depends_on = [
    module.keyvault
  ]
}

# Create Azure Kubernetes Service (AKS)
module "aks" {
  source                 = "./modules/aks/"
  service_principal_name = var.service_principal_name            # Name of the service principal
  client_id              = module.ServicePrincipal.client_id     # Client ID of the service principal
  client_secret          = module.ServicePrincipal.client_secret # Client secret of the service principal
  location               = var.location                          # Location where the AKS cluster will be created
  resource_group_name    = var.rgname                            # Name of the Azure Resource Group where AKS will be created

  depends_on = [
    module.ServicePrincipal
  ]

}

# Export Kubernetes configuration file (kubeconfig)
resource "local_file" "kubeconfig" {
  depends_on = [module.aks]      # Ensure AKS cluster is created before exporting kubeconfig
  filename   = "./kubeconfig"    # Filepath of the kubeconfig file to be created
  content    = module.aks.config # Configuration content for the kubeconfig
}
