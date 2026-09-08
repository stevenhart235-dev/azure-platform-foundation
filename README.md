# azure-platform-foundation

Azure platform foundation root deployments for the Azure Platform Framework.

This repository owns the foundation deployment layer. Its expected future scope
includes management groups, platform subscription placement and enrollment,
policy and governance assignments, identity and RBAC assignments, management and
observability resources, bootstrap implementation, and foundation state
configuration.

Foundation roots:

- [`platform/bootstrap`](platform/bootstrap/README.md): released reusable module
  composition for bootstrap state infrastructure.
- [`platform/management-groups`](platform/management-groups/README.md): Foundation
  M1, ten management groups with explicit tenant context and parent relationships.
  This POC root uses direct resources and temporary local state. Subscription
  placement and governance are deferred; implementation does not imply apply.

Current bootstrap module composition:

- `resource-group-v0.1.0`
- `storage-account-v0.1.1`
- `storage-container-v0.1.0`

## Repository Boundary

This repository is a deployment repository, not a reusable module repository.

Belongs here:

- Foundation Terraform root deployments when implementation begins.
- Foundation environment configuration.
- Foundation provider and backend configuration in root modules.
- Foundation dependency lock files for real root deployments.
- Foundation deployment documentation and runbooks.
- Bootstrap documentation and implementation when deliberately defined.

Does not belong here:

- Reusable child module source. Reusable modules belong in
  `azure-platform-modules`.
- Enterprise hub networking, firewall, routing, DNS, hybrid connectivity, or
  spoke onboarding implementation. Connectivity belongs in
  `azure-platform-connectivity`.
- Terraform state, state backups, or committed plan files.
- Secrets, credentials, private keys, client secrets, tenant IDs,
  subscription IDs, or local developer overrides.

## Architecture Authority

This repository follows a single-source-of-truth architecture.

Architecture decisions, accepted ADRs, engineering standards, and roadmap
guidance are maintained in the sibling `azure-platform-architecture`
repository.

This repository consumes those decisions rather than redefining or duplicating
them.

All architectural changes should be proposed and accepted in the architecture
repository before implementation here.

Authoritative content categories include:

- AI Assistant Guide.
- Accepted ADRs.
- Engineering Standards.
- Roadmap.

## Toolchain Baseline

Terraform is the authoritative Infrastructure as Code engine for this platform.
OpenTofu compatibility is not part of the supported contract.

Current accepted baseline:

- Approved Terraform execution version: `1.15.8`.
- AzureRM release-validation and initial root lock version: `4.81.0`.
- Root deployments own provider configuration.
- Root deployments own backend configuration.
- Root deployments own environment values.
- Root deployments commit dependency lock files.
- AzAPI is excluded until a real platform capability justifies it.

## Current Status

This repository is not a complete implemented foundation platform.

Status snapshot as of 2026-07-20:

- Repository scaffold is established.
- `platform/bootstrap` defines the first bootstrap composition slice.
- The first controlled Azure lab bootstrap deployment succeeded.
- Deployed lab resources:
  - Resource group: `rg-platform-bootstrap-lab`
  - Storage account: `stplatformbootlab01`
  - Private state container: `bootstrap`
  - Region: `centralus`
- Temporary local Terraform state is currently authoritative for bootstrap.
- No backend is configured.
- Bootstrap state migration remains deferred.

The initial bootstrap used a temporary public network access exception with a
narrowly scoped IP rule so Terraform could run from a local workstation. Shared
Key remains disabled, and AzureRM uses Microsoft Entra authentication for
supported Storage operations. The temporary network exception must be removed
after a suitable remote-state execution path is established.

Do not delete the local bootstrap `terraform.tfstate` file before successful
state migration. Backend configuration and migration remain separate future
work.

## Ownership

CODEOWNERS currently uses role-oriented placeholder teams. Replace those
placeholders with real GitHub teams when source-control teams are configured.

## Contribution Workflow

All changes should be made through reviewed pull requests into protected
`main`. Direct commits to `main` are prohibited.

Before proposing changes:

1. Read `docs/ai/assistant-guide.md`.
2. Read the relevant ADRs and standards in `azure-platform-architecture`.
3. Confirm the change belongs in `azure-platform-foundation`.
4. Keep the pull request focused.
5. Do not add prohibited content.
6. Provide validation evidence appropriate to the change.
