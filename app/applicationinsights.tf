resource "azurerm_application_insights" "appi" {
  name                = var.app_service
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
  workspace_id        = var.appi_workspace_id # TODO: add log analytics workspace
  sampling_percentage = 0                     # defaults to 100
}
