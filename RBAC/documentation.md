# Role-Based Access Control (RBAC) Implementation for Azure Resources with Terraform

## 1. Prepare Your Environment

- **Azure Subscription**: If you're new to Azure, create a free account to get started.
- **Terraform Configuration**: Ensure Terraform is set up in your preferred environment.

## 2. Terraform Code Implementation

1. **Set Up Directory**: Create a directory where you'll work with the Terraform code.
2. **Provider Configuration**: Define the providers required for your Terraform setup. Create a file named `providers.tf` and insert the following configuration:

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
  }
}

provider "azurerm" {
  features {}
}
```

3. **Main Configuration**: Define the main Terraform configuration. Create a file named `main.tf` and insert the following code:

```hcl
# Fetch Azure Active Directory users
data "azuread_user" "aad_user" {
  for_each            = toset(var.avd_users)
  user_principal_name = format("%s", each.key)
}

# Access an existing built-in role
data "azurerm_role_definition" "role" {
  name = "Desktop Virtualization User"
}

# Create an Azure Active Directory group
resource "azuread_group" "aad_group" {
  display_name     = var.aad_group_name
  security_enabled = true
}

# Add members to the Azure Active Directory group
resource "azuread_group_member" "aad_group_member" {
  for_each         = data.azuread_user.aad_user
  group_object_id  = azuread_group.aad_group.id
  member_object_id = each.value["id"]
}

# Assign role to the Azure Active Directory group
resource "azurerm_role_assignment" "role" {
  scope              = azurerm_virtual_desktop_application_group.dag.id
  role_definition_id = data.azurerm_role_definition.role.id
  principal_id       = azuread_group.aad_group.id
}
```

4. **Variables Configuration**: Define variables required for the Terraform configuration. Create a file named `variables.tf` and insert the following code:

```hcl
variable "avd_users" {
  description = "AVD users"
  default = [
    "avduser01@contoso.net",
    "avduser02@contoso.net"
  ]
}

variable "aad_group_name" {
  type        = string
  default     = "AVDUsers"
  description = "Azure Active Directory Group for AVD users"
}
```

5. **Output Configuration**: Define outputs to display after Terraform applies the configuration. Create a file named `output.tf` and insert the following code:

```hcl
output "AVD_user_groupname" {
  description = "Azure Active Directory Group for AVD users"
  value       = azuread_group.aad_group.display_name
}
```

## 3. Initialize Terraform

Initialize Terraform by running the following command. This ensures all required providers are downloaded.

```bash
terraform init -upgrade
```

## 4. Generate and Review Execution Plan

Create an execution plan to review changes before applying them.

```bash
terraform plan -out main.tfplan
```

## 5. Apply Terraform Configuration

Apply the Terraform configuration to provision resources in your Azure environment.

```bash
terraform apply main.tfplan
```

## 6. Clean Up Resources

When resources are no longer needed, follow these steps to clean up:

1. Generate a destroy plan to see what resources will be deleted.

```bash
terraform plan -destroy -out main.destroy.tfplan
```

2. Apply the destroy plan to remove resources.

```bash
terraform apply main.destroy.tfplan
```


