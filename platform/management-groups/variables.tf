variable "tenant_id" {
  description = "Explicit target Microsoft Entra tenant UUID; also identifies the existing Tenant Root management group."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.tenant_id))
    error_message = "tenant_id must be a UUID in 8-4-4-4-12 format."
  }
}
