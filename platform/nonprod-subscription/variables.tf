variable "tenant_id" {
  description = "Explicit target Microsoft Entra tenant UUID for subscription creation."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.tenant_id))
    error_message = "tenant_id must be a UUID in 8-4-4-4-12 format."
  }
}

variable "provider_subscription_id" {
  description = "Existing subscription UUID used only for AzureRM authentication/context; never adopted or managed by this root."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.provider_subscription_id))
    error_message = "provider_subscription_id must be a UUID in 8-4-4-4-12 format."
  }
}

variable "billing_scope_id" {
  description = "Full existing MCA invoice-section resource ID to bill the new subscription."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^/providers/Microsoft\\.Billing/billingAccounts/[^/]+/billingProfiles/[^/]+/invoiceSections/[^/]+$", var.billing_scope_id))
    error_message = "billing_scope_id must be a full MCA invoice-section resource ID."
  }
}

variable "management_group_resource_id" {
  description = "M1 management_group_resource_ids[landing-zones-nonproduction] output; this milestone permits only that destination."
  type        = string
  nullable    = false

  validation {
    condition     = var.management_group_resource_id == "/providers/Microsoft.Management/managementGroups/landing-zones-nonproduction"
    error_message = "M3 must target the stable landing-zones-nonproduction management-group resource ID."
  }
}
