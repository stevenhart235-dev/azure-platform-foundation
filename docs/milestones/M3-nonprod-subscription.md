# M3 - Non-Production Landing Zone Subscription

Status: COMPLETE
Date: 2026-09-08
Completion date: 2026-09-08

## Objective

Create exactly one POC subscription named `Ordicor Non-Production Landing Zone`
and place it under Landing Zones / Non-Production (`landing-zones-nonproduction`).
Architecture remains owned by azure-platform-architecture; ADR 0005 supplies the
hierarchy and ADR 0008 permits the isolated Foundation deployment root.

## Billing Model and Target

- Model: Microsoft Customer Agreement (MCA), invoice-section billing scope.
- Tenant: `374de3fd-be72-4ad8-a047-2e29d3a023fd`.
- Provider-context subscription: existing Ordicor Platform Lab,
  `0071dee8-974f-4f93-ad2a-0960557e1888`; read-only context, not adopted or modified.
- Destination: `/providers/Microsoft.Management/managementGroups/landing-zones-nonproduction`.
- Creation alias: `ordicor-nonprod-landing-zone`.
- Subscription display name: `Ordicor Non-Production Landing Zone`.
- Approved supplied billing scope:

```text
/providers/Microsoft.Billing/billingAccounts/624ef094-8147-5c7f-74b0-749fae21bc86:70905e55-0bc0-4162-8d89-3538cf5cd99e_2019-05-31/billingProfiles/HLUB-Z6S3-BG7-PGB/invoiceSections/5f20f7db-9751-414b-bcaf-5308091bce76
```

## Selected Subscription Creation Mechanism

Use `azurerm_subscription` with `billing_scope_id` and no existing
`subscription_id`, followed by one dependent
`azurerm_management_group_subscription_association` in
[`platform/nonprod-subscription`](../../platform/nonprod-subscription/README.md).

AzureRM 4.81.0 implements MCA creation using the supported
`Microsoft.Subscription/aliases` API version `2021-10-01`. Its installed schema
and version-specific source confirm MCA support and the computed new UUID.
Terraform can therefore own both creation and placement with a meaningful plan.
No AzAPI, deprecated enrollment pattern, imperative bootstrap, or planned import
is needed. This is one POC root, not a general subscription-vending framework.

The destination is passed from M1's stable
`management_group_resource_ids["landing-zones-nonproduction"]` output. Placement
references only the new subscription UUID returned by the creation resource.
The stable alias provides a recognizable recovery/import target. Subscription
replacement/destruction is protected, and provider cancellation is disabled.

The billing workload is explicitly `Production`, meaning the standard Azure
Plan (`0001`) available on this billing profile. The environment remains
Non-Production; DevTest pricing eligibility is not assumed.

## Pre-Apply Validation and Read-Only Preflight

- M2 checkpoint: `924c82353b58b4ef0fdeb4f13d3f899813b1a7f3`.
- Branch: `feat/foundation-m3-nonprod-subscription`.
- Terraform: `1.15.8`; AzureRM: `4.81.0`.
- terraform fmt: PASS.
- terraform init: PASS.
- terraform validate: PASS.
- terraform plan: **2 add, 0 change, 0 destroy**.
- Exactly one `azurerm_subscription.nonproduction` create.
- Exactly one `azurerm_management_group_subscription_association.nonproduction` create.
- Plan billing scope exactly matches the supplied MCA scope above.
- Planned subscription name and alias match the target above.
- Association destination is `landing-zones-nonproduction`; its subscription ID
  depends on the newly created subscription, not the existing lab UUID.
- No other managed resources or actions are proposed.
- Authenticated tenant and provider-context subscription match the requested tenant.
- Billing account reports `MicrosoftCustomerAgreement` and Active status.
- Billing profile and exact invoice section are Active. Enabled plan is standard
  Microsoft Azure Plan (`0001`).
- Effective invoice-section permissions include every action in the live
  `Azure subscription creator` role definition (read-only permission comparison).
- Subscription alias list returned no aliases and no continuation page.
- ARM subscription list returned only the existing enabled Ordicor Platform Lab
  subscription, with no continuation page; no new subscription exists.
- Azure CLI confirms Non-Production's actual parent is `landing-zones`.
- No Terraform/provider warnings were reported during init, validate, or plan.

Preflight used GET operations for billing account/profile/invoice section,
billing permissions/role definitions, subscription aliases, and subscriptions,
plus read-only management-group queries. No billing mutation or subscription
creation was executed.

## Expected Azure Actions and Limitations

