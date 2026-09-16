provider "azurerm" {
  features {
    subscription {
      prevent_cancellation_on_destroy = true
    }
  }

  tenant_id                       = lower(var.tenant_id)
  subscription_id                 = lower(var.provider_subscription_id)
  resource_provider_registrations = "none"
}
