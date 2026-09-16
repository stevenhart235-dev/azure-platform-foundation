provider "azurerm" {
  features {}

  tenant_id                       = lower(var.tenant_id)
  subscription_id                 = lower(var.subscription_id)
  resource_provider_registrations = "none"
}
