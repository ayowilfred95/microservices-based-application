# Output Azure Key Vault ID
output "keyvault_id" {
  value = azurerm_key_vault.kv.id  # ID of the Azure Key Vault
}
