# Subscription Placement Root Deployment

## Purpose and scope

Foundation M2 manages one existing subscription's association with an existing
management group. It does not create, delete, or recreate a subscription.
The POC destination is Platform / Connectivity, selected by M1's stable
`platform-connectivity` output key. Architecture ADR 0005 defines placement;
ADR 0008 permits an isolated Foundation subscription-placement deployment unit.

The root contains one `azurerm_management_group_subscription_association`
resource. Existing subscription, destination, and client context are read-only
data sources. No bootstrap, networking, DNS, policy, RBAC, diagnostics, or
management-group resources are managed here.

## Inputs and destination contract

All inputs are required, with no environment-specific defaults:

| Input | Contract |
|---|---|
| `tenant_id` | Intended Microsoft Entra tenant UUID |
| `subscription_id` | UUID of the existing subscription to place |
| `management_group_resource_id` | Full destination resource ID from M1 outputs |

The provider uses explicit tenant and subscription IDs and disables automatic
resource-provider registration. A blocking precondition checks both the
provider and subscription tenant against `tenant_id`.

Pass M1's `management_group_resource_ids["platform-connectivity"]` value into
this root. The stable ID selects the Azure data source; display names are only
reported as descriptive outputs. No `terraform_remote_state` dependency is
introduced. M1 retains hierarchy ownership and must continue omitting
`subscription_ids` from its management-group resources to avoid conflicting
membership ownership.

## Prerequisites and local workflow

Use Terraform exactly `1.15.8`, AzureRM locked to `4.81.0`, and Azure CLI on PATH.
M1 must have been applied, its authoritative local state must be available for
output retrieval, and the operator must have permission to move this existing
subscription between its current and destination management groups. Review
inherited governance at the destination before any approved move.

From the repository root in PowerShell, substitute the intended UUIDs:

```powershell
$env:TF_VAR_tenant_id = '<target-tenant-uuid>'
$env:TF_VAR_subscription_id = '<existing-subscription-uuid>'
az login --tenant $env:TF_VAR_tenant_id
$account = az account show --subscription $env:TF_VAR_subscription_id -o json | ConvertFrom-Json
if ($LASTEXITCODE -ne 0 -or $account.tenantId -ine $env:TF_VAR_tenant_id) {
  throw 'Subscription does not match the intended tenant'
}
$groups = terraform -chdir=platform/management-groups output -json management_group_resource_ids | ConvertFrom-Json
if ($LASTEXITCODE -ne 0 -or -not $groups.'platform-connectivity') {
  throw 'M1 Connectivity output is unavailable'
}
$env:TF_VAR_management_group_resource_id = $groups.'platform-connectivity'

terraform -chdir=platform/subscription-placement fmt -check
terraform -chdir=platform/subscription-placement init -input=false
terraform -chdir=platform/subscription-placement validate
terraform -chdir=platform/subscription-placement plan -input=false '-out=m2.tfplan'
terraform -chdir=platform/subscription-placement show m2.tfplan
```

Stop on any failed command. Review exactly one association create, the expected
subscription resource ID, and the destination resource ID. No other managed
resource action is expected. A Terraform association create represents placement
of the existing subscription, not creation of a new subscription. If the
association already exists, review importing it into this root instead of
applying a duplicate association.

M2 has been applied and validated; see its milestone record. Future changes
require explicit approval. Apply only the reviewed
saved plan from this root, independently query Azure for actual subscription
placement, and run a fresh plan requiring zero changes before completion.

## State and lifecycle

This independent root uses temporary local state for the POC. Preserve
`platform/subscription-placement/terraform.tfstate` and backups after apply;
never substitute M1 or bootstrap state. Local state and plan files are ignored
by Git. Use one authoritative working directory and operator until remote
state is deliberately introduced. No backend migration is included.

Association removal or replacement can change subscription placement and
inherited governance. Do not use destroy as routine cleanup; review and approve
any reassignment separately. Subscription lifecycle remains outside this root.

## Output and validation

`subscription_placement` exposes the association ID, existing subscription UUID
and display name, and destination short ID, full resource ID, and display name.
The existing CI discovers this root under `platform/*` and runs formatting,
initialization without a backend, and validation. No deployment CI is added.

See [M2 milestone](../../docs/milestones/M2-subscription-placement.md) for the
specific POC target and current validation evidence.
