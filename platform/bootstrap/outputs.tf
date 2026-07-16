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
