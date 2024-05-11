# GitHub Action Workflow: Terraform and AKS Deployment

This GitHub Action workflow automates the provisioning of infrastructure using Terraform and the deployment of a Dockerized application (FlightBookingSystemSample) to an Azure Kubernetes Service (AKS) cluster.

## Workflow Overview

The workflow consists of the following steps:

1. **Terraform Initialization and Planning**: Initializes Terraform with backend configuration and generates a plan to preview changes.
2. **Build and Push Docker Image**: Builds a Docker image for the FlightBookingSystemSample application and pushes it to the Azure Container Registry (ACR).
3. **Configure kubectl**: Configures `kubectl` to connect to the Azure Kubernetes Service.
4. **Deploy to AKS**: Deploys the FlightBookingSystemSample application to the AKS cluster using the Kubernetes deployment manifest (`deployment.yaml`).

## Usage

To use this GitHub Action workflow:

1. Ensure that the necessary secrets are configured in the GitHub repository:
   - `ARM_CLIENT_ID`: Azure Service Principal client ID.
   - `ARM_CLIENT_SECRET`: Azure Service Principal client secret.
   - `ARM_TENANT_ID`: Azure Active Directory tenant ID.
   - `ARM_SUBSCRIPTION_ID`: Azure subscription ID.
   - `RESOURCE_GROUP`: Azure Resource Group name.
   - `STORAGE_ACCOUNT`: Azure Storage Account name for Terraform state.
   - `CONTAINER_NAME`: Azure Storage Container name for Terraform state.
   - `AZ_CONTAINER_REGISTRY`: Azure Container Registry name.
   - `AZ_RESOURCE_GROUP`: Azure Resource Group name for AKS.
   - `AZ_KUBERNETES_CLUSTER`: Azure Kubernetes Service (AKS) cluster name.

2. Create a deployment manifest (`deployment.yaml`) for the FlightBookingSystemSample application and place it in the root directory of your repository.

3. Commit and push your changes to trigger the GitHub Action workflow.

## Workflow Steps

### 1. Terraform Initialization and Planning

- **Purpose**: Initializes Terraform with backend configuration and generates a plan to preview changes.
- **Input**: Azure credentials and backend configuration stored as secrets.
- **Output**: Terraform plan.
- **Comments**:
  - Uses Azure Service Principal credentials and backend configuration to initialize Terraform.
  - Generates a Terraform plan to preview infrastructure changes.
  - If triggered by a pull request, adds the plan as a comment to the pull request.

### 2. Build and Push Docker Image

- **Purpose**: Builds a Docker image for the FlightBookingSystemSample application and pushes it to the Azure Container Registry.
- **Input**: Dockerfile and Azure Container Registry credentials stored as secrets.
- **Output**: Docker image pushed to Azure Container Registry.
- **Comments**:
  - Builds a Docker image for the FlightBookingSystemSample application using the provided Dockerfile.
  - Tags the Docker image with the Azure Container Registry URL.
  - Pushes the Docker image to the Azure Container Registry.

### 3. Configure kubectl

- **Purpose**: Configures `kubectl` to connect to the Azure Kubernetes Service.
- **Input**: Azure Kubernetes Service credentials stored as secrets.
- **Output**: Configured `kubectl` for AKS.
- **Comments**:
  - Uses Azure credentials to authenticate and configure `kubectl` for the AKS cluster.

### 4. Deploy to AKS

- **Purpose**: Deploys the FlightBookingSystemSample application to the Azure Kubernetes Service.
- **Input**: Kubernetes deployment manifest (`deployment.yaml`).
- **Output**: Application deployed to AKS.
- **Comments**:
  - Applies the Kubernetes deployment manifest to deploy the FlightBookingSystemSample application to the AKS cluster.
---

