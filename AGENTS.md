# Work with this repository

This project supports evidence-based engineering and learning for Microsoft Entra ID managed through Terraform.
Help contributors understand significant choices, supporting evidence, and expected tenant impact. Scale explanations to the task.

## Start with relevant context

- Read [README.md](README.md) for architecture and [CONTRIBUTING.md](CONTRIBUTING.md) for validation and review expectations.
- Read the target file and its companion `.md` guide before changing behavior. Workflow guides sit beside their YAML files.
- Use the table below to read the relevant domain skill. Load its references only when needed for the task.
- Skills remain in `.github/skills/`. If your tool does not discover them automatically, open the linked `SKILL.md` directly.
- For an unmapped file, inspect related resources and guidance; do not invent a matching skill or assume the file is unmanaged.

## Follow the requested scope

- For questions and reviews, explain findings and recommendations. Edit files when implementation or remediation is requested.
- Make focused changes. Explain material assumptions, tradeoffs, permission changes, affected users, and rollout or rollback needs.
- Distinguish verified evidence from recommendations and unknowns. Verify external security claims against current primary sources.
- Update companion guides when behavior changes. Report checks performed, results, and anything that remains unverified.

## Preserve essential constraints

- Keep credentials and secret values out of source. Use inputs for tenant-specific identifiers; see [SECURITY.md](SECURITY.md).
- Prefer typed `azuread_*` resources when supported by the configured provider; use `msgraph_resource` for missing capabilities.
- Read [terraform/main.tf](terraform/main.tf) for current version constraints. Check provider schemas before copying examples.
- Preserve emergency-access exclusions and staged Conditional Access rollout rules in the domain skill.
- Preserve adoption/import intent. Resource-type changes need a reviewed state migration approach before deployment.
- Authorization to edit files does not authorize live apply, state mutation, permission grants, or deployment workflow dispatch.
- Assess operational impact even for additive hardening. Follow existing user authorization; ask only for missing decisions or authorization.

## Find domain guidance

| Terraform File | Skill |
|---|---|
| `terraform/conditional-access.tf` | [terraform-conditional-access-architect](.github/skills/terraform-conditional-access-architect/SKILL.md) |
| `terraform/group-settings.tf` | [terraform-group-settings-permissions](.github/skills/terraform-group-settings-permissions/SKILL.md) |
| `terraform/main.tf` | [terraform-main-permissions](.github/skills/terraform-main-permissions/SKILL.md) |
| `terraform/named-locations.tf` | [terraform-named-locations-permissions](.github/skills/terraform-named-locations-permissions/SKILL.md) |
| `terraform/outputs.tf` | [terraform-outputs-permissions](.github/skills/terraform-outputs-permissions/SKILL.md) |
| `terraform/policies.tf` | [terraform-policies-permissions](.github/skills/terraform-policies-permissions/SKILL.md) |
| `terraform/security-groups.tf` | [terraform-security-groups-permissions](.github/skills/terraform-security-groups-permissions/SKILL.md) |
| `terraform/service-principles.tf` | [terraform-service-principles-permissions](.github/skills/terraform-service-principles-permissions/SKILL.md) |
| `terraform/tenant.tf` | [terraform-tenant-permissions](.github/skills/terraform-tenant-permissions/SKILL.md) |
| `terraform/variables.tf` | [terraform-variables-permissions](.github/skills/terraform-variables-permissions/SKILL.md) |
| `terraform/access-packages.tf` | [terraform-access-packages-permissions](.github/skills/terraform-access-packages-permissions/SKILL.md) |
| `terraform/authentication-method-policies.tf` | [terraform-authentication-method-policies-permissions](.github/skills/terraform-authentication-method-policies-permissions/SKILL.md) |
| `terraform/cross-tenant-access.tf` | [terraform-cross-tenant-access-permissions](.github/skills/terraform-cross-tenant-access-permissions/SKILL.md) |


- For technical documentation, use [gds-tech-writer](.github/skills/gds-tech-writer/SKILL.md).
- For requested security audits or baseline alignment, use [terraform-security-baseline-auditor](.github/skills/terraform-security-baseline-auditor/SKILL.md).
- For requested blog writing, use [johnnolan-blog-writer](.github/skills/johnnolan-blog-writer/SKILL.md).
- For federation or state networking, read the [setup](docs/runbooks/setup-federated-credentials.md) or [network runbook](docs/runbooks/storage-account-network-hardening.md).

## Validate and maintain guidance

- Follow [local validation](CONTRIBUTING.md#local-validation-steps). Distinguish static checks, authenticated tenant plans, and deployment.
- For documentation-only edits, check links and consistency with code; Terraform execution is unnecessary.
- Treat workflow YAML and Terraform configuration as evidence of current behavior. Describe desired behavior separately.
- Keep shared rules and this routing table here; Copilot instructions link here. Keep domain detail in skills and rationale in companion guides.
- Domain rules refine these shared expectations. If guidance conflicts, surface the conflict and resolve it from code, evidence, and user intent.
- When adding or moving guidance, update links and routing. Verify discovery in each supported client; do not assume universal skill auto-loading.
