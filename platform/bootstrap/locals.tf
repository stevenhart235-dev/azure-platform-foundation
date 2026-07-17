locals {
  foundation_baseline_tags = {
    "managed-by"         = "terraform"
    "platform-scope"     = "foundation"
    "platform-component" = "bootstrap"
  }

  effective_tags = merge(local.foundation_baseline_tags, var.tags)
}
