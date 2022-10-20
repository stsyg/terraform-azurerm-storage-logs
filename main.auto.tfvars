prefix   = "infra"
service  = "storage-logs"
backend  = "tfstate"
location = "canadacentral"
infra_vnet = {
    name = "infra-vnet-01"
    rg_name = "infra-network-rg"
}

default_tags = {
  environment = "Lab"
  designation = "Infrastructure"
  provisioner = "Terraform"
}