# Fetch information about the configuration of the AzureRM provider
data "azuread_client_config" "current" {}

# Fetch information about current subscription
data "azurerm_subscription" "this" {}

# Get information about current GitHub Repository
data "git_repository" "this" {
  path = path.root
}

# Use current GitHub repo URL to get org/name and name of the repo
# Offset of 19(25) charecters from URL https://github.com/stsyg/repo_name.git 
locals {
# Get current GitHub repo org/name
  github_full_name = replace(substr(data.git_repository.this.url,19,-1), "/.git/", "")
# Get current GitHub repo name
  github_name = replace(substr(data.git_repository.this.url,25,-1), "/.git/", "")
}

# Create application registration within Azure Active Directory
resource "azuread_application" "this" {
  display_name = "${local.github_name}-sp-app"
  owners       = [data.azuread_client_config.current.object_id]
}

# Create a service principal for an application
resource "azuread_service_principal" "this" {
  application_id               = azuread_application.this.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

# Introducing time rotation 
resource "time_rotating" "this" {
  rotation_days = 7
}

# Create password credential associated with a service principal within Azure Active Directory
resource "azuread_service_principal_password" "this" {
  service_principal_id = azuread_service_principal.this.id
    rotate_when_changed = {
      rotation = time_rotating.this.id
    }
}

# Assign RBAC Reader role to previously created Azure SPN with the scope to the subscription
resource "azurerm_role_assignment" "subscription_reader" {
  scope                = data.azurerm_subscription.this.id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.this.id
}

# Assign RBAC Contributor role to previously created Azure SPN with the scope to first RG
resource "azurerm_role_assignment" "build_contributor" {
  scope                = azurerm_resource_group.this.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.this.id
}

# Retrieve information about a GitHub repository
# tflint-ignore: terraform_unused_declarations
data "github_repository" "this" {
  full_name = local.github_full_name
}

# Retrieve information about a GitHub Actions public key
# tflint-ignore: terraform_unused_declarations
data "github_actions_public_key" "this" {
  repository = local.github_name
}

# Create and manage GitHub Actions secrets within your GitHub repositories
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret

# Export Azure credentials and upload them to GitHub secrets
resource "github_actions_secret" "github_actions_azure_credentials" {
  repository = local.github_name
  secret_name = "AZURE_CREDENTIALS"
	# checkov:skip=CKV_SECRET_6: secret_name doesn't contain any sensetive info

  plaintext_value = jsonencode(
    {
      clientId       = azuread_application.this.application_id
      clientSecret   = azuread_service_principal_password.this.value
      subscriptionId = data.azurerm_subscription.this.subscription_id
      tenantId       = data.azurerm_subscription.this.tenant_id
    }
  )
}