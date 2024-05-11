# Infrastructure Setup Using Terraform and Azure Kubernetes Services (AKS)

## Azure CLI

You can get the Azure CLI on [Azure-Cli](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) <br/>
Am using mac
We'll need the Azure CLI to gather information so we can build our Terraform file.


## Login to Azure

```
#login and follow prompts
az login 
```

# Grab your `tenantId` and create an environment variable called TENAND_ID
enironment variables helps us to keep our secret out of git

```
TENANT_ID=<your-tenant-id>
```

# view and select your subscription account

```
az account list -o table
```
# Grab your `SubscriptionId` and create an environment variable called  SUBSCRIPTION

```
SUBSCRIPTION=<id>
```


# Just to make sure that any commands i ran runs against this subscription

```
az account set --subscription $SUBSCRIPTION
```


## Create Service Principal
# In order to interact with Azure using terraform Cli, you gonna need a service principle.
service principle is just a service account you can use to interact with your azure infrastructure

Kubernetes needs a service account to manage our Kubernetes cluster </br>
Lets create one! </br>


```

SERVICE_PRINCIPAL_JSON=$(az ad sp create-for-rbac --skip-assignment --name aks-microservice-based-application-sp -o json)
# print out the credentials
echo $SERVICE_PRINCIPAL_JSON

# Keep the `appId` and `password` for later use!

SERVICE_PRINCIPAL=$(echo $SERVICE_PRINCIPAL_JSON | jq -r '.appId')
SERVICE_PRINCIPAL_SECRET=$(echo $SERVICE_PRINCIPAL_JSON | jq -r '.password')

#note: reset the credential if you have any sinlge or double quote on password
az ad sp credential reset --name "aks-getting-started-sp"

# Grant contributor role over the subscription to our service principal, since the service principle you created has no permission

az role assignment create --assignee $SERVICE_PRINCIPAL \
--scope "/subscriptions/$SUBSCRIPTION" \
--role Contributor

This will allow terraform to manage the infrastructure on the subscription
```
 


# Terraform CLI
```
# Get Terraform

curl -o /tmp/terraform.zip -LO https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_linux_amd64.zip

unzip /tmp/terraform.zip
chmod +x terraform && mv terraform /usr/local/bin/

cd terraform-aks/terraform

```

# Generate SSH key

```
ssh-keygen -t rsa -b 4096 -N "VeryStrongSecret123!" -C "your_email@example.com" -q -f  ~/.ssh/id_rsa
SSH_KEY=$(cat ~/.ssh/id_rsa.pub)
echo $SSH_KEY
```


## Terraform Azure Kubernetes Provider 
```
terraform init

terraform plan -var serviceprinciple_id=$SERVICE_PRINCIPAL \
    -var serviceprinciple_key="$SERVICE_PRINCIPAL_SECRET" \
    -var tenant_id=$TENANT_ID \
    -var subscription_id=$SUBSCRIPTION \
    -var ssh_key="$SSH_KEY"

terraform apply -var serviceprinciple_id=$SERVICE_PRINCIPAL \
    -var serviceprinciple_key="$SERVICE_PRINCIPAL_SECRET" \
    -var tenant_id=$TENANT_ID \
    -var subscription_id=$SUBSCRIPTION \
    -var ssh_key="$SSH_KEY"
```



# Lets see what we deployed

```
# grab our AKS config
az aks get-credentials -n aks-getting-started -g aks-getting-started

# Get kubectl

curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl

kubectl get svc

```

# Clean up 

```
terraform destroy -var serviceprinciple_id=$SERVICE_PRINCIPAL \
    -var serviceprinciple_key="$SERVICE_PRINCIPAL_SECRET" \
    -var tenant_id=$TENTANT_ID \
    -var subscription_id=$SUBSCRIPTION \
    -var ssh_key="$SSH_KEY"
```
