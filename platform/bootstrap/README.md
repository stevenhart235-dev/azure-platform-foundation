# Bootstrap Root Deployment

## Purpose

Bootstrap is responsible for creating the minimum Azure resources required to
allow the Azure Platform Framework to deploy itself.

This directory is a Terraform root deployment scaffold. It intentionally does
not create Azure resources yet.

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

## Current Scope

This scaffold is intentionally minimal. It includes only:

- Terraform root version constraints.
- AzureRM provider requirement.
- AzureRM provider configuration.

It does not include:

- Backend configuration.
- Remote state configuration.
- Azure resources.
- Module calls.
- Variables.
- Outputs.
- Environment configuration.
- Workflow automation.

## Toolchain

This root follows the approved platform execution baseline:

- Terraform CLI: `1.15.8`
- AzureRM provider: `~> 4.80`

Terraform is the authoritative Infrastructure as Code engine for this platform.
OpenTofu compatibility is not part of the supported contract.

