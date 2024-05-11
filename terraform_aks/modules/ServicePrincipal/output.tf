# Output the service principal display name
output "service_principal_name" {
  description = "The object id of service principal. Can be used to assign roles to user."  # Description of the output
  value       = azuread_service_principal.main.display_name  # Value of the output
}

# Output the service principal object id
output "service_principal_object_id" {
  description = "The object id of service principal. Can be used to assign roles to user."  # Description of the output
  value       = azuread_service_principal.main.object_id  # Value of the output
}

# Output the service principal tenant id
output "service_principal_tenant_id" {
  value = azuread_service_principal.main.application_tenant_id  # Value of the output
}

# Output the service principal application id
output "service_principal_application_id" {
  description = "The object id of service principal. Can be used to assign roles to user."  # Description of the output
  value       = azuread_service_principal.main.application_id  # Value of the output
}

# Output the client id (application id) of AzureAD application
output "client_id" {
  description = "The application id of AzureAD application created."  # Description of the output
  value       = azuread_application.main.application_id  # Value of the output
}

# Output the client secret (password) for the service principal
output "client_secret" {
  description = "Password for service principal."  # Description of the output
  value       = azuread_service_principal_password.main.value  # Value of the output
}
