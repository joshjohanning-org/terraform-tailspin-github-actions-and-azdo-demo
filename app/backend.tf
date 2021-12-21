terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstatejoshspacegame"
    container_name       = "tfstate"
  }
}
