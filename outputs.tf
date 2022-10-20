output "github_repo_url" {
  value     = data.git_repository.this.url
}

output "github_repo_org_name" {
  value     = local.github_full_name
}

output "github_repo_name" {
  value     = local.github_name
}

output "infra_vnet_id" {
  value     = data.azurerm_virtual_network.this.subnets
}

 output "subnet_ids" {
     value = data.azurerm_subnet.this.*.id
 }