After approval, Terraform will submit one alias creation request with the
supplied billing scope and display name, wait for the new subscription UUID,
and associate that UUID with Non-Production. There are two Terraform managed
creates but only one new Azure subscription.

A plan does not reserve a UUID or guarantee commerce eligibility, quota, or
apply-time permissions. Billing permission preflight is evidence, not execution.
The new subscription can temporarily exist in the tenant's default management
group before placement. A placement failure must be recovered using retained
state and the same alias; do not create another subscription. This provider does
not independently read back billing scope for drift. See the root README for
exact API operation, lifecycle protections, and recovery limits.

## Temporary POC State

Retain local state and backups while Terraform manages the new subscription and
association. State may be discarded after deliberate teardown/re-baselining
resolves any surviving Azure resources and their ownership. Remote-state
hardening is deferred. State, plans, caches, and local inputs must not be committed.

## Explicit Exclusions

No changes to M1 management groups, M2 placement, existing lab subscription,
networking, DNS, policy, RBAC assignments, diagnostics, bootstrap, workloads,
or remote-state migration. No generalized subscription-vending pipeline.

## Execution Approval and Completion

Execution was explicitly approved and completed successfully. M3 is COMPLETE.

### Apply Result

- **Apply complete! Resources: 2 added, 0 changed, 0 destroyed.**
- Apply exit code: `0`.
- One `azurerm_subscription` and one dependent management-group association.
- Azure-assigned subscription UUID: `96b5adf1-55d9-4411-ae2a-adfaccecf80e`.
- Display name: `Ordicor Non-Production Landing Zone`.
- Subscription state: `Enabled`.
- Tenant: `374de3fd-be72-4ad8-a047-2e29d3a023fd`.
- Alias: `ordicor-nonprod-landing-zone`; Azure reported provisioning `Succeeded`.
- Billing model: MCA, using the exact invoice-section billing scope recorded
  above and inspected in the applied plan.
- Workload classification: `Production` (standard Microsoft Azure Plan billing;
  the management-group lifecycle classification remains Non-Production).
- Destination: `/providers/Microsoft.Management/managementGroups/landing-zones-nonproduction`.
- Terraform version: `1.15.8`; AzureRM provider version: `4.81.0`.

### Independent Azure CLI Validation

PASS — read-only ARM subscription inventory and recursive Tenant Root queries
verified both subscriptions' IDs, names, Enabled state, tenant, actual parents,
and parent management-group ancestry. The alias GET independently confirmed the
new UUID and successful provisioning.

| Subscription | UUID | State | Actual management-group path |
|---|---|---|---|
| Ordicor Platform Lab | `0071dee8-974f-4f93-ad2a-0960557e1888` | Enabled | Platform / Connectivity |
| Ordicor Non-Production Landing Zone | `96b5adf1-55d9-4411-ae2a-adfaccecf80e` | Enabled | Landing Zones / Non-Production |

Before apply: exactly one subscription, the existing lab UUID. After apply:
exactly two subscriptions, retaining that UUID and adding only the new UUID.
Neither inventory had a continuation page. Both belong to the expected tenant.
The existing lab subscription remains under `platform-connectivity`; the new
subscription is under `landing-zones-nonproduction`. No existing subscription
was recreated or reassigned.

Validation used `az rest --method get` for the ARM subscription list and alias,
and `az account management-group show --expand --recurse` on Tenant Root.
No credentials or tokens are recorded here. Billing scope is recorded from the
reviewed/applied configuration; AzureRM does not independently read it back for
drift verification.

### Post-Apply Terraform Plan

PASS — **No changes. Your infrastructure matches the configuration.**

- **0 to add, 0 to change, 0 to destroy**.
- `terraform plan -detailed-exitcode` returned `0`.
- No drift or unexpected resource action remained.
- No Terraform, billing, or Azure CLI warning/error messages were reported
  during apply and post-apply validation.

The local state now manages this subscription and association. It remains
**temporary POC state, not permanent production state**; preserve it according
to the Temporary POC State guidance above. M4 has not been started. No networking
or workload infrastructure was created.

## Sources

- [AzureRM 4.81.0 subscription implementation](https://github.com/hashicorp/terraform-provider-azurerm/blob/v4.81.0/internal/services/subscription/subscription_resource.go)
- [Microsoft MCA creation guidance](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/programmatically-create-subscription-microsoft-customer-agreement)
- [Invoice-section billing permissions API](https://learn.microsoft.com/en-us/rest/api/billing/billing-permissions/list-by-invoice-section?view=rest-billing-2024-04-01)
