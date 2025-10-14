
# The constraint "~>4.0" allows non-breaking updates within major version 4.x.
terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~>4.0"
    }
  }
  required_version = ">=1.3.0"
}

provider "azurerm" {
  features {}
}

# Crearing resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-vnet-peering"
  location = "East US"
}