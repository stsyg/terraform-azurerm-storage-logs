# Gather data about main infrastructure vNet
data "azurerm_virtual_network" "this" {
  name                = var.infra_vnet.name
  resource_group_name = var.infra_vnet.rg_name
}

# Gather data about main infrastructure Subnets
data "azurerm_subnet" "this" {
    name                 = data.azurerm_virtual_network.this.subnets[count.index]
    virtual_network_name = data.azurerm_virtual_network.this.name
    resource_group_name  = data.azurerm_virtual_network.this.resource_group_name
    count                = length(data.azurerm_virtual_network.this.subnets)
}

# Create random ID
resource "random_id" "this" {
  byte_length = 4
}

# Create Resource Group for storage account
resource "azurerm_resource_group" "this" {
  name     = "${var.prefix}-${var.service}-${var.backend}-rg"
  location = var.location

  tags = var.default_tags
}

# Create Storage Account to store TF state files
resource "azurerm_storage_account" "this" {
	# checkov:skip=CKV2_AZURE_1: It's not critical to encrypt this SA with CMK
	# checkov:skip=CKV2_AZURE_18: Customer managed key is not going to be used
	# checkov:skip=CKV_AZURE_33: Storage Queue is not used
  name                     = "${var.prefix}${var.service}${random_id.this.hex}sa"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version = "TLS1_2"
  allow_nested_items_to_be_public = false
#  public_network_access_enabled = false # if True, the network_rules block below will be skipped

  network_rules {
    default_action             = "Deny"
    bypass = ["AzureServices", "Logging", "Metrics"]
  #  ip_rules                   = []
  #  virtual_network_subnet_ids = [data.azurerm_subnet.this[0].id]
    virtual_network_subnet_ids = toset(data.azurerm_subnet.this.*.id)
  }

  tags = var.default_tags
}