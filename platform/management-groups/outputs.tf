output "management_group_ids" {
  description = "Stable management-group names/IDs, keyed by stable ID."
  value       = { for key, group in local.management_groups : key => group.name }
}

output "management_group_resource_ids" {
  description = "Full Azure management-group resource IDs, keyed by stable ID."
  value       = { for key, group in local.management_groups : key => group.id }
}

output "management_groups" {
  description = "Explicit contract for later subscription placement, policy, and RBAC consumers, keyed by stable ID."
  value = {
    for key, group in local.management_groups : key => {
      management_group_id        = group.name
      resource_id                = group.id
      display_name               = group.display_name
      parent_management_group_id = group.parent_management_group_id
    }
  }
}
