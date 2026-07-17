# Bootstrap Root Deployment

## Purpose

Bootstrap is responsible for creating the minimum Azure resources required to
allow the Azure Platform Framework to deploy itself.

This root defines the first Foundation bootstrap composition slice. It creates
the minimum state backend resources from released reusable modules:

- Bootstrap resource group.
- Bootstrap state storage account.
- Private `bootstrap` Terraform state container.

Bootstrap intentionally remains minimal. It does not yet configure or migrate
Terraform state to the remote backend.

## Future Responsibilities

Future bootstrap implementation is expected to include:

- Deployment identity enablement.
- Backend configuration.
- Backend migration.
- Additional state containers when their state boundaries are implemented.

## Out Of Scope

Bootstrap does not own:

- Management groups.
- Governance.
- Networking.
- Shared services.

Those concerns belong to their approved foundation or connectivity deployment
units.

## Implementation

This root currently includes:

- Terraform root version constraints.
- AzureRM provider requirement.
- AzureRM provider configuration.
- Immutable module references to released reusable modules:
  - `resource-group-v0.1.0`
  - `storage-account-v0.1.1`
  - `storage-container-v0.1.0`
- A bootstrap resource group module call.
- A bootstrap state storage account module call.
- A private bootstrap state container module call.
- Foundation-composed effective tags.
- Caller-supplied naming and storage network inputs.
- Non-secret outputs for the created bootstrap resources.

It does not include:

- Backend configuration.
- Remote state configuration.
- State migration.
- Diagnostics.
- Management locks.
- Environment configuration.
- Workflow automation.

## State Phase

Initial bootstrap may use temporary local Terraform state because the remote
backend does not exist until this root is applied. After the backend resources
exist, a later change must add the root backend configuration and migrate
bootstrap state to Azure Blob Storage. Local state must not be committed and
must not remain the normal operating mode after migration.

## Network Access

The bootstrap state storage account keeps public network access disabled by
default through `storage_account_public_network_access_enabled = false`.

The lab architecture allows temporary public Azure endpoint access during
bootstrap, but this must be an explicit input configuration choice. This root
does not silently enable public network access.

## Validation

Validation for this root is non-deploying:

```text
terraform fmt -recursive
terraform -chdir=platform/bootstrap init -backend=false -input=false
terraform -chdir=platform/bootstrap validate
terraform fmt -check -recursive
```

Validation does not run `terraform apply` and does not migrate state.

## Toolchain

This root follows the approved platform execution baseline:

- Terraform CLI: `1.15.8`
- AzureRM provider: `~> 4.80`
- Initial lock-file-selected AzureRM provider: `4.81.0`

Terraform is the authoritative Infrastructure as Code engine for this platform.
OpenTofu compatibility is not part of the supported contract.

## Next Milestone

The next bootstrap step is to execute the controlled temporary local-state
bootstrap, then add backend configuration and migrate bootstrap state to Azure
Blob Storage using Microsoft Entra authentication and Azure RBAC. That work is
intentionally deferred from this composition slice.
