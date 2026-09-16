resource "azurerm_management_group" "platform" {
  name                       = "platform"
  display_name               = "Platform"
  parent_management_group_id = local.tenant_root_resource_id

  lifecycle {
    precondition {
      condition     = lower(data.azurerm_client_config.current.tenant_id) == lower(var.tenant_id)
      error_message = "The authenticated Azure tenant must match tenant_id."
    }
  }
}

resource "azurerm_management_group" "management" {
  name                       = "platform-management"
  display_name               = "Management"
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "identity" {
  name                       = "platform-identity"
  display_name               = "Identity"
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "connectivity" {
  name                       = "platform-connectivity"
  display_name               = "Connectivity"
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "shared_services" {
  name                       = "platform-shared-services"
  display_name               = "Shared Services"
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "landing_zones" {
  name                       = "landing-zones"
  display_name               = "Landing Zones"
  parent_management_group_id = local.tenant_root_resource_id

  lifecycle {
    precondition {
      condition     = lower(data.azurerm_client_config.current.tenant_id) == lower(var.tenant_id)
      error_message = "The authenticated Azure tenant must match tenant_id."
    }
  }
}

resource "azurerm_management_group" "production" {
  name                       = "landing-zones-production"
  display_name               = "Production"
  parent_management_group_id = azurerm_management_group.landing_zones.id
}

resource "azurerm_management_group" "nonproduction" {
  name                       = "landing-zones-nonproduction"
  display_name               = "Non-Production"
  parent_management_group_id = azurerm_management_group.landing_zones.id
}

resource "azurerm_management_group" "sandbox" {
  name                       = "landing-zones-sandbox"
  display_name               = "Sandbox"
  parent_management_group_id = azurerm_management_group.landing_zones.id
}

resource "azurerm_management_group" "decommissioned" {
  name                       = "decommissioned"
  display_name               = "Decommissioned"
  parent_management_group_id = local.tenant_root_resource_id

  lifecycle {
    precondition {
      condition     = lower(data.azurerm_client_config.current.tenant_id) == lower(var.tenant_id)
      error_message = "The authenticated Azure tenant must match tenant_id."
    }
  }
}
