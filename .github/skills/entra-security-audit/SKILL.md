---
name: entra-security-audit
description: Audit Microsoft Entra Terraform against requested Microsoft, NCSC, CISA, or Maester baselines, or produce evidence-backed remediation and resource guides. Use for explicit security reviews and baseline alignment; ordinary Terraform edits do not require a full audit.
---

# Audit Entra configuration with evidence

## Establish the requested outcome

Read repository instructions, the requested configuration, and companion guides. Discover relevant resources regardless of filenames.
Use the user's stated scope; ask only if the audit target or required baseline cannot be determined.
Explicit user instructions take precedence over skill defaults.

- **Review:** report findings, evidence, operational impact, and recommendations without editing configuration, guides, or reference indexes.
- **Remediation:** make requested repository changes; preserve authorization and identify decisions that remain unresolved.
- **Guide:** document current behavior and supporting rationale. Describe gaps separately without changing Terraform.

## Gather and assess evidence

1. Inventory actual resource types, Graph endpoints, API versions, configured properties, dependencies, and imports.
2. Verify current Microsoft guidance for the feature. Consult the requested NCSC or other benchmark where it applies; do not force unrelated mappings.
3. For Maester coverage, search [the EIDSCA index](references/eidsca-test-index.md) or [the MT index](references/maester-test-index.md) for candidates only.
4. Open each relevant stable `https://maester.dev/docs/tests/<ID>/` page and inspect the assertion or source where needed. Never invent IDs, titles, quotations, or URLs.
5. Consult [the control mapping](references/control-mapping.md) for known distinctions. Reverify each claim used in the result; stored dates do not replace current evidence.
6. Compare configured behavior, stated intent, and the requested baseline. Distinguish direct test coverage, contextual guidance, inference, and unavailable evidence.
7. Assess affected identities, recovery, enrollment, partner access, lifecycle, state adoption, permissions, rollout, and rollback before proposing remediation.

Use stable Maester pages in results, not `/docs/next/tests/` preview pages.
If network access or source content is unavailable, state which conclusions remain unverified and continue useful local analysis.
Do not equate a passing test or a broad NCSC principle with complete compliance.

## Remediate within scope

Use [entra-terraform](../entra-terraform/SKILL.md) for provider, permission, and adoption procedures.
Use [entra-conditional-access](../entra-conditional-access/SKILL.md) for policy changes and staged rollout.
Preserve emergency-access exclusions, existing adoption intent, and approved operational decisions.
Additive hardening can still disrupt users. Prepare a concrete change before asking for any missing decision.

> **Authorization:** Editing files does not authorize live apply, state mutation, permission grants, or deployment dispatch. Follow existing user authorization for live operations.

Follow local validation requirements. Report static checks, authenticated plans, deployment, and tenant tests separately.
Do not wrap the entire Graph body in `jsonencode`; nested properties requiring JSON strings are different.
Do not assume an import ID equals a resource's collection URL or that every resource is a singleton.

## Deliver findings or guides

For each material finding, give the affected resource, observed behavior, verified source, practical impact, and recommended action.
Separate missing evidence from demonstrated defects. Explain any permission or state migration implications.

For requested guides, describe each resource and explain non-obvious settings, current deviations, and operational effects.
Use clear headings, active language, and explanations of unfamiliar terminology. Follow local writing conventions when present.
Include relevant verified sources; do not add empty or unrelated benchmark sections solely to match a template.

Update the single control mapping only when the requested remediation or guide work introduces newly verified mappings.
Keep cached indexes as discovery aids; do not refresh them during review-only work or imply all entries were reverified.
