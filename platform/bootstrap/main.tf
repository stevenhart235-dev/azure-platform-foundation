module "bootstrap_resource_group" {
  source = "git::https://github.com/stevenhart235-dev/azure-platform-modules.git//modules/resource-group?ref=resource-group-v0.1.0"

  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}
