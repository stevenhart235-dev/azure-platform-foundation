data "azurerm_client_config" "current" {}

data "azurerm_subscription" "provider_context" {
  subscription_id = lower(var.provider_subscription_id)
}

data "azurerm_management_group" "destination" {
  name = basename(var.management_group_resource_id)
}

resource "azurerm_subscription" "nonproduction" {
  alias             = "ordicor-nonprod-landing-zone"
  subscription_name = "Ordicor Non-Production Landing Zone"
  billing_scope_id  = var.billing_scope_id
  # Standard Azure Plan billing category, not the landing-zone lifecycle.
  workload = "Production"

  lifecycle {
    prevent_destroy = true

    precondition {
      condition = (
        lower(data.azurerm_client_config.current.tenant_id) == lower(var.tenant_id) &&
        lower(data.azurerm_subscription.provider_context.tenant_id) == lower(var.tenant_id)
      )
      error_message = "The authenticated tenant and provider context subscription tenant must match tenant_id."
    }

    postcondition {
      condition     = lower(self.tenant_id) == lower(var.tenant_id)
      error_message = "The created subscription belongs to an unexpected tenant; stop before placement."
    }
  }
}

resource "azurerm_management_group_subscription_association" "nonproduction" {
  management_group_id = data.azurerm_management_group.destination.id
  subscription_id     = "/subscriptions/${azurerm_subscription.nonproduction.subscription_id}"
}
