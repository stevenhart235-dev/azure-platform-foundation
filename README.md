# azure-platform-foundation

Azure platform foundation root deployments for the Azure Platform Framework.

This repository owns the foundation deployment layer. Its expected future scope
includes management groups, platform subscription placement and enrollment,
policy and governance assignments, identity and RBAC assignments, management and
observability resources, bootstrap implementation, and foundation state
configuration.

No deployable Terraform exists in this repository yet. Current work is limited
to repository foundation and bootstrap design.

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

## Authoritative Standards

Architecture decisions and engineering standards live in the sibling
`azure-platform-architecture` repository. This repository references those
standards instead of copying or redefining them.

Relevant source documents include:

- `../azure-platform-architecture/docs/ai/assistant-guide.md`
- `../azure-platform-architecture/docs/adr/0001-iac-engine.md`
- `../azure-platform-architecture/docs/adr/0002-repository-separation.md`
- `../azure-platform-architecture/docs/adr/0003-terraform-toolchain-baseline.md`
- `../azure-platform-architecture/docs/adr/0004-remote-state-strategy.md`
- `../azure-platform-architecture/docs/adr/0005-management-group-hierarchy.md`
- `../azure-platform-architecture/docs/adr/0006-deployment-identity-strategy.md`
- `../azure-platform-architecture/docs/standards/repository-standard.md`
- `../azure-platform-architecture/docs/standards/versioning-standard.md`
- `../azure-platform-architecture/docs/standards/engineering-validation-standard.md`

## Toolchain Baseline

Terraform is the authoritative Infrastructure as Code engine for this platform.
OpenTofu compatibility is not part of the supported contract.

Current accepted baseline:

- Approved Terraform execution version: `1.15.8`.
- AzureRM release-validation and initial root lock version: `4.80.0`.
- Root deployments own provider configuration.
- Root deployments own backend configuration.
- Root deployments own environment values.
- Root deployments commit dependency lock files.
- AzAPI is excluded until a real platform capability justifies it.

## Current Status

This repository is not an implemented foundation platform.

Status snapshot as of 2026-07-16:

- Repository scaffold is being established.
- No Terraform root deployment exists yet.
- No backend is configured.
- No Azure resources have been created by this repository.
- Bootstrap implementation remains deferred until its directory structure and
  execution model are deliberately defined.

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

