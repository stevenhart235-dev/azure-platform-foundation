# Contributing

Thank you for contributing to `azure-platform-foundation`.

This repository owns Azure platform foundation deployment concerns only.
Changes must follow the authoritative ADRs and standards in
`../azure-platform-architecture`.

## Contribution Expectations

- Use short-lived feature branches.
- Open pull requests into protected `main`.
- Do not commit directly to `main`.
- Keep each pull request focused on one coherent change.
- Link the related issue, ADR, roadmap item, or work item where applicable.
- Include validation evidence for the change.
- Include Terraform plan summaries when Terraform roots exist and the change
  affects deployable infrastructure.
- Identify state, migration, security, and rollback impact where applicable.

## Repository Boundary

Allowed future content:

- Foundation root deployments.
- Foundation environment configuration.
- Foundation provider and backend configuration in root modules.
- Foundation state boundary documentation.
- Bootstrap documentation and implementation when deliberately defined.
- Deployment runbooks and operational notes.

Do not add:

- Reusable child module logic that belongs in `azure-platform-modules`.
- Enterprise connectivity implementation that belongs in
  `azure-platform-connectivity`.
- Terraform state or state backups.
- Terraform plan files committed to Git.
- Secrets, credentials, private keys, tokens, or client secrets.
- Tenant IDs, subscription IDs, client IDs, object IDs, or real environment
  identifiers.
- Local override files or developer-specific configuration.

Reusable logic must not be copied into this repository when it belongs in
`azure-platform-modules`. Deployment roots must consume reusable modules through
immutable references when implementation begins.

## Architecture Changes

Architecture changes must be made in `azure-platform-architecture` first.

If a proposed implementation requires a new decision about repository
boundaries, state ownership, deployment identity, management group structure,
policy rollout, provider strategy, naming, tagging, or cross-repository
contracts, stop and update the appropriate ADR or standard before implementing
the pattern here.

## Validation

For this initial scaffold, review is documentation-only.

Future foundation deployment changes must include validation evidence
appropriate to the change, such as:

- Terraform formatting.
- Terraform initialization and validation.
- Linting.
- Security scanning.
- Terraform plan summary.
- State or migration impact review.
- Documentation review.

Never claim a command passed unless it actually ran.

## Reviews

Pull requests must be approved by the responsible role-based owners. Security
review is required for changes that affect identity, RBAC, policy, network
exposure, secrets, encryption, logging, diagnostics, compliance posture,
deployment identities, state access, or break-glass procedures.

CODEOWNERS currently uses placeholder teams. Replace them with real GitHub
teams when repository governance is configured.

