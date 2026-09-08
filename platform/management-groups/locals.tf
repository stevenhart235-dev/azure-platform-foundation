locals {
  tenant_root_resource_id = "/providers/Microsoft.Management/managementGroups/${lower(var.tenant_id)}"

  management_groups = {
    platform                    = azurerm_management_group.platform
    platform-management         = azurerm_management_group.management
    platform-identity           = azurerm_management_group.identity
    platform-connectivity       = azurerm_management_group.connectivity
    platform-shared-services    = azurerm_management_group.shared_services
    landing-zones               = azurerm_management_group.landing_zones
    landing-zones-production    = azurerm_management_group.production
    landing-zones-nonproduction = azurerm_management_group.nonproduction
    landing-zones-sandbox       = azurerm_management_group.sandbox
    decommissioned              = azurerm_management_group.decommissioned
  }
}
