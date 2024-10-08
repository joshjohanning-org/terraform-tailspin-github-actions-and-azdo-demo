location                           = "eastus"
resource_group                     = "rg-tailspin-terraform-DEV"
app_service_plan                   = "asp-tailspin-DEV"
app_service                        = "app-tailspin-demo-DEV"
app_service_aspnetcore_environment = "Development"
app_service_slot                   = "swap"
appi_workspace_id                  = "/subscriptions/2e9bfb26-ca29-44f5-8920-72c1b0b37188/resourceGroups/DefaultResourceGroup-EUS/providers/Microsoft.OperationalInsights/workspaces/DefaultWorkspace-2e9bfb26-ca29-44f5-8920-72c1b0b37188-EUS"

# key_vault = "kv-tailspin-DEV"
# kv_service_principals = {
#   "azdo-spn" = {
#     "object_id" = "4ded4b3b-26a7-4ea4-a166-d33f49d8a0d3"
#   },
#   "my-spn" = {
#     "object_id" = "2375fc64-20b9-451b-bc00-245f12d9c258"
#   }
# }

# database_server_name = "tailspinjosh-server-dev"
# database_name        = "tailspinjosh-db-dev"
