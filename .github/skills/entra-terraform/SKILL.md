---
name: entra-terraform
description: Create, review, or troubleshoot Microsoft Entra ID Terraform resources, provider selection, Graph permissions, and imports. Use for Entra identity infrastructure regardless of filenames; use the specialist skills for Conditional Access design or a requested security baseline audit. Do not trigger for unrelated Azure infrastructure.
---

# Manage Entra ID with Terraform

## Establish scope

Read repository instructions, the target configuration, and any companion guide. Discover resources by type and API path, not assumed filenames.
Determine whether the user wants an explanation, review, implementation, or permission diagnosis. Review requests produce findings without edits.
Explicit user instructions take precedence over skill defaults. Preserve existing authorization and ask only for missing decisions.

## Follow the workflow

1. Inspect Terraform constraints, the available lockfile, provider configuration, relevant resources, data sources, and imports.
2. Identify affected identities, properties, and dependencies. Separate current configuration from the requested outcome.
3. Read only the relevant references below. Verify current external claims against primary sources.
4. Prefer a typed `azuread_*` resource when the selected provider supports the required properties. Otherwise use `msgraph_resource`.
5. Trace permissions to actual read, write, lookup, and grant operations. Separate Terraform's identity from managed application permissions and state-storage access.
6. Preserve adoption intent. Prepare a migration approach before changing an existing resource type; do not treat a rename as a safe state migration.
7. Make focused edits when requested. Update companion documentation when behavior changes.
8. Follow repository validation requirements. Without local instructions, use formatting, backend-disabled initialization, validation, and configured lint checks in a clean workspace.

> **Authorization:** Repository edits do not authorize tenant changes, state mutation, consent grants, or deployment dispatch. A plan requires appropriate access and scope; distinguish it from static validation.

Keep credentials out of source. Use inputs or discovered identifiers for tenant-specific values. Preserve emergency-access protections and staged rollout rules.
Do not report a schema check as evidence that Graph accepts a payload or that tenant behavior is safe.

## Load relevant references

| Task | Read |
| --- | --- |
| Choose a provider, interpret versions, inspect schema | [Provider selection](references/provider-selection.md) |
| Diagnose authorization or recommend permissions | [Operation-level permissions](references/permissions.md) |
| Adopt an existing object or change resource types | [Imports and state](references/imports-and-state.md) |
| Configure authentication methods | [Authentication methods](references/authentication-methods.md) |
| Manage groups, lifecycle, settings, or access packages | [Groups and governance](references/groups-and-governance.md) |
| Configure collaboration and external trust | [Cross-tenant access](references/cross-tenant-access.md) |
| Manage applications or federated credentials | [Applications and federation](references/applications.md) |
| Configure organization details or tenant policies | [Tenant policies](references/tenant-policies.md) |

For Conditional Access policy design, use the bundled [entra-conditional-access](../entra-conditional-access/SKILL.md) skill.
For an explicitly requested security audit or baseline alignment, use [entra-security-audit](../entra-security-audit/SKILL.md).
Ordinary changes do not require a full audit. New Entra resource areas still follow this workflow; research their specific API and provider rather than inventing coverage.

## Deliver the result

Explain the finding or change, its evidence, affected users or workloads, and material permission, adoption, rollout, and rollback implications.
Report static checks, authenticated plans, and deployment separately. Name any unresolved assumptions or unavailable checks.
For permission diagnosis, identify the failing operation and the least-privileged supported option before recommending a grant.
