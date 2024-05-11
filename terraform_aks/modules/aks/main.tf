# Datasource to get Latest Azure AKS latest Version
data "azurerm_kubernetes_service_versions" "current" {
  location        = var.location  # Location where the AKS cluster will be created
  include_preview = false  # Exclude preview versions from the list of available versions
}

# Create Azure Kubernetes Service (AKS) cluster
resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                = "microservicesbasedapplications-aks-cluster"  # Name of the AKS cluster
  location            = var.location  # Location where the AKS cluster will be created
  resource_group_name = var.resource_group_name  # Name of the Azure Resource Group where AKS will be created
  dns_prefix          = "${var.resource_group_name}-cluster"  # DNS prefix for the AKS cluster

  # Use the latest available version of Kubernetes
  kubernetes_version  =  data.azurerm_kubernetes_service_versions.current.latest_version

  node_resource_group = "${var.resource_group_name}-nrg"  # Name of the node resource group for AKS

  # Configure the default node pool
  default_node_pool {
    name                = "defaultpool"  # Name of the default node pool
    vm_size             = "Standard_DS2_v2"  # Size of virtual machines in the default node pool
    zones               = [1, 2, 3]  # Availability zones for the default node pool
    enable_auto_scaling = true  # Enable auto scaling for the default node pool
    max_count           = 2  # Maximum number of nodes in the default node pool
    min_count           = 1  # Minimum number of nodes in the default node pool
    os_disk_size_gb     = 30  # Size of the OS disk for nodes in the default node pool
    type                = "VirtualMachineScaleSets"  # Type of node pool
    # Define labels for nodes in the default node pool
    node_labels = {
      "nodepool-type" = "system"
      "environment"   = "prod"
      "nodepoolos"    = "linux"
    }
    # Define tags for nodes in the default node pool
    tags = {
      "nodepool-type" = "system"
      "environment"   = "prod"
      "nodepoolos"    = "linux"
    }
  }

  # Configure service principal for AKS authentication
  service_principal {
    client_id     = var.client_id  # Client ID of the service principal
    client_secret = var.client_secret  # Client secret of the service principal
  }

  # Configure Linux profile for AKS nodes
  linux_profile {
    admin_username = "ubuntu"  # Admin username for AKS nodes
    ssh_key {
      key_data = file(var.ssh_public_key)  # SSH public key for AKS nodes
    }
  }

  # Configure network profile for AKS
  network_profile {
    network_plugin    = "azure"  # Network plugin for AKS
    load_balancer_sku = "standard"  # SKU of the Azure Load Balancer for AKS
  }
}
