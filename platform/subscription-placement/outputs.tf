output "subscription_placement" {
  description = "Managed association and existing subscription/destination identifiers."
  value = {
    association_id                = azurerm_management_group_subscription_association.placement.id
    subscription_id               = data.azurerm_subscription.existing.subscription_id
    subscription_display_name     = data.azurerm_subscription.existing.display_name
    management_group_resource_id  = data.azurerm_management_group.destination.id
    management_group_id           = data.azurerm_management_group.destination.name
    management_group_display_name = data.azurerm_management_group.destination.display_name
  }
}
