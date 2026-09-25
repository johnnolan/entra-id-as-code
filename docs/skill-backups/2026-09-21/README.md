# Terraform skill backup — 21 September 2026

This archive preserves all 14 previous Terraform skills and their supporting references for future expansion.
It is historical material, not active agent guidance.

- `original/` preserves the exact original file contents. [SHA-256 hashes](original-sha256.json) record the snapshot.
- `corrected/` preserves the old organization after the initial content corrections, before consolidation.
- Entrypoints are named `SKILL.reference.md` so discovery tools do not treat them as active skills.
- Original relative links retain their original `.github/skills/<name>/` context. They are not rewritten, to preserve the snapshot.
- Corrected-snapshot links to repository files are rebased to their archived location.
- The corrected snapshot still uses the old layout and is not maintained as a second skill collection. Consult the active references before reusing it.

## Find the replacement

| Previous skill area | Active guidance |
| --- | --- |
| Main, variables, outputs | [Entra Terraform](../../../.github/skills/entra-terraform/SKILL.md) |
| Permissions across domains | [Permission workflow and evidence](../../../.github/skills/entra-terraform/references/permissions.md) |
| Group settings, security groups, access packages | [Groups and governance](../../../.github/skills/entra-terraform/references/groups-and-governance.md) |
| Authentication methods | [Authentication methods](../../../.github/skills/entra-terraform/references/authentication-methods.md) |
| Service principals and applications | [Applications and federation](../../../.github/skills/entra-terraform/references/applications.md) |
| Tenant details and policies | [Tenant policies](../../../.github/skills/entra-terraform/references/tenant-policies.md) |
| Cross-tenant access | [Cross-tenant access](../../../.github/skills/entra-terraform/references/cross-tenant-access.md) |
| Conditional Access and named-location impact | [Conditional Access](../../../.github/skills/entra-conditional-access/SKILL.md) |
| Security baseline auditor | [Security audit](../../../.github/skills/entra-security-audit/SKILL.md) |

## Understand the corrections

The initial correction pass updated provider metadata and resource inventories, removed unsupported blanket permission requirements, and aligned authentication-strength references with code.
It also removed the duplicate Conditional Access mapping and corrected import guidance, including the distinction between collection URLs and object identifiers.

Consolidation replaced instance inventories with resource discovery, introduced operation-level permission evidence, and established one actively maintained control mapping.
Repository-specific conventions remain in [the local Entra guidance](../../agent-guidance/entra-repository.md).

To expand a domain, start from its active reference and consult the backup for historical context.
Create a separate skill only when the domain has a distinct trigger, workflow, or success criterion. Reverify permissions, schemas, and external evidence.
