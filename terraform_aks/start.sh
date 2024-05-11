#!/bin/bash

RESOURCE_GROUP_NAME=backendrg
STORAGE_ACCOUNT_NAME=microservicebackend
CONTAINER_NAME=tfstate

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location westus3

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME


# make sure terraform CLI is installed
terraform

# format the tf files
terraform fmt

# initialize terraform Azure modules
terraform init


# # plan and save the infra changes into tfplan file
# terraform apply --auto-approve



# # apply the infra changes
# terraform apply tfplan

# # delete the infrastructure
# terraform destroy

# # cleanup files
# rm terraform.tfstate
# rm terraform.tfstate.backup
# rm .terraform.lock.hcl
# rm tfplan
# rm tfplan.json
# rm -r .terraform/
