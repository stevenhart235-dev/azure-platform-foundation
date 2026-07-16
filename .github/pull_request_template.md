## Purpose

<!-- Why is this change needed? -->

## Scope

<!-- What changed, and what is intentionally outside this pull request? -->

## Related Issue Or ADR

<!-- Link issue, ADR, roadmap item, or work item where applicable. -->

## Type Of Change

- [ ] Documentation
- [ ] Repository foundation
- [ ] Bootstrap design
- [ ] Foundation deployment
- [ ] Validation or tooling
- [ ] Bug fix
- [ ] Breaking change
- [ ] Maintenance

## Validation Performed

<!-- Include commands, checks, screenshots, or review evidence. -->

## Terraform Plan Summary

<!-- Required when Terraform roots exist and the change affects deployable infrastructure. Use N/A for documentation-only changes. -->

## State Or Migration Impact

<!-- Describe state boundary, backend, migration, or recovery impact. Use N/A when not applicable. -->

## Security Considerations

<!-- Note identity, RBAC, policy, network exposure, secrets, encryption, logging, diagnostics, or compliance impacts. -->

## Breaking-Change Declaration

- [ ] No breaking changes
- [ ] Breaking changes included

If breaking changes are included, describe the impact, migration guidance, and
rollback approach.

## Reviewer Checklist

- [ ] Change belongs in `azure-platform-foundation`.
- [ ] Architecture changes were made in `azure-platform-architecture` first where required.
- [ ] No reusable module source was added to this repository.
- [ ] No connectivity implementation was added without a documented dependency.
- [ ] No Terraform state, state backups, plan files, credentials, or local override files are committed.
- [ ] No tenant IDs, subscription IDs, client IDs, object IDs, or real environment values are committed.
- [ ] Provider and backend configuration are only in root modules where applicable.
- [ ] Dependency lock files are reviewed where applicable.
- [ ] Terraform plan summary is included where applicable.
- [ ] State, migration, rollback, and recovery impact are documented where applicable.
- [ ] Security review is included where required.
- [ ] Documentation is updated where contracts, behavior, ownership, or procedures changed.

