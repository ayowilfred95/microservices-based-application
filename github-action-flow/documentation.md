### Microservices GitHub Repositories

To access the GitHub repositories for each microservice, navigate to the following URLs:

1. **Microservice 1**:
   - GitHub Repository Link: [Microservice 1 Repository](https://github.com/ayowilfred95/packet-tracer)

2. **Microservice 2**:
   - GitHub Repository Link: [Microservice 2 Repository](https://github.com/ayowilfred95/packet-tracer-frontend)


### Workflow

A CI/CD pipeline was set up using GitHub Actions. Credentials were obtained using service principal set up in Terraform:

```bash
az ad sp create-for-rbac --name "aks-getting-started" --role contributor --scopes /subscriptions/62b729bc-acad-4045-b66a-2bc5dd380cf3/resourceGroups/aks-getting-started --sdk-auth
```

Any push to the main branch will trigger the pipeline and run the jobs declared in the pipeline.

A Dockerfile and deployment.yml file were provided with the project to allow fast Docker build and deployment to AKS.

Any process that fails the build stage will not be deployed.

### Deployment

The deployment is of load balancer type, meaning it can be accessed just by the IP address mapped with the default node port which Kubernetes assigned for this particular deployment.

