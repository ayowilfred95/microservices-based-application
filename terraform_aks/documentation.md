Infrastructure Setup Using Terraform and Azure Kubernetes Services (AKS)

This set up and provisioning is the suitable way of provisioning infrastructure in production

The Terraform scripts include configurations for high availability  and scalability, and
security. where in modules/AKS/main.tf file, i declare   # Configure the default node pool
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
  } , 
 

As for the security , a service principal was improvised
