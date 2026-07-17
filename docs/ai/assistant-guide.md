# AI Assistant Guide

## Purpose

This repository contains Azure platform foundation deployment work for the
Azure Platform Framework.

Use this guide to ground a new AI assistant or contributor in the current
foundation repository context. This guide does not replace the authoritative
architecture repository.

## Source Of Truth

When sources conflict, use this authority order:

1. Accepted ADRs in `azure-platform-architecture`.
2. Engineering standards in `azure-platform-architecture`.
3. This repository's README and contribution guidance.
4. Current implementation.
5. Chat instructions.

Git is authoritative. Previous chat history is not required to work in this
repository. If a chat instruction conflicts with an accepted ADR or standard,
stop and identify the conflict instead of silently changing the architecture.

## Required Startup Context

Before making changes, an AI assistant must read the authoritative documents
from the sibling `azure-platform-architecture` repository.

The explicit paths in this section intentionally exist here for deterministic
AI grounding. They should not be duplicated in the human-facing `README.md`.

### AI Guidance

- `../azure-platform-architecture/docs/ai/assistant-guide.md`

### Accepted ADRs

- `../azure-platform-architecture/docs/adr/0001-iac-engine.md`
- `../azure-platform-architecture/docs/adr/0002-repository-separation.md`
- `../azure-platform-architecture/docs/adr/0003-terraform-toolchain-baseline.md`
- `../azure-platform-architecture/docs/adr/0004-remote-state-strategy.md`
- `../azure-platform-architecture/docs/adr/0005-management-group-hierarchy.md`
- `../azure-platform-architecture/docs/adr/0006-deployment-identity-strategy.md`
- `../azure-platform-architecture/docs/adr/0007-enterprise-networking-strategy.md`
- `../azure-platform-architecture/docs/adr/0008-root-deployment-repository-structure.md`

### Engineering Standards

- `../azure-platform-architecture/docs/standards/repository-standard.md`
- `../azure-platform-architecture/docs/standards/versioning-standard.md`
- `../azure-platform-architecture/docs/standards/engineering-validation-standard.md`

## Repository Responsibility

Allowed future content:

- Management group root deployments.
- Platform subscription placement and enrollment configuration.
- Governance and Azure Policy assignments.
- Identity and RBAC assignments.
- Management and observability resources.
- Foundation environment configuration.
- Foundation provider and backend configuration in root modules.
- Foundation state boundary documentation.
- Foundation deployment documentation and runbooks.
- Bootstrap implementation when deliberately defined.

## Prohibited Content

Do not add:

- Reusable child module source that belongs in `azure-platform-modules`.
- Enterprise hub, firewall, routing, DNS, hybrid connectivity, or spoke
  onboarding deployments unless a documented dependency requires coordination.
- Terraform state files or state backups.
- Terraform plan files committed to Git.
- Secrets, private keys, client secrets, credentials, tokens, or certificates.
- Tenant IDs, subscription IDs, client IDs, object IDs, or real environment
  identifiers.
- Local developer overrides or developer-specific configuration.
- Mutable production module references.
- Undocumented cross-state dependencies.

## Accepted Toolchain And ADR Decisions

Accepted decisions that directly govern this repository:

- ADR 0001: Terraform is the authoritative Infrastructure as Code engine.
- ADR 0002: The platform uses separate architecture, modules, foundation, and
  connectivity repositories.
- ADR 0003: Terraform `1.15.8` is the approved execution version, AzureRM
  `4.81.0` is the initial release-validation and root lock version, and AzAPI
  is excluded until a real capability justifies it.
- ADR 0004: Remote state uses the native Terraform `azurerm` backend with
  Azure Blob Storage, Microsoft Entra authentication, and Azure RBAC.
- ADR 0005: The accepted hierarchy is `Platform`, `Landing Zones`, and
  `Decommissioned`, with `Platform` containing `Management`, `Identity`,
  `Connectivity`, and `Shared Services`.
- ADR 0006: Routine deployment automation uses repository-owned Microsoft
  Entra applications with GitHub OIDC and Microsoft Entra Workload Identity
  Federation. Human identities are for bootstrap, development,
  troubleshooting, controlled lab work, and emergency operations.

