# Bootstrap Root Deployment

## Purpose

Bootstrap is responsible for creating the minimum Azure resources required to
allow the Azure Platform Framework to deploy itself.

This root currently deploys a single Azure Resource Group. This Resource Group
will later host the remote state storage account and other bootstrap resources.
Additional bootstrap resources will be introduced incrementally. Bootstrap
intentionally remains minimal.

## Future Responsibilities

Future bootstrap implementation is expected to include:

- Bootstrap resource group.
- Remote state storage account.
- Blob containers.
- Deployment identity enablement.
- Backend migration.

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
- One local module call to the reusable Resource Group module.
- Inputs for resource group name, location, and tags.
- Outputs for resource group ID, name, and location.

It does not include:

- Backend configuration.
- Remote state configuration.
- Storage account resources.
- Blob containers.
- Diagnostics.
- Management locks.
- Environment configuration.
- Workflow automation.

## Toolchain

This root follows the approved platform execution baseline:

- Terraform CLI: `1.15.8`
- AzureRM provider: `~> 4.80`

Terraform is the authoritative Infrastructure as Code engine for this platform.
OpenTofu compatibility is not part of the supported contract.
