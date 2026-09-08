# Non-Production Landing Zone Subscription

## Purpose and mechanism

Foundation M3 creates one MCA-billed subscription named
`Ordicor Non-Production Landing Zone` and places it under the existing
`landing-zones-nonproduction` management group. This independent root owns the
new subscription and its association; it does not adopt the existing lab
subscription or share M1/M2 state.

AzureRM 4.81.0 supports MCA invoice-section billing with `azurerm_subscription`.
It implements subscription creation through the supported
`Microsoft.Subscription/aliases` API (`2021-10-01`). Alias semantics do not
prevent Terraform from producing a meaningful creation plan. AzAPI, ARM
wrappers, CLI bootstrap, and post-creation import are unnecessary for a new
subscription that Terraform creates and tracks successfully.

The planned operations, only after explicit execution approval, are:

1. AzureRM creates alias `ordicor-nonprod-landing-zone` through
   `PUT /providers/Microsoft.Subscription/aliases/ordicor-nonprod-landing-zone?api-version=2021-10-01`,
   with `properties.displayName = Ordicor Non-Production Landing Zone`,
   `properties.billingScope = billing_scope_id`, and
   `properties.workload = Production`. Azure assigns the new subscription UUID.
2. After creation, AzureRM creates the management-group subscription association
   beneath `/providers/Microsoft.Management/managementGroups/landing-zones-nonproduction`
   using that new UUID. It never uses the provider-context subscription for
   placement.

`Production` is the standard Azure Plan billing workload category. It does not
select the production landing-zone hierarchy. The inspected billing profile
supports standard Azure Plan (`0001`); no DevTest billing entitlement was found.
The final destination remains Landing Zones / Non-Production.

## Inputs and stable contract

All four inputs are required:

| Input | Meaning |
|---|---|
| `tenant_id` | Explicit target tenant UUID |
| `provider_subscription_id` | Existing subscription used only for AzureRM context |
| `billing_scope_id` | Full existing MCA invoice-section resource ID |
| `management_group_resource_id` | M1 `management_group_resource_ids["landing-zones-nonproduction"]` output |

The root validates tenant context, restricts the destination to the stable
Non-Production resource ID, and checks the resulting subscription tenant before
placement. The subscription resource supplies billing scope and deliberately
omits an existing `subscription_id`, so it requests a new subscription.
No display-name selection logic or `terraform_remote_state` is used.

## Local validation and plan (PowerShell)

Use Terraform `1.15.8`, Azure CLI, and the committed AzureRM `4.81.0` lock file.
From the repository root, supply the approved target values from the milestone:

```powershell
$env:TF_VAR_tenant_id = '<target-tenant-uuid>'
$env:TF_VAR_provider_subscription_id = '<existing-provider-context-subscription-uuid>'
$env:TF_VAR_billing_scope_id = '<full-approved-MCA-invoice-section-resource-id>'
az login --tenant $env:TF_VAR_tenant_id
$context = az account show --subscription $env:TF_VAR_provider_subscription_id -o json | ConvertFrom-Json
if ($LASTEXITCODE -ne 0 -or $context.tenantId -ine $env:TF_VAR_tenant_id) {
  throw 'Unexpected Azure context'
}
$groups = terraform -chdir=platform/management-groups output -json management_group_resource_ids | ConvertFrom-Json
if ($LASTEXITCODE -ne 0 -or -not $groups.'landing-zones-nonproduction') {
  throw 'M1 destination output unavailable'
}
$env:TF_VAR_management_group_resource_id = $groups.'landing-zones-nonproduction'
terraform -chdir=platform/nonprod-subscription fmt -check
terraform -chdir=platform/nonprod-subscription init -input=false
terraform -chdir=platform/nonprod-subscription validate
terraform -chdir=platform/nonprod-subscription plan -input=false '-out=m3.tfplan'
terraform -chdir=platform/nonprod-subscription show m3.tfplan
```

Stop if any command fails. Require exactly two creates: one subscription and
one dependent association, with zero updates or destroys. The new UUID and
association ID are unknown until creation. Review billing scope, alias, display
name, and association dependency before approval. M3 has been applied and independently
validated; see its milestone for the assigned UUID. Future applies require
explicit authorization.
The saved-plan execution operation after approval is
`terraform -chdir=platform/nonprod-subscription apply -input=false m3.tfplan`.

The `nonproduction_subscription` output separates the alias resource ID from the
new subscription UUID/resource ID and reports the association and destination.
Existing CI automatically discovers this root for non-deploying validation.

## Billing and provider caveats

- Tenant Root Owner alone does not grant MCA billing creation rights. Read-only
  billing preflight must verify the supplied invoice section, active billing
  profile/account, enabled Azure Plan, and effective creation permissions.
- Check alias existence and existing subscriptions before first apply. Preserve
  the deterministic alias on retries; changing aliases after partial success
  can create duplicate subscriptions. If Azure creation succeeded but state
  tracking failed, inspect the existing alias and import/reconcile it before
  retrying. Do not start another subscription blindly.
- A successful plan is not an Azure subscription-creation dry run. Quotas,
  commerce eligibility, tenant policy, and eventual permission propagation can
  still block creation. Billing scope is not read back for drift by this provider.
- Creation and placement are separate operations. The new subscription may
  temporarily reside at the tenant's default management group. If placement
  fails, retain state and repair the association; do not create another subscription.
- No cross-tenant subscription creation is configured. A postcondition detects
  an unexpected returned tenant but cannot undo a subscription already created.
- `prevent_destroy = true` blocks planned subscription deletion/replacement
  while the resource remains configured. The provider explicitly enables
  `prevent_cancellation_on_destroy = true` as an additional cancellation guard;
  alias deletion still requires deliberate lifecycle review. These guards are
  not a substitute for an approved teardown/recovery procedure.

## Temporary state and exclusions

Temporary local state is accepted for this POC. Retain state and backups while
Terraform owns the subscription/association. It may be discarded only after
deliberate teardown or re-baselining resolves ownership of surviving resources.
Remote-state hardening is deferred. State, plans, and provider caches are ignored
by Git. Never reuse M1, M2, or bootstrap state in this root.

No networking, DNS, policy, RBAC assignments, diagnostics, workload resources,
bootstrap, M1 hierarchy changes, or M2 placement changes are implemented. The
billing platform's default subscription ownership remains service-controlled;
this root adds no role-assignment resource.

## Sources and evidence

- [AzureRM 4.81.0 subscription implementation](https://github.com/hashicorp/terraform-provider-azurerm/blob/v4.81.0/internal/services/subscription/subscription_resource.go)
- [Microsoft MCA subscription creation](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/programmatically-create-subscription-microsoft-customer-agreement)
- [M3 milestone and preflight evidence](../../docs/milestones/M3-nonprod-subscription.md)
