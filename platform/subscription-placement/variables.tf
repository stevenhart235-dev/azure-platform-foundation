variable "tenant_id" {
  description = "Explicit target Microsoft Entra tenant UUID."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.tenant_id))
    error_message = "tenant_id must be a UUID in 8-4-4-4-12 format."
  }
}

variable "subscription_id" {
  description = "UUID of the existing subscription whose placement this root manages."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.subscription_id))
    error_message = "subscription_id must be a UUID in 8-4-4-4-12 format."
  }
}

variable "management_group_resource_id" {
  description = "Existing destination's full Azure resource ID, passed from the M1 management_group_resource_ids output using its stable key."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^/providers/Microsoft\\.Management/managementGroups/[A-Za-z0-9_.()-]+$", var.management_group_resource_id))
    error_message = "Supply a full management-group resource ID from the M1 output contract."
  }
}
