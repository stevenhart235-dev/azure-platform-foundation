variable "resource_group_name" {
  description = "Name of the bootstrap resource group."
  type        = string
  nullable    = false
}

variable "location" {
  description = "Azure location for the bootstrap resource group."
  type        = string
  nullable    = false
}

variable "tags" {
  description = "Tags to apply to the bootstrap resource group."
  type        = map(string)
  default     = {}
  nullable    = false
}
