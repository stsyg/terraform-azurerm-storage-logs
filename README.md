# Repo Description
Template repository for Terraform projects

#### Table of Contents
  - [Usage](#usage)
  - [Requirements](#requirements)
  - [Providers](#providers)
  - [Modules](#modules)
  - [Resources](#resources)
  - [Inputs](#inputs)
  - [Outputs](#outputs)
## Usage
The following resources will be created:

- Azure Resource Group for TF state resources
- Azure Storage Account to store TF state files
- Azure Resource #3

## Pre-requisites
Several prerequisites need to be in place before using this repo.

1. Add Azure SPN to the target subscription with the User Access Administrator role.
2. Azure SPN with the following API permissions (via Microsft Graph). It will be used to create a limited Azure SPN for future deployments. More information can be found here: https://learn.microsoft.com/en-us/azure/active-directory/develop/v2-permissions-and-consent?WT.mc_id=Portal-Microsoft_AAD_RegisteredApps#admin-restricted-permissions.
   - Application.ReadWrite.All (type: Application).
   - Directory.ReadWrite.All (type: Application).
   - AppRoleAssignment.ReadWrite.All (type: Delegated).
3. Create a Personal Access Token with "Update GitHub Action workflows." More information can be found here: https://docs.github.com/en/rest/actions/secrets#get-a-repository-public-key.
4. Login in the local terminal with Azure SPN
```
az login --service-principal -u <appID> -p=<appPassword> --tenant <tenantID>
```
5. Export Azure SPN as environment variables in the local terminal
```
export ARM_CLIENT_ID="<appID>"
export ARM_CLIENT_SECRET="<appPassword>"
export ARM_SUBSCRIPTION_ID="<subscriptionID>"
export ARM_TENANT_ID="<tenantID>"
```
6. Export the GitHub PAT token as an environment variable in the local terminal
```
export GITHUB_TOKEN="<tokenPassword>"
```

## How to run code
There are two parts for code execution in this repo.

1. Local code execution, i.e., apply Terraform code on the developer's laptop/VM.
2. Remote code execution, i.e., use GitHub Actions with created Azure SPN to deploy any new Azure resources.

### Local code execution
Before switching to remote execution, a minimum set of resources must be created. They are:

- Azure Resource Group for this project. One resource group will be used to deploy all the future resources
- Azure Storage Account to store future Terraform state files related to this project
- Create a new Azure SPN with Contributor rights on the newly created Azure Resource Group; This will minimize the security impact in case of compromised Azure SPN credentials
- Azure credentials of newly created Azure SPN uploaded to GitHub repo secrets. They will be used in GitHub Actions for remote code execution.

> After cloning this repo, update the variables.tf and auto.tfvars files and execute
```
terraform plan
```
If there are no errors, run the
```
terraform apply
```

Troubleshoot any errors (if needed) and move to the next step - remote code execution.

### Remote code execution
This part of the readme describes how to use GitHub Actions to plan and apply Terraform code.

1. Enable Storage Account Container block in backend_sa.tf file. 
```
# Create Container in Storage Account to store TF state files
resource "azurerm_storage_container" "this" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}
```
and run 
```
terraform apply
```
2. Add remote backend block in providers.tf
```
  backend "azurerm" {
    resource_group_name  = "StorageAccountResourceGroupName"
    storage_account_name = "StorageAccountName"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
```
3. Create a new feature branch and add code
4. Run git commit and fix any issue checking the pre-commit log presented in the terminal
5. Run git push to apply Terraform code. Check GitHub actions for any errors and fix them
6. When the feature is developed, create a PR to merge with the main. Check GitHub Actions for any errors and fix them
7. Repeat step #1 for new feature development


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.2 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~>2.29.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.24.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | ~>0.1.3 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~>5.5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~>3.4.3 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~>0.9.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.29.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.24.0 |
| <a name="provider_git"></a> [git](#provider\_git) | 0.1.3 |
| <a name="provider_github"></a> [github](#provider\_github) | 5.5.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.9.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_application.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_service_principal.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azuread_service_principal_password.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal_password) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.build_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.subscription_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [github_actions_secret.github_actions_azure_credentials](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [random_id.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [time_rotating.this](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/rotating) | resource |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subscription.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |
| [git_repository.this](https://registry.terraform.io/providers/innovationnorway/git/latest/docs/data-sources/repository) | data source |
| [github_actions_public_key.this](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/actions_public_key) | data source |
| [github_repository.this](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/repository) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backend"></a> [backend](#input\_backend) | Backend name used for core Azure resources naming convention | `string` | n/a | yes |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default tags to add to deployed resources | `map(string)` | n/a | yes |
| <a name="input_infra_vnet"></a> [infra\_vnet](#input\_infra\_vnet) | Infrastructure vNet/Subnet details | `map(string)` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location name used in Azure resources naming convention | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix used in Azure resources naming convention | `string` | n/a | yes |
| <a name="input_service"></a> [service](#input\_service) | Service name used in Azure resources naming convention | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_github_repo_name"></a> [github\_repo\_name](#output\_github\_repo\_name) | n/a |
| <a name="output_github_repo_org_name"></a> [github\_repo\_org\_name](#output\_github\_repo\_org\_name) | n/a |
| <a name="output_github_repo_url"></a> [github\_repo\_url](#output\_github\_repo\_url) | n/a |
| <a name="output_infra_vnet_id"></a> [infra\_vnet\_id](#output\_infra\_vnet\_id) | n/a |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
