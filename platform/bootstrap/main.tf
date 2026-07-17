module "bootstrap_resource_group" {
  source = "git::https://github.com/stevenhart235-dev/azure-platform-modules.git//modules/resource-group?ref=resource-group-v0.1.0"

  name     = var.resource_group_name
  location = var.location
  tags     = local.effective_tags
}

module "bootstrap_state_storage_account" {
  source = "git::https://github.com/stevenhart235-dev/azure-platform-modules.git//modules/storage-account?ref=storage-account-v0.1.1"

  name                          = var.storage_account_name
  resource_group_name           = module.bootstrap_resource_group.name
  location                      = module.bootstrap_resource_group.location
  tags                          = local.effective_tags
  account_replication_type      = var.storage_account_replication_type
  public_network_access_enabled = var.storage_account_public_network_access_enabled
  network_bypass                = var.storage_account_network_bypass
  network_ip_rules              = var.storage_account_network_ip_rules
  network_subnet_ids            = var.storage_account_network_subnet_ids
}

module "bootstrap_state_container" {
  source = "git::https://github.com/stevenhart235-dev/azure-platform-modules.git//modules/storage-container?ref=storage-container-v0.1.0"

  name                  = var.state_container_name
  storage_account_id    = module.bootstrap_state_storage_account.id
  container_access_type = "private"
}
