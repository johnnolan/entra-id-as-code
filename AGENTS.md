# Work with this repository

This project supports evidence-based engineering and learning for Microsoft Entra ID managed through Terraform.
Help contributors understand significant choices, supporting evidence, and expected tenant impact. Scale explanations to the task.

## Start with relevant context

- Read [README.md](README.md) for architecture and [CONTRIBUTING.md](CONTRIBUTING.md) for validation and review expectations.
- Read the target file and its companion `.md` guide before changing behavior. Workflow guides sit beside their YAML files.
- Use the table below to read the relevant domain skill. Load its references only when needed for the task.
- Canonical skills live in `.github/skills/`; `.agents/skills` links there for Codex discovery. If automatic discovery fails, open the linked `SKILL.md` directly.
- For local names, dependencies, and observed provider versions, read [Entra repository conventions](docs/agent-guidance/entra-repository.md).
- Historical skills under `docs/skill-backups/` are reference material, not active instructions.
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

| Task or Terraform area | Skill and relevant reference |
|---|---|
| Conditional Access, including related exclusions and location changes | [entra-conditional-access](.github/skills/entra-conditional-access/SKILL.md) and [local conventions](docs/agent-guidance/entra-repository.md) |
| Providers, backend, variables, outputs, or an unmapped Entra resource | [entra-terraform](.github/skills/entra-terraform/SKILL.md) |
| Group settings, security groups, access packages | [entra-terraform](.github/skills/entra-terraform/SKILL.md), then [groups and governance](.github/skills/entra-terraform/references/groups-and-governance.md) |
| Authentication method policies | [entra-terraform](.github/skills/entra-terraform/SKILL.md), then [authentication methods](.github/skills/entra-terraform/references/authentication-methods.md) |
| Cross-tenant access | [entra-terraform](.github/skills/entra-terraform/SKILL.md), then [cross-tenant access](.github/skills/entra-terraform/references/cross-tenant-access.md) |
| Applications and service principals | [entra-terraform](.github/skills/entra-terraform/SKILL.md), then [applications](.github/skills/entra-terraform/references/applications.md) |
| Tenant details, policies, authentication strengths | [entra-terraform](.github/skills/entra-terraform/SKILL.md), then [tenant policies](.github/skills/entra-terraform/references/tenant-policies.md) |
| Permission diagnosis, including named locations | [entra-terraform](.github/skills/entra-terraform/SKILL.md), then [permissions](.github/skills/entra-terraform/references/permissions.md) |
| Requested security audit, baseline alignment, or evidence-backed resource guide | [entra-security-audit](.github/skills/entra-security-audit/SKILL.md) |

Route by the requested workflow and actual resources, not filename alone. Load only references relevant to the task.

- For technical documentation, use [gds-tech-writer](.github/skills/gds-tech-writer/SKILL.md).
- For requested blog writing, use [johnnolan-blog-writer](.github/skills/johnnolan-blog-writer/SKILL.md).
- For federation or state networking, read the [setup](docs/runbooks/setup-federated-credentials.md) or [network runbook](docs/runbooks/storage-account-network-hardening.md).

## Validate and maintain guidance

- Follow [local validation](CONTRIBUTING.md#local-validation-steps). Distinguish static checks, authenticated tenant plans, and deployment.
- For documentation-only edits, check links and consistency with code; Terraform execution is unnecessary.
- Treat workflow YAML and Terraform configuration as evidence of current behavior. Describe desired behavior separately.
- Keep shared rules and this routing table here; Copilot instructions link here. Keep domain detail in skills and rationale in companion guides.
- Domain rules refine these shared expectations. If guidance conflicts, surface the conflict and resolve it from code, evidence, and user intent.
- When adding or moving guidance, update links and routing. Verify discovery in each supported client; do not assume universal skill auto-loading.
