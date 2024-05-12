### Microservices GitHub Repositories

To access the GitHub repositories for each microservice, navigate to the following URLs:

1. **Microservice 1**:
   - GitHub Repository Link: [Microservice 1 Repository](https://github.com/ayowilfred95/packet-tracer)

2. **Microservice 2**:
   - GitHub Repository Link: [Microservice 2 Repository](https://github.com/ayowilfred95/packet-tracer-frontend)


### Workflow

A CI/CD pipleine was set up using Github Action. Credentials was obtained using service principal set up in terraform 

```bash
az ad sp create-for-rbac --name "aks-getting-started" --role contributor --scopes /subscriptions/62b729bc-acad-4045-b66a-2bc5dd380cf3/resourceGroups/aks-getting-started --sdk-auth
```
Any push to the main branch will trigger the pipeline and runs the jobs declared in the pipeline.

Dockerfile, deployment.yml file was provided with the project to allow fast docker buil and deployment to AKS
