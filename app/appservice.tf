# creates app service plan
resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "app" {
  name                = var.app_service
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id
  https_only          = true

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"                  = azurerm_application_insights.appi.instrumentation_key
    "APPINSIGHTS_PROFILERFEATURE_VERSION"             = "1.0.0"
    "APPINSIGHTS_SNAPSHOTFEATURE_VERSION"             = "1.0.0"
    "APPLICATIONINSIGHTS_CONNECTION_STRING"           = azurerm_application_insights.appi.connection_string
    "APPLICATIONINSIGHTS_ENABLESQLQUERYCOLLECTION"    = "disabled"
    "ASPNETCORE_ENVIRONMENT"                          = var.app_service_aspnetcore_environment
    "ApplicationInsightsAgent_EXTENSION_VERSION"      = "~3"
    "DISABLE_APPINSIGHTS_SDK"                         = "disabled"
    "DiagnosticServices_EXTENSION_VERSION"            = "~3"
    "IGNORE_APPINSIGHTS_SDK"                          = "disabled"
    "InstrumentationEngine_EXTENSION_VERSION"         = "disabled"
    "SnapshotDebugger_EXTENSION_VERSION"              = "disabled"
    "WEBSITE_ENABLE_SYNC_UPDATE_SITE"                 = "true"
    "WEBSITE_RUN_FROM_PACKAGE"                        = "1"
    "XDT_MicrosoftApplicationInsights_BaseExtensions" = "disabled"
    "XDT_MicrosoftApplicationInsights_Mode"           = "recommended"
    "XDT_MicrosoftApplicationInsights_PreemptSdk"     = "disabled"
  }

  # TODO: Maybe remove this? Prod didn't have it
  sticky_settings {
    app_setting_names = [
      "APPINSIGHTS_INSTRUMENTATIONKEY",
      "APPLICATIONINSIGHTS_CONNECTION_STRING ",
      "APPINSIGHTS_PROFILERFEATURE_VERSION",
      "APPINSIGHTS_SNAPSHOTFEATURE_VERSION",
      "ApplicationInsightsAgent_EXTENSION_VERSION",
      "XDT_MicrosoftApplicationInsights_BaseExtensions",
      "DiagnosticServices_EXTENSION_VERSION",
      "InstrumentationEngine_EXTENSION_VERSION",
      "SnapshotDebugger_EXTENSION_VERSION",
      "XDT_MicrosoftApplicationInsights_Mode",
      "XDT_MicrosoftApplicationInsights_PreemptSdk",
      "APPLICATIONINSIGHTS_CONFIGURATION_CONTENT",
      "XDT_MicrosoftApplicationInsightsJava",
      "XDT_MicrosoftApplicationInsights_NodeJS",
    ]
  }

  site_config {
    always_on                         = false
    scm_minimum_tls_version           = "1.2"
    ftps_state                        = "Disabled"
    ip_restriction_default_action     = "Allow"
    scm_ip_restriction_default_action = "Allow"

    application_stack {
      dotnet_version = "7.0"
    }
  }
}

resource "azurerm_linux_web_app_slot" "slotDemo" {
  # don't create slot if using free tier
  count = azurerm_service_plan.asp.sku_name == "F1" ? 0 : 1

  name           = var.app_service_slot
  app_service_id = azurerm_service_plan.asp.id

  site_config {}
}
