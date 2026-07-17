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
  description = "Caller-provided tags to merge with Foundation bootstrap baseline tags. Caller-provided values take precedence when keys overlap."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "storage_account_name" {
  description = "Final Azure Storage account name for bootstrap Terraform state."
  type        = string
  nullable    = false

  validation {
    condition     = length(var.storage_account_name) >= 3 && length(var.storage_account_name) <= 24
    error_message = "The storage account name must be between 3 and 24 characters."
  }

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.storage_account_name))
    error_message = "The storage account name may contain only lowercase letters and numbers."
  }
}

variable "storage_account_replication_type" {
  description = "Replication type for the bootstrap state storage account."
  type        = string
  default     = "LRS"
  nullable    = false

  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.storage_account_replication_type)
    error_message = "The storage account replication type must be one of: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  }
}

variable "storage_account_public_network_access_enabled" {
  description = "Whether public network access is enabled for the bootstrap state storage account. Keep false unless an explicit temporary bootstrap exception is approved."
  type        = bool
  default     = false
  nullable    = false
}

variable "storage_account_network_bypass" {
  description = "Storage firewall bypass values for trusted Azure platform traffic."
  type        = set(string)
  default     = ["AzureServices"]
  nullable    = false

  validation {
    condition = alltrue([
      for value in var.storage_account_network_bypass :
      contains(["Logging", "Metrics", "AzureServices", "None"], value)
    ])
    error_message = "Network bypass values must be one or more of: Logging, Metrics, AzureServices, None."
  }

  validation {
    condition     = !(contains(var.storage_account_network_bypass, "None") && length(var.storage_account_network_bypass) > 1)
    error_message = "Network bypass value None must not be combined with Logging, Metrics, or AzureServices."
  }
}

variable "storage_account_network_ip_rules" {
  description = "Public IPv4 addresses or CIDR ranges allowed through the bootstrap state storage firewall."
  type        = set(string)
  default     = []
  nullable    = false
}

variable "storage_account_network_subnet_ids" {
  description = "Virtual network subnet resource IDs allowed through the bootstrap state storage firewall."
  type        = set(string)
  default     = []
  nullable    = false
}

variable "state_container_name" {
  description = "Name of the private bootstrap Terraform state container."
  type        = string
  default     = "bootstrap"
  nullable    = false

  validation {
    condition     = length(var.state_container_name) >= 3 && length(var.state_container_name) <= 63
    error_message = "The state container name must be between 3 and 63 characters."
  }

  validation {
    condition     = can(regex("^[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$", var.state_container_name))
    error_message = "The state container name may contain only lowercase letters, numbers, and hyphens, and must start and end with a lowercase letter or number."
  }

  validation {
    condition     = !can(regex("--", var.state_container_name))
    error_message = "The state container name must not contain consecutive hyphens."
  }
}
