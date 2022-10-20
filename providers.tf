terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.24.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = "~>2.29.0"
    }
    time = {
      source = "hashicorp/time"
      version = "~>0.9.0"
    }
    random = {
      source = "hashicorp/random"
      version = "~>3.4.3"
    }
    github = {
      source = "integrations/github"
      version = "~>5.5.0"
    }
    git = {
      source = "innovationnorway/git"
      version = "~>0.1.3"
    }
  }
  # backend "azurerm" {
  #   resource_group_name  = "StorageAccountResourceGroupName"
  #   storage_account_name = "StorageAccountName"
  #   container_name       = "tfstate"
  #   key                  = "prod.terraform.tfstate"
  # }
  required_version = ">= 1.3.2"
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

provider "github" {}