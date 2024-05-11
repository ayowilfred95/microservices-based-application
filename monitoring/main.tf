# Define Azure provider
provider "azurerm" {
  features {}
}

#  Define AKS Cluster Configuration

resource "azurerm_resource_group" "microservicesrg" {
  name     = "microservicesrg"
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
      enabled                    = true
      log_analytics_workspace_id  = azurerm_log_analytics_workspace.example.id
    }
  }
}



# Create diagnostic settings for monitoring Kubernetes services
resource "azurerm_monitor_diagnostic_setting" "microservices_monitoring" {
  name               = "microservices_monitoring"
  target_resource_id = azurerm_kubernetes_cluster.microservices.id

  # Configure logging settings
  log {
    category = "KubeEvents"
    enabled  = true

    # Configure log retention policy
    retention_policy {
      enabled = false
    }
  }

  # Configure metric settings
  metric {
    category = "AllMetrics"

    # Configure metric retention policy
    retention_policy {
      enabled = false
    }
  }
}



# Define Log Analytics Workspace Configuration

resource "azurerm_log_analytics_workspace" "container_insight" {
  name                = "log-analytics"
  location            = azurerm_resource_group.microservicesrg.location
  resource_group_name = azurerm_resource_group.microservices.name
  sku                 = "PerGB2018"
}
