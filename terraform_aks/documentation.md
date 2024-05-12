# Infrastructure Setup Using Terraform and Azure Kubernetes Services (AKS)

This repository provides Terraform scripts for setting up and provisioning infrastructure on Azure Kubernetes Services (AKS). The setup ensures high availability, scalability, and security for production environments.



## Pre-requisites
```bash
- kubectl cli installed
- Azure CLI installed and logged in
- Storage Account and blob container created to store the tfstate file as backend, you can use below shell script as well
```
## Terraform Configuration

The Terraform scripts include configurations for defining the AKS cluster, including the default node pool settings for high availability and scalability. Below is an excerpt from the `modules/AKS/main.tf` file:

```hcl
# Configure the default node pool
default_node_pool {
  name                = "defaultpool"
  vm_size             = "Standard_DS2_v2"
  zones               = [1, 2, 3]
  enable_auto_scaling = true
  max_count           = 2
  min_count           = 1
  os_disk_size_gb     = 30
  type                = "VirtualMachineScaleSets"

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
```

## Folder structure

In order to follow best practices in Terraform script writing, including modularity,
readability, and maintainability.

- **modules**: The modules folder consist of the azure kubernetes clusters script, keyvalt that stores the state of the infrastructure and service principal for security practices and assigning of roles. 
- **backend.tf**: This file contains the script for creating a storage account and a resource group that will be assigned to the storage account. For modularity purpose, the storage account and the AKS have different resource groups.
- **start.sh**: This file executes the bash shell command that will be used to create the storage account and a resource group dedicated for that storage account.
- **main.tf**: This file has all the imports of modules, the resource group, role assigning, and every logic Terraform script that will provision the infrastructure.

### Security Measures

Security measures are also implemented, including the use of a service principal for authentication. This ensures secure access to the AKS cluster.

## Provisioning AKS Cluster

The AKS cluster is provisioned using Terraform via a service principal. The Terraform configuration creates the following resources:

- Resource Group
- Service Principal
- AKS Cluster using the Service Principal
- Azure Key Vault to store the client secret
- Secret uploaded to Key Vault
- kubeconfig for AKS

### Prerequisites

Before running the Terraform scripts, ensure the following prerequisites are met:

- `kubectl` CLI installed
- Azure CLI installed and logged in
- Storage Account and blob container created to store the `tfstate` file as a backend

### Common Errors

Two common errors that may occur during provisioning are addressed:

1. **Service Principal Not Found**: This error may occur due to a bug in the provider version. Rerunning the `terraform apply` command usually resolves the issue.
2. **Forbidden Error**: This error occurs when the user does not have the necessary permissions, even with the owner role. To resolve this, ensure that the user has the key vault admin role.

## Getting Started

To set up the infrastructure:

1. Run `./start.sh` to create a resource group and a storage account and associate the storage account with the created resource group.
2. Run `terraform init` to initialize the provision.
3. Run `terraform plan` to review the execution plan.
4. Finally, run `terraform apply --auto-approve` to provision the infrastructure.

## Below resources will be created using this terraform configuration:-
```bash
- Resource Group
- Service Principle
- AKS cluster using the SPN
- Azure key vault to store the client secret
- Secret uploaded to key vault
- kubeconfig for AKS
```
