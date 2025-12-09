terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    # Resource Group and Storage Account for state will be passed via CLI/Env vars
    # resource_group_name  = "..."
    # storage_account_name = "..."
    # container_name       = "..."
    key                  = "terraform.tfstate"
    use_oidc             = true
  }
}

provider "azurerm" {
  features {}
  use_oidc = true
}
