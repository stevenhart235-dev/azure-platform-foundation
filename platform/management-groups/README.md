# Management Groups Root Deployment

## Purpose and scope

Foundation M1 creates the ten management groups below the existing Tenant Root.
This independent root owns hierarchy resources directly with
`azurerm_management_group`; it does not consume a reusable module.

Architecture remains authoritative in `azure-platform-architecture`, especially
ADRs 0005 (hierarchy) and 0008 (root layout). For this POC milestone, direct
resources and temporary local state are explicitly authorized. This is a
temporary execution phase, not a change to the long-term remote-state strategy.
The state boundary contains these ten management groups only and is separate
from `platform/bootstrap`.

This root does not create or place subscriptions, assign policy or RBAC, or
deploy logging, networking, DNS, deployment identities, or a remote backend.
Shared networking and DNS remain owned by `azure-platform-connectivity`.

## Hierarchy and stable identifiers

```text
Tenant Root (the supplied tenant UUID; already exists)
|-- Platform [platform]
|   |-- Management [platform-management]
|   |-- Identity [platform-identity]
|   |-- Connectivity [platform-connectivity]
|   `-- Shared Services [platform-shared-services]
|-- Landing Zones [landing-zones]
|   |-- Production [landing-zones-production]
|   |-- Non-Production [landing-zones-nonproduction]
|   `-- Sandbox [landing-zones-sandbox]
`-- Decommissioned [decommissioned]
```

Bracketed values are stable Azure management-group names/IDs, separate from
display names. These explicit capability IDs follow the milestone contract;
the naming standard has not established a different final token convention.
Do not rename IDs casually: changing `name` requires replacement. All three
top-level groups explicitly reference Tenant Root; children reference their
managed parent's resource ID so Terraform orders creation correctly.

## Prerequisites and tenant contract

- Terraform exactly `1.15.8` and Azure CLI available on PATH.
- AzureRM `~> 4.80`, initially locked to `4.81.0`.
- An authenticated operator with Owner at the intended Tenant Root management
  group, or equivalent permissions to create and manage this hierarchy.
- An accessible subscription in that tenant for AzureRM provider context. It
  is not created, moved, or managed by this root.
- Check the existing hierarchy for these IDs before first apply. Existing
  groups require reviewed imports and a fresh plan rather than blind creation.

`tenant_id` is the sole required Terraform input. It has no default and must be
a UUID. It configures provider authentication and determines the Tenant Root
resource ID. Blocking preconditions compare the provider's authenticated tenant
with this input. The operator must still deliberately select the intended tenant.
Provider auto-registration is disabled to avoid subscription registration side
effects. Supply the subscription context through `ARM_SUBSCRIPTION_ID`; no real
tenant or subscription identifier is embedded in source.

## Local workflow (PowerShell)

Run from the repository root. Replace the placeholders with the intended values.
The account check stops execution if the selected subscription belongs to another
tenant; do not derive the intended tenant silently from the active account.

```powershell
$env:TF_VAR_tenant_id = '<target-tenant-uuid>'
az login --tenant $env:TF_VAR_tenant_id
az account set --subscription '<provider-context-subscription-uuid>'
if ($LASTEXITCODE -ne 0) { throw 'Azure subscription selection failed' }
$account = az account show --output json | ConvertFrom-Json
if ($LASTEXITCODE -ne 0 -or $account.tenantId -ine $env:TF_VAR_tenant_id) {
  throw 'Selected Azure account does not match the intended tenant'
}
$env:ARM_SUBSCRIPTION_ID = $account.id

terraform -chdir=platform/management-groups fmt -check
terraform -chdir=platform/management-groups init -input=false
terraform -chdir=platform/management-groups validate
terraform -chdir=platform/management-groups plan -input=false '-out=m1.tfplan'
terraform -chdir=platform/management-groups show m1.tfplan
```

Stop if any command fails. Before first apply, confirm **10 to add, 0 to change,
0 to destroy**, exclusively management-group resources, with the parents shown
above. Child parent IDs may display as known after apply; their references in
`main.tf` establish the dependency. `subscription_ids` is deliberately omitted,
not set to an empty list, so this root does not manage subscription membership.

Only after explicit approval of the saved plan, apply it in the same root:

```powershell
terraform -chdir=platform/management-groups apply m1.tfplan
terraform -chdir=platform/management-groups output -json management_groups
```

The implementation/validation milestone does not itself authorize apply.
Expected Azure result: ten management groups under the existing Tenant Root,
with the displayed hierarchy and no subscription placement changes. A plan is
not proof that creation permissions or name availability will succeed at apply.

## Outputs

All maps are keyed by the stable IDs in the hierarchy:

- `management_group_ids`: each short management-group ID (`name`).
- `management_group_resource_ids`: each full Azure resource ID.
- `management_groups`: each group's `management_group_id`, `resource_id`,
  `display_name`, and `parent_management_group_id` for future placement,
  policy, and RBAC integration.

Pass these outputs explicitly when future consumers are implemented. No
cross-state dependency is introduced here.

## Local state and destroy warnings

There is no backend block. After apply, `platform/management-groups/terraform.tfstate`
is authoritative for this root. Preserve and securely back it up alongside any
backup state; do not commit state, plan files, or local environment inputs.
Existing ignore rules exclude these artifacts. Use one operator and one
authoritative working directory during the POC; separate copies do not provide
shared locking. Never delete state to retry a deployment or reuse bootstrap
state for this root. Remote-state migration is separate future work.

Do not run destroy as routine cleanup. Later subscription placement, policy,
and RBAC will depend on these groups and their scopes. Deletion may be blocked
by children or subscriptions and can affect governance dependencies. Review all
dependents, export/backup state, and obtain explicit approval before a destroy
or a change to stable IDs or parents. No destroy is authorized by M1.

## CI validation

The existing workflow automatically discovers this root under `platform/*`,
runs repository formatting checks, initializes with `-backend=false`, and runs
`terraform validate`. It does not authenticate to Azure, plan, or apply.
