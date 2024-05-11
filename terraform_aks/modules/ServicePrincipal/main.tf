# Retrieve current Azure AD client configuration
data "azuread_client_config" "current" {
  # No specific configuration needed
}

# Create Azure AD application
resource "azuread_application" "main" {
  display_name = var.service_principal_name  # Display name of the Azure AD application
  owners       = [data.azuread_client_config.current.object_id]  # Owners of the Azure AD application
}

# Create Azure AD service principal
resource "azuread_service_principal" "main" {
  application_id               = azuread_application.main.application_id  # Application ID of the Azure AD application
  app_role_assignment_required = true  # Whether app role assignment is required for the service principal
  owners                       = [data.azuread_client_config.current.object_id]  # Owners of the Azure AD service principal
}

# Create Azure AD service principal password
resource "azuread_service_principal_password" "main" {
  service_principal_id = azuread_service_principal.main.object_id  # ID of the Azure AD service principal
}
