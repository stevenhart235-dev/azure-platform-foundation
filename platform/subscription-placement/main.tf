data "azurerm_client_config" "current" {}

data "azurerm_subscription" "existing" {
  subscription_id = lower(var.subscription_id)
}

data "azurerm_management_group" "destination" {
  name = basename(var.management_group_resource_id)
}

resource "azurerm_management_group_subscription_association" "placement" {
  management_group_id = data.azurerm_management_group.destination.id
  subscription_id     = data.azurerm_subscription.existing.id

  lifecycle {
    precondition {
      condition = (
        lower(data.azurerm_client_config.current.tenant_id) == lower(var.tenant_id) &&
        lower(data.azurerm_subscription.existing.tenant_id) == lower(var.tenant_id)
      )
      error_message = "The authenticated tenant and existing subscription tenant must match tenant_id."
    }
  }
}
