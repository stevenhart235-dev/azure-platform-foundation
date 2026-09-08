provider "azurerm" {
  features {}

  tenant_id                       = lower(var.tenant_id)
  resource_provider_registrations = "none"
}

data "azurerm_client_config" "current" {}