OpenTofu compatibility is not part of the supported contract.

## Root-Module Rules

When Terraform root deployments are introduced:

- Configure providers only in root modules.
- Configure backends only in root modules.
- Commit `.terraform.lock.hcl` for real root deployments.
- Use Terraform `1.15.8` for approved execution.
- Use deliberate AzureRM constraints aligned with the accepted baseline.
- Consume reusable modules through immutable tags or approved commit SHAs.
- Do not reference mutable branches such as `main` for production deployment.
- Keep environment values in this deployment repository, not in reusable
  modules.
- Do not copy reusable module logic into root deployments.

## State Guardrails

Terraform state must never be committed to Git.

Accepted state guardrails:

- Use the native Terraform `azurerm` backend with Azure Blob Storage.
- Use Microsoft Entra authentication.
- Use Azure RBAC authorization.
- Do not use storage account keys or SAS tokens for normal workflows.
- Keep state permissions separate from Azure deployment permissions.
- Start with coarse state boundaries only where the remote state ADR approves
  them.
- Document any state boundary split before implementing it.
- Avoid `terraform_remote_state` by default; document approved exceptions.
- Document recovery procedures before production readiness.

Bootstrap may begin with local state, but normal operations must not remain
dependent on local state after backend creation and migration.

## Identity Guardrails

Accepted identity guardrails:

- Human identities may be used for bootstrap, development, troubleshooting,
  controlled lab operations, and break-glass access.
- Human identities must not be embedded in automation.
- Routine CI/CD uses GitHub OIDC and Microsoft Entra Workload Identity
  Federation.
- This repository owns its deployment identity when implemented.
- Plan and apply credentials must use different trust conditions and role
  assignments where practical.
- Long-lived client secrets, certificates, and stored credentials are
  prohibited for normal CI/CD.
- Break-glass access is human only, documented, audited, and not used by
  CI/CD.

## Current Status

Status snapshot as of 2026-07-16:

- Repository scaffold is established.
- `platform/bootstrap` defines the first bootstrap composition slice.
- Current bootstrap module composition:
  - `resource-group-v0.1.0`
  - `storage-account-v0.1.1`
  - `storage-container-v0.1.0`
- No backend is configured.
- No Azure resources have been created by this repository.
- Bootstrap backend configuration and state migration remain deferred.

This status snapshot is contributor context, not a release certificate.

## Required AI Workflow

1. Read this guide.
2. Read relevant sibling ADRs and standards from
   `../azure-platform-architecture`.
3. Inspect the repository tree and Git status.
4. Confirm the requested change belongs in `azure-platform-foundation`.
5. Do not broaden scope.
6. Do not invent unresolved architecture decisions.
7. Do not add Terraform, backend files, workflows, Azure resources, or
   environment configuration unless explicitly requested and authorized by
   accepted ADRs and standards.
8. Report files changed, commands executed, results, blockers, and deferred
   work.
9. Never commit or push unless explicitly asked.
10. Never claim validation passed if a tool was unavailable or a command was
    not run.

## New-Session Starter

Copy this prompt into a fresh Codex session:

```text
Read docs/ai/assistant-guide.md first. Then read the relevant ADRs and
standards from ../azure-platform-architecture for the task. Inspect the
repository tree and Git status before making changes. Summarize the current
state, applicable authoritative decisions, unresolved decisions, and the next
recommended step. Do not modify files until the requested scope is clear.
```

## Review Checklist

- [ ] The assistant read this guide before acting.
- [ ] Relevant ADRs and standards were read.
- [ ] Repository tree and Git status were inspected.
- [ ] The change belongs in `azure-platform-foundation`.
- [ ] The change stayed within the requested scope.
- [ ] No prohibited content was added.
- [ ] No reusable module source was added.
- [ ] No connectivity implementation was added without a documented
      dependency.
- [ ] No Terraform state, plan files, credentials, secrets, or local overrides
      were added.
- [ ] No tenant IDs, subscription IDs, client IDs, object IDs, or real
      environment values were added.
- [ ] No architecture decision was invented.
- [ ] Validation commands were reported accurately.
- [ ] Blockers and deferred work were identified.
- [ ] No commit or push was performed unless explicitly requested.
