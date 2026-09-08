# M1 - Management Group Hierarchy

Status: COMPLETE
Date: 2026-09-07
Completion date: 2026-09-07

## Objective

Implement the management-group hierarchy defined by
azure-platform-architecture ADR 0005.

## Target Hierarchy

```text
Tenant Root
├── Platform
│   ├── Management
│   ├── Identity
│   ├── Connectivity
│   └── Shared Services
├── Landing Zones
│   ├── Production
│   ├── Non-Production
│   └── Sandbox
└── Decommissioned
```

## Scope

This milestone defines the following ten management groups in
[`platform/management-groups`](../../platform/management-groups/README.md).
All ten groups were created and verified in Azure on 2026-09-07. The existing
Tenant Root is not created or managed by this root.

| Display name | Stable management-group ID | Parent |
|---|---|---|
| Platform | `platform` | Tenant Root |
| Management | `platform-management` | Platform |
| Identity | `platform-identity` | Platform |
| Connectivity | `platform-connectivity` | Platform |
| Shared Services | `platform-shared-services` | Platform |
| Landing Zones | `landing-zones` | Tenant Root |
| Production | `landing-zones-production` | Landing Zones |
| Non-Production | `landing-zones-nonproduction` | Landing Zones |
| Sandbox | `landing-zones-sandbox` | Landing Zones |
| Decommissioned | `decommissioned` | Tenant Root |

This milestone does NOT include:

- subscription creation
- subscription placement
- policy
- RBAC
- networking
- DNS
- diagnostics
- remote-state migration

## Implementation Decisions

- Management groups are implemented directly with `azurerm_management_group`
  resources in Foundation.
- No reusable management-group module was introduced for M1.
- Stable management-group IDs are used, separately from display names.
- Parent relationships are explicit.
- Tenant identity is validated by the Terraform root through a required tenant
  input, explicit provider tenant configuration, and blocking tenant-match
  preconditions.
- Temporary local state is accepted for this POC. This independent root does
  not share bootstrap state.

## Pre-Apply Validation

Evidence established before apply:

- terraform fmt: PASS
- terraform init: PASS
- terraform validate: PASS
- Terraform execution version: `1.15.8`
- AzureRM provider: `4.81.0`
- terraform plan: **10 add, 0 change, 0 destroy**
- plan inspection: exactly **10 `azurerm_management_group` resources**
- no subscription movement
- no non-management-group resources proposed for creation
- all parent relationships match the target hierarchy
- tenant: `374de3fd-be72-4ad8-a047-2e29d3a023fd`

The provider client-configuration data source is read-only and is used for
validation; it does not create an Azure resource. Plan validation does not
constitute apply or post-apply Azure validation. Local saved plans are excluded
from Git.

## Apply Validation

PASS — the reviewed saved plan was applied successfully on 2026-09-07.

- Command: `terraform -chdir=platform/management-groups apply -input=false m1.tfplan`
- Result: **Apply complete! Resources: 10 added, 0 changed, 0 destroyed.**
- Apply exit code: `0`.
- All ten created resources are `azurerm_management_group` resources.
- No subscriptions were created, moved, or modified by this deployment.
- Terraform version: `1.15.8`.
- AzureRM provider version: `4.81.0`.
- Tenant ID: `374de3fd-be72-4ad8-a047-2e29d3a023fd`.
- Completion date: `2026-09-07` (America/Chicago).

Temporary local state at `platform/management-groups/terraform.tfstate` is now
authoritative for these ten management groups. Preserve it and its backups;
state and saved plan files are excluded from Git. No remote-state migration
was performed.

## Post-Apply Azure Validation

PASS — read-only Azure CLI queries independently verified all ten deployed
management groups, including their actual parent resource IDs.

For each stable ID, validation used `az account management-group show --name`
with a projection of `name`, `displayName`, `tenantId`, and `details.parent.id`.
Every returned tenant ID matched `374de3fd-be72-4ad8-a047-2e29d3a023fd`.

Observed Azure relationships (parent names below are the final segments of the
returned full `/providers/Microsoft.Management/managementGroups/...` IDs):

| Observed management-group ID | Observed display name | Observed parent ID |
|---|---|---|
| `platform` | Platform | `374de3fd-be72-4ad8-a047-2e29d3a023fd` |
| `platform-management` | Management | `platform` |
| `platform-identity` | Identity | `platform` |
| `platform-connectivity` | Connectivity | `platform` |
| `platform-shared-services` | Shared Services | `platform` |
| `landing-zones` | Landing Zones | `374de3fd-be72-4ad8-a047-2e29d3a023fd` |
| `landing-zones-production` | Production | `landing-zones` |
| `landing-zones-nonproduction` | Non-Production | `landing-zones` |
| `landing-zones-sandbox` | Sandbox | `landing-zones` |
| `decommissioned` | Decommissioned | `374de3fd-be72-4ad8-a047-2e29d3a023fd` |

## Post-Apply Terraform Validation

PASS — a refreshed post-apply plan reported:

**No changes. Your infrastructure matches the configuration.**

- Result: **0 to add, 0 to change, 0 to destroy**.
- `terraform plan -detailed-exitcode` returned `0`.
- The plan used the same tenant, Terraform `1.15.8`, and AzureRM `4.81.0`.
- No remaining Terraform drift was detected.
- No Terraform or Azure CLI warnings were reported during apply or post-apply
  validation.

M1 is COMPLETE because apply, independent Azure parent validation, and the
post-apply clean-plan check all passed. M2 has not been started.

## Next Milestone

M2 - Subscription Placement
