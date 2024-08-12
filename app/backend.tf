terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tailspin-tfstate"
    storage_account_name = "tailspintfstate"
    container_name       = "tfstate"
  }
}
