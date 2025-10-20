# The constraint "~>4.0" allows non-breaking updates within major version 4.x.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
  }
  required_version = ">=1.3.0"
}

provider "azurerm" {
  features {}
  subscription_id = "a48c9a50-8801-41f0-b455-f7394885ad34"
}
