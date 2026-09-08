# M2 - Subscription Placement

Status: COMPLETE
Date: 2026-09-07
Completion date: 2026-09-07

## Objective

Manage placement of the existing Ordicor Platform Lab subscription under
Platform / Connectivity using Foundation Terraform, consistent with
azure-platform-architecture ADR 0005 and the root structure in ADR 0008.

## Target Placement

- Subscription name: Ordicor Platform Lab
- Subscription ID: `0071dee8-974f-4f93-ad2a-0960557e1888`
- Tenant ID: `374de3fd-be72-4ad8-a047-2e29d3a023fd`
- Destination: Platform / Connectivity
- Stable destination ID: `platform-connectivity`
- Full destination ID: `/providers/Microsoft.Management/managementGroups/platform-connectivity`

## Scope

Manage exactly one existing subscription's management-group association in
[`platform/subscription-placement`](../../platform/subscription-placement/README.md).
No subscription is created, deleted, or recreated. Networking, DNS, policy,
RBAC, diagnostics, bootstrap, and remote-state migration are excluded.

## Implementation Decisions

- M1 checkpoint commit: `34bd4dff68204fa2823d3f4ed6a0fb1e8ef8ce95`.
- M2 branch: `feat/foundation-m2-subscription-placement`.
- One direct `azurerm_management_group_subscription_association` resource.
- An independent Terraform root and temporary local state isolate membership
  ownership from M1 hierarchy ownership and bootstrap.
- Destination supplied through M1's
  `management_group_resource_ids["platform-connectivity"]` output contract.
- No display-name selection logic or `terraform_remote_state` dependency.
- Existing subscription and destination are read-only Azure data sources.
- Provider tenant/subscription context is explicit; automatic provider
  registration is disabled and tenant-match preconditions are blocking.
- M1 continues omitting inline `subscription_ids` membership configuration.

## Pre-Apply Validation

- Terraform version: `1.15.8`.
- AzureRM provider: `4.81.0`.
- terraform fmt: PASS.
- terraform init: PASS.
- terraform validate: PASS.
- terraform plan: **1 add, 0 change, 0 destroy**.
- Saved plan JSON inspection: exactly one managed resource, with `create` action:
  `azurerm_management_group_subscription_association.placement`.
- Planned subscription: `/subscriptions/0071dee8-974f-4f93-ad2a-0960557e1888`.
- Planned destination: `/providers/Microsoft.Management/managementGroups/platform-connectivity`.
- The read-only subscription lookup returned display name `Ordicor Platform Lab`.
- Azure CLI independently confirmed `platform-connectivity` has display name
  `Connectivity` and actual parent `/providers/Microsoft.Management/managementGroups/platform`.
- Tenant precondition: PASS.
- No subscription resource deletion, creation, or replacement is proposed.
- No other managed resource actions are proposed. Three data sources are read-only.
- No provider or Terraform warnings were reported by init, validate, or plan.

The reviewed association create represented placement of the existing
subscription. It was subsequently applied and independently verified as recorded
below. Saved plan files and provider caches are Git-ignored.

## Apply Validation

PASS — the reviewed saved plan was applied successfully.

- Result: **Apply complete! Resources: 1 added, 0 changed, 0 destroyed.**
- Apply exit code: `0`.
- Resource: `azurerm_management_group_subscription_association.placement`.
- Association created:
  `/providers/Microsoft.Management/managementGroups/platform-connectivity/subscriptions/0071dee8-974f-4f93-ad2a-0960557e1888`.
- Existing subscription ID: `0071dee8-974f-4f93-ad2a-0960557e1888`.
- Destination management-group ID: `platform-connectivity`.
- Terraform version: `1.15.8`.
- AzureRM provider version: `4.81.0`.
- Tenant ID: `374de3fd-be72-4ad8-a047-2e29d3a023fd`.
- No subscription was created, deleted, or recreated. The only managed action
  changed its placement by creating the association.

## Post-Apply Azure Validation

PASS — independent read-only Azure CLI validation confirmed:

- `Ordicor Platform Lab` exists, remains Enabled, and retains subscription ID
  `0071dee8-974f-4f93-ad2a-0960557e1888` in the intended tenant.
- Its actual parent is `platform-connectivity` (Connectivity), whose parent is
  `platform` (Platform).
- Before apply, the recursive Tenant Root inventory contained exactly one
  subscription: this lab subscription, directly under Tenant Root.
- After apply, the recursive Tenant Root inventory contained the same single
  subscription, now under Platform / Connectivity. No other subscription
  placement changed and no additional subscription appeared or disappeared.

Evidence came from `az account management-group show --expand --recurse` on
Tenant Root before and after apply, and a read-only `az rest --method get`
request to the existing subscription endpoint after apply. Validation inspected
actual tree nesting, subscription IDs, display names, tenant ID, and state;
it did not rely solely on Terraform outputs or cached account selection.

## Post-Apply Terraform Validation

PASS — the refreshed plan reported:

**No changes. Your infrastructure matches the configuration.**

- Result: **0 to add, 0 to change, 0 to destroy**.
- `terraform plan -detailed-exitcode` returned `0`.
- No drift or unexpected resource action remains.
- No Terraform or Azure CLI warnings were reported during deployment and
  post-apply validation.

## Temporary POC State

Local `platform/subscription-placement/terraform.tfstate` is temporary POC
state. Retain it and appropriate backups while the association exists and
Terraform manages it. Do not discard active state merely to retry deployment.
It may be discarded after deliberate teardown or re-baselining that explicitly
resolves ownership and management of any surviving association. Remote-state
hardening is deferred. State, backups, and saved plans remain excluded from Git.

M2 is COMPLETE because apply, independent Azure placement validation, and the
clean post-apply Terraform plan all passed. M3 has not been started.
