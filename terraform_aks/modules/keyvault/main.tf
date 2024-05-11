# Retrieve current Azure client configuration
data "azurerm_client_config" "current" {
  # No specific configuration needed
}

# Create Azure Key Vault
resource "azurerm_key_vault" "kv" {
  name                        = var.keyvault_name  # Name of the Azure Key Vault
  location                    = var.location  # Location where the Azure Key Vault will be created
  resource_group_name         = var.resource_group_name  # Name of the Azure Resource Group where Key Vault will be created
  enabled_for_disk_encryption = true  # Enable disk encryption for the Key Vault
  tenant_id                   = data.azurerm_client_config.current.tenant_id  # Tenant ID for the Key Vault
  purge_protection_enabled    = false  # Disable purge protection for the Key Vault
  sku_name                    = "premium"  # SKU (pricing tier) for the Key Vault
  soft_delete_retention_days  = 7  # Number of days to retain soft-deleted Key Vault objects
  enable_rbac_authorization   = true  # Enable RBAC authorization for the Key Vault
}
