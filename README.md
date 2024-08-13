# azdo-terraform-tailspin

Sample terraform code deploying to Azure.

GitHub Actions workflow are in `./.github/workflows` and Azure DevOps pipelines are in `./pipeline`.

## Set up the backend

You have to create the backend resource group and storage account first.

Note: This is creating 1 resource group with 1 storage account with 1 storage account container. This could be modified to use a separate rg/account/container for each environment.

Option 1: Comment out the backend code in `./backend/main.tf` to use local state, then migrate the state to the backend:

```hcl
# when originally creating the tfstate resource group and resources, comment out this code. 
# after creating, re-run terraform init and terraform apply to switch the back-end
terraform {
  backend "azurerm" {
    resource_group_name   = "rg-tailspin-tfstate"
    storage_account_name  = "tailspintfstate"
    container_name        = "tfstate"
  }
}
```

Option 2: Provision manually:

```bash
cd ./backend
az group create --name rg-tailspin-tfstate --location centralus
az storage account create --name tailspintfstate --resource-group rg-tailspin-tfstate --location centralus --sku Standard_GRS
az storage container create --name tfstate --account-name tailspintfstate 
terraform init -backend-config=backend.DEV.tfvars
terraform import azurerm_resource_group.tfstate /subscriptions/2e9bfb26-ca29-44f5-8920-72c1b0b37188/resourceGroups/rg-tailspin-tfstate
terraform import azurerm_storage_account.tfstate /subscriptions/2e9bfb26-ca29-44f5-8920-72c1b0b37188/resourceGroups/rg-tailspin-tfstate/providers/Microsoft.Storage/storageAccounts/tailspintfstate
terraform import azurerm_storage_container.tfstate https://tailspintfstate.blob.core.windows.net/tfstate
terraform plan
terraform apply
```

## App

```bash
terraform init -backend-config=backend.DEV.tfvars
terraform plan -var-file=terraform.DEV.tfvars
terraform apply -var-file=terraform.DEV.tfvars
```

When importing, also need to specify the var file:

```bash
terraform import -var-file=terraform.DEV.tfvars azurerm_application_insights.appi /subscriptions/2e9bfb26-ca29-44f5-8920-72c1b0b37188/resourceGroups/rg-tailspin-terraform-DEV/providers/Microsoft.Insights/components/app-tailspin-demo-DEV
```

## Misc

Linting:

```bash
terraform fmt
tflint
```

tfsec:

```bash
tfsec
```

Upgrading provider:

```bash
terraform init -backend-config=backend.DEV.tfvars -upgrade
```

Switching environments and not migrating state:

```bash
terraform init -backend-config=backend.PROD.tfvars -reconfigure
```

## Setting up OIDC with reusable workflow

OIDC is set up to authenticate to Azure from this repository only if you are referencing the approved reusable workflows:

- [joshjohanning-org/reusable-workflows/.github/workflows/terraform-plan.yml@v1](https://github.com/joshjohanning-org/reusable-workflows/blob/v1/.github/workflows/terraform-plan.yml)
- [joshjohanning-org/reusable-workflows/.github/workflows/terraform-apply.yml@v1](https://github.com/joshjohanning-org/reusable-workflows/blob/v1/.github/workflows/terraform-apply.yml)

Allowing the `job_workflow_ref` subject to be sent; making the change via the CLI:

```sh
gh oidc-sub set --repo joshjohanning-org/terraform-tailspin-github-actions-and-azdo-demo --subs "job_workflow_ref"
```

> [!TIP]
> See my [blog post](https://josh-ops.com/posts/github-actions-oidc-reusable-workflows/) for more information on this
