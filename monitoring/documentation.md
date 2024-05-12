### Azure Administration with Terraform: Monitoring, Logging, and RBAC Setup

Using Terraform to manage Azure resources provides a systematic and reproducible method for deploying and managing infrastructure. Below, we outline how to set up monitoring, logging, and alerts for Kubernetes services using Azure Monitor and Log Analytics, as well as implementing Role-Based Access Control (RBAC) for Azure resources.

#### 1. Monitoring and Logging with Azure Monitor and Log Analytics

**Step 1: Create a Log Analytics Workspace**

First, you need a Log Analytics workspace where all logs and metrics will be stored.

```hcl
resource "azurerm_log_analytics_workspace" "example" {
  name                = "example-workspace"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  sku                 = "PerGB2018"
}
```

**Step 2: Attach AKS to Log Analytics Workspace**

Integrate AKS with the Log Analytics workspace for monitoring.

```hcl
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.aks-cluster
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "myaksdns"

  default_node_pool {
    name            = "default"
    node_count      = 3
    vm_size         = "Standard_DS2_v2"
    vnet_subnet_id  = azurerm_subnet.aks_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "calico"
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
    }
  }
}
```

#### 2. Role-Based Access Control (RBAC) for Azure Resources

**Step 1: Define a Role Definition**

Create a custom role definition if the built-in roles do not meet your needs.

```hcl
resource "azurerm_role_definition" "custom_role" {
  name        = "CustomRole"
  scope       = azurerm_resource_group.aks_rg.id
  description = "Custom role description"

  permissions {
    actions     = ["Microsoft.Resources/subscriptions/resourceGroups/read"]
    not_actions = []
  }

  assignable_scopes = [
    azurerm_resource_group.aks_rg.id,
  ]
}
```

**Step 2: Assign Role to a Principal**

Assign the role to a user, group, or service principal.

```hcl
resource "azurerm_role_assignment" "example" {
  scope              = azurerm_resource_group.aks_rg.id
  role_definition_id = azurerm_role_definition.custom_role.id
  principal_id       = var.principal_id
}
```


