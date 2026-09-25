---
name: entra-conditional-access
description: Design, review, or change Microsoft Entra Conditional Access in Terraform, including targeting, authentication strengths, emergency-access exclusions, dependencies, and staged rollout. Use regardless of file names; ordinary Entra changes without Conditional Access impact use entra-terraform.
---

# Design Conditional Access safely

Read repository instructions, the target policies, companion documentation, related groups, locations, authentication strengths, and Security Defaults configuration.
Determine whether the task is review or implementation. Explicit user instructions take precedence over skill defaults; preserve existing authorization.

## Preserve safety constraints

> **Emergency access:** Preserve the existing emergency-access exclusions. Do not remove or narrow them without explicit authorization.

- New policies start in `enabledForReportingButNotEnforced` (report-only), where supported. Never create and enforce a new policy in the same pull request.
- Promote enforcement in a later reviewed change after sign-in impact validation and approval. Do not roll existing enabled policies back during an unrelated change.
- Preserve established baseline protections and keep Security Defaults disabled where the custom baseline is already in use.
- Preserve approved exclusions. Do not add broad user, group, application, or location exclusions without a scoped requirement and impact assessment.
- Keep repository-specific naming, dependencies, and resource references in local guidance. Discover those conventions before writing new policies.
- Editing Terraform does not authorize apply, state mutation, permission grants, or deployment dispatch.

## Review or implement

1. Identify policy intent, users or workload identities, target resources, client types, conditions, grant logic, and session controls.
2. Inspect the selected provider schema. Prefer `azuread_conditional_access_policy` when it supports every required field; use Graph for verified capability gaps.
3. Verify permission requirements for the resource and any lookups. An `applications` condition alone does not justify an additional `Application.Read.All` grant.
4. Check emergency-access coverage and interactions with existing policies, guest trust, locations, and authentication methods.
5. Read [rollout guidance](references/rollout.md) when creating, modifying enforcement, or assessing operational impact.
6. Read [examples](references/examples.md) when authoring HCL. Adapt them to actual resource references and provider version.
7. For implementation, update the companion guide and run repository static validation. Report any authorized tenant plan separately.

For import or provider-type changes, read the bundled [adoption guidance](../entra-terraform/references/imports-and-state.md).
For a requested audit, use [entra-security-audit](../entra-security-audit/SKILL.md) and its single [control mapping](../entra-security-audit/references/control-mapping.md).

## Report the result

Explain the policy logic, affected identities and applications, evidence, exclusions, rollout state, and rollback approach.
Report unresolved business decisions, unsupported report-only evaluation, missing sign-in evidence, and verification limits.
Reviews produce findings without edits. Do not claim policy compliance from a similar test name or from static HCL alone.
