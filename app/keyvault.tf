# resource "azurerm_key_vault" "kv" {
#   name                = var.key_vault
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   tenant_id           = data.azurerm_subscription.primary.tenant_id

#   sku_name = "standard"
#   # soft_delete_enabled             = true
#   enabled_for_deployment          = true
#   enabled_for_template_deployment = false
#   enabled_for_disk_encryption     = false
# }

# # ideally would split this up for azuread data sources - but the pipeline spn would need azuread graph api (legacy) permissions
# # permissions neeeded (used for creating SPN's too)
# # # Type Application: Application.Read.All, Application.ReadWrite.All, Application.ReadWrite.OwnedBy, Directory.Read.All
# # # Type Delegated: Directory.AccessAsUser.All, Directory.Read.All
# resource "azurerm_key_vault_access_policy" "access_policy" {
#   count        = length(var.kv_service_principals)
#   key_vault_id = azurerm_key_vault.kv.id

#   tenant_id = data.azurerm_subscription.primary.tenant_id
#   object_id = var.kv_service_principals[element(keys(var.kv_service_principals), count.index)]["object_id"]

#   secret_permissions = [
#     "Get",
#     "List",
#     "Set",
#     "Delete",
#     "Purge"
#   ]
# }

# resource "azurerm_key_vault_secret" "applicationInsightsKey" {
#   name         = "ApplicationInsightsKey"
#   value        = "-test-"
#   key_vault_id = azurerm_key_vault.kv.id

#   depends_on = [azurerm_key_vault_access_policy.access_policy]
# }

# resource "azurerm_key_vault_secret" "dbserverpw" {
#   name         = "DBServerPassword"
#   value        = random_password.password.result
#   key_vault_id = azurerm_key_vault.kv.id

#   depends_on = [azurerm_key_vault_access_policy.access_policy]
# }