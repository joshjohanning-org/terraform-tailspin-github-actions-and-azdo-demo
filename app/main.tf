terraform {
  required_version = ">= 1.9.4"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.115.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# create resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.location
}