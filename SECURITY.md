# Security

## Reporting Security Issues

Do not create public issues for suspected vulnerabilities, exposed secrets, or
security-sensitive operational details.

Report security issues through the organization-approved private security
reporting process.

TODO: Replace this placeholder with the approved internal security reporting
channel when repository governance is configured.

## Prohibited Sensitive Content

Do not commit:

- Secrets, credentials, passwords, private keys, certificates, or tokens.
- Client secrets or long-lived deployment credentials.
- Terraform state or state backups.
- Terraform plan files.
- Real tenant IDs, subscription IDs, client IDs, or object IDs.
- Real Azure regions, CIDR ranges, resource names, or environment names.
- Local override files or developer-specific configuration.
- Provider caches, CLI configuration, or generated artifacts.
- Storage account keys or SAS tokens.

## Deployment Identity Guardrails

Long-lived deployment credentials are prohibited for normal workflows.

The accepted future automation model is GitHub OIDC with Microsoft Entra
Workload Identity Federation. Routine deployment automation must use
repository-owned identities with scoped Azure RBAC. Human identities are for
bootstrap, local development, troubleshooting, controlled lab operations, and
break-glass access.

Storage account keys are not part of normal Terraform state workflows.
Terraform state access must use Microsoft Entra authentication and Azure RBAC.

## Security Review

Security review is required for changes that affect:

- Identity or deployment federation.
- RBAC or privileged access.
- Azure Policy or governance controls.
- Terraform state access or backend configuration.
- Secrets handling.
- Encryption.
- Logging, diagnostics, monitoring, or auditability.
- Network exposure.
- Compliance posture.
- Break-glass procedures.

