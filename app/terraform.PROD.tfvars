location = "centralus"

resource_group = "rg-tailspin-terraform-PROD"

app_service_plan = "asp-tailspin-PROD"

app_service = "app-tailspin-PROD"

app_service_slot = "swap"

key_vault = "kv-tailspin-PROD"

kv_service_principals = {
  "azdo-spn" = {
    "object_id" = "4ded4b3b-26a7-4ea4-a166-d33f49d8a0d3"
  },
  "my-spn" = {
    "object_id" = "2375fc64-20b9-451b-bc00-245f12d9c258"
  }
}

database_server_name = "tailspinjosh-server-dev"

database_name = "tailspinjosh-db-dev"