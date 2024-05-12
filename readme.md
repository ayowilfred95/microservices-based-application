# CASE STUDY: DEPLOYMENT AND MANAGEMENT OF A MICROSERVICES-BASED APPLICATION USING TERRAFORM

## Objective 1: Infrastructure Setup Using Terraform and Azure Kubernetes Services (AKS)

**Objective:**
- Use Terraform to define the infrastructure for a Kubernetes cluster in AKS.
- Ensure the Terraform scripts include configurations for high availability, scalability, and security.
- Implement network configurations, storage classes, and any other necessary Azure resources using Terraform.

**Documentation:**
Navigate to the `terraform_aks` folder and read the `documentation.md` file to get started.

## Objective 2: Implement CI/CD Pipelines using GitHub Actions

**Objective:**
- Set up GitHub repositories for each microservice with appropriate branching strategies.
- Develop GitHub Actions workflows for:
  - Running Terraform scripts to provision and update the infrastructure as needed.
  - Continuous integration and deployment of each service to the AKS cluster.
  - Include steps for code linting, unit testing, building Docker images, and deploying them to AKS.

**Documentation:**
Navigate to the `github-action-flow` folder and read the `documentation.md` file. The file has links to GitHub repositories that have microservices application.

## Objective 3: Git Branching Strategies

**Objective:**
- Develop a Git branching strategy suitable for a multi-service application, ensuring seamless collaboration and integration with the CI/CD process.
- Include guidelines on branch naming, branching off, merging strategies, and handling conflicts.

**Documentation:**
Navigate to the `git-branching-strategy` folder and read the `documentation.md` file.

## Objective 4: Azure Administration with Terraform

**Objective:**
- Use Terraform to set up monitoring, logging, and alerts for the Kubernetes services using Azure Monitor and Log Analytics.
- Implement role-based access control (RBAC) for Azure resources through Terraform configurations.

**Documentation:**
Navigate to the `monitoring` folder and check the `documentation.md` file.
