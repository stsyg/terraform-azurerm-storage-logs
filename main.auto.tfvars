prefix   = "prj"
service  = "template"
backend  = "tfstate"
location = "canadacentral"
infra_vnet = {
    name = "infra-vnet-01"
    rg_name = "infra-network-rg"
}

default_tags = {
  environment = "Dev"
  designation = "Project"
  provisioner = "Terraform"
}