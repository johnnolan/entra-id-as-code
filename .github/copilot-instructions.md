# Entra ID-as-Code Architecture Guardrails

This repository uses feature-specific Agent Skills to enforce security baselines, naming conventions, and Terraform best practices.

Before writing or editing code in this workspace, ALWAYS read and apply the matching domain skill from `.github/skills/`:

| Terraform File | Skill |
|---|---|
| `terraform/conditional-access.tf` | [terraform-conditional-access-architect](skills/terraform-conditional-access-architect/SKILL.md) |
| `terraform/main.tf` | [terraform-main-permissions](skills/terraform-main-permissions/SKILL.md) |
| `terraform/named-locations.tf` | [terraform-named-locations-permissions](skills/terraform-named-locations-permissions/SKILL.md) |
| `terraform/outputs.tf` | [terraform-outputs-permissions](skills/terraform-outputs-permissions/SKILL.md) |
| `terraform/policies.tf` | [terraform-policies-permissions](skills/terraform-policies-permissions/SKILL.md) |
| `terraform/security-groups.tf` | [terraform-security-groups-permissions](skills/terraform-security-groups-permissions/SKILL.md) |
| `terraform/tenant.tf` | [terraform-tenant-permissions](skills/terraform-tenant-permissions/SKILL.md) |
| `terraform/variables.tf` | [terraform-variables-permissions](skills/terraform-variables-permissions/SKILL.md) |
| `terraform/access-packages.tf` | *(no skill yet)* |
| `terraform/authentication-method-policies.tf` | *(no skill yet)* |
| `terraform/cross-tenant-access.tf` | *(no skill yet)* |

For technical documentation, apply the [gds-tech-writer](skills/gds-tech-writer/SKILL.md) skill.

For auditing any `terraform/*.tf` file against Microsoft, NCSC, and Maester best practices, and creating or updating its companion markdown guide, apply the [terraform-security-baseline-auditor](skills/terraform-security-baseline-auditor/SKILL.md) skill regardless of the file mapping above.

### Global Mandatory Rule
Never generate hardcoded tenant IDs, client secrets, or credentials directly in `.tf` files. Always reference inputs via `variables.tf` or Key Vault references.