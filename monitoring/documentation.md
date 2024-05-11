# Enabling Monitoring with Terraform

To enable monitoring for your AKS clusters using Terraform, follow these steps:

1. **Define AKS Cluster Configuration**

```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "aks" {
  name     = "my-aks-rg"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "microservices" {
  name                = "my-aks-cluster"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = "myakscluster"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2s_v3"
  }

  addon_profile {
    oms_agent {
      enabled                   = true
      log_analytics_workspace_id  = azurerm_log_analytics_workspace.example.id
    }
  }
}
```

In this Terraform configuration:

- We define an Azure Resource Group and an AKS cluster.
- Within the `addon_profile`, we enable the Azure Monitor for Containers (formerly known as Container Insights) add-on, which is the monitoring solution for AKS clusters.
- We specify the Log Analytics workspace ID, which is required for storing monitoring data.

2. **Define Log Analytics Workspace Configuration**

You should also create a Log Analytics workspace to store the monitoring data. Add the following code to your Terraform configuration to create the workspace:

```hcl
resource "azurerm_log_analytics_workspace" "container_insight" {
  name                = "log-analytics"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  sku                 = "PerGB2018"
}
```

3. **Initialize Terraform and Apply Configuration**

Run the following Terraform commands in your terminal:

```bash
terraform init
terraform apply
```

Terraform will initialize the project and create the AKS cluster with monitoring enabled. This process may take some time.

4. **Verify Monitoring**

After the deployment is complete, you can verify that monitoring is enabled for your AKS cluster:

- Access the Azure portal, navigate to your AKS cluster, and open the “Monitoring” section to view container insights, performance metrics, and logs.
- You can also use Azure Monitor and Azure Log Analytics to create custom alerts and queries to monitor and troubleshoot your AKS cluster effectively.
