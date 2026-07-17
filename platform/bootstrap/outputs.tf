output "resource_group_id" {
  description = "Bootstrap resource group ID."
  value       = module.bootstrap_resource_group.id
}

output "resource_group_name" {
  description = "Bootstrap resource group name."
  value       = module.bootstrap_resource_group.name
}

output "resource_group_location" {
  description = "Bootstrap resource group location."
  value       = module.bootstrap_resource_group.location
}

output "storage_account_id" {
  description = "Bootstrap state storage account ID."
  value       = module.bootstrap_state_storage_account.id
}

output "storage_account_name" {
  description = "Bootstrap state storage account name."
  value       = module.bootstrap_state_storage_account.name
}

output "storage_account_resource_group_name" {
  description = "Bootstrap state storage account resource group name."
  value       = module.bootstrap_state_storage_account.resource_group_name
}

output "storage_account_location" {
  description = "Bootstrap state storage account location."
  value       = module.bootstrap_state_storage_account.location
}

output "storage_account_primary_blob_endpoint" {
  description = "Bootstrap state storage account primary Blob service endpoint."
  value       = module.bootstrap_state_storage_account.primary_blob_endpoint
}

output "state_container_id" {
  description = "Bootstrap Terraform state container ID."
  value       = module.bootstrap_state_container.id
}

output "state_container_name" {
  description = "Bootstrap Terraform state container name."
  value       = module.bootstrap_state_container.name
}
