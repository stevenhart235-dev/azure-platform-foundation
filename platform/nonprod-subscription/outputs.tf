output "nonproduction_subscription" {
  description = "Created subscription, alias and placement identifiers; the alias resource ID is not the subscription resource ID."
  value = {
    subscription_id              = azurerm_subscription.nonproduction.subscription_id
    subscription_resource_id     = "/subscriptions/${azurerm_subscription.nonproduction.subscription_id}"
    subscription_display_name    = azurerm_subscription.nonproduction.subscription_name
    tenant_id                    = azurerm_subscription.nonproduction.tenant_id
    alias                        = azurerm_subscription.nonproduction.alias
    alias_resource_id            = azurerm_subscription.nonproduction.id
    management_group_resource_id = data.azurerm_management_group.destination.id
    association_id               = azurerm_management_group_subscription_association.nonproduction.id
  }
}
