# Azure Administration with Terraform: Monitoring, Logging, and RBAC Setup

## Monitoring and Logging with Azure Monitor and Log Analytics

### 1. Set Up Azure Monitor and Log Analytics

To monitor and log Kubernetes services using Azure Monitor and Log Analytics, you need to integrate these services with your Azure Kubernetes Service (AKS). Here's how you can set this up using Terraform:

1. **Create a Log Analytics Workspace**:
   ```hcl
   resource "azurerm_log_analytics_workspace" "example" {
     name                = "acme-log-analytics"
     location            = "East US"
     resource_group_name = azurerm_resource_group.example.name
     sku                 = "PerGB2018"
   }
   ```

2. **Integrate AKS with Log Analytics**:
   ```hcl
   resource "azurerm_kubernetes_cluster" "example" {
     name                = "acme-aks1"
     location            = azurerm_resource_group.example.location
     resource_group_name = azurerm_resource_group.example.name
     ...
     addon_profile {
       oms_agent {
         enabled                    = true
         log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
       }
     }
   }
   ```

### 2. Define Alerts and Metrics

To set up alerts and metrics, you can use the `azurerm_monitor_metric_alert` resource:

```hcl
resource "azurerm_monitor_metric_alert" "example" {
  name                = "high-cpu-alert"
  resource_group_name = azurerm_resource_group.example.name
  scopes              = [azurerm_kubernetes_cluster.example.id]
  criteria {
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    metric_name      = "cpuUsagePercentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }
  action {
    action_group_id = azurerm_monitor_action_group.example.id
  }
}
```

## Role-Based Access Control (RBAC) with Terraform

### 1. Define Azure AD Groups and Roles

You can manage RBAC for Azure resources by defining Azure AD groups and assigning roles to these groups. Here's an example of setting up an Azure AD group and assigning a role:

1. **Create an Azure AD Group**:
   ```hcl
   resource "azuread_group" "example" {
     display_name     = "KubernetesAdmins"
     security_enabled = true
   }
   ```

2. **Assign a Role to the Group**:
   ```hcl
   resource "azurerm_role_assignment" "example" {
     scope              = azurerm_kubernetes_cluster.example.id
     role_definition_name = "Contributor"
     principal_id       = azuread_group.example.object_id
   }
   ```
