---
name: terraform-security-baseline-auditor
description: Trigger when the user asks to audit, harden, review, or validate any terraform/*.tf file that manages Microsoft Graph / Entra ID resources against Microsoft, NCSC, and Maester best practices, and wants a matching markdown guide created or updated next to that file.
compatibility: Requires terraform, tflint, azuread provider ~> 3.0, and msgraph provider ~> 0.4
---

# terraform-security-baseline-auditor

## When To Use
- The user asks to audit, review, or "check best practices" for any file under `terraform/`.
- The user asks to align a Terraform file's configuration with Microsoft, NCSC, or Maester guidance.
- The user asks for a markdown guide/README explaining a Terraform file's resources and the reasoning behind their settings.
- This skill is file-agnostic: it applies to whichever `terraform/<name>.tf` file the user points at, not a fixed file list.

## Inputs
- The target `.tf` file. If the user doesn't name one, use the active editor file or ask which file to audit.

## Workflow
1. **Read the target file fully.** Identify every `resource` block: its Terraform type, the Microsoft Graph (or other API) path it manages (`url` / equivalent), and every property currently set.
2. **Research best practice per resource**, using three source categories, in this order:
   - **Microsoft Learn** (`learn.microsoft.com`) — official guidance for that resource/feature area.
   - **NCSC guidance** (`ncsc.gov.uk`) — UK Government Zero Trust and Cyber Essentials alignment.
   - **Maester tests** (`maester.dev/docs/tests`) — real test IDs (`EIDSCA.*`, `CISA.*`, `MT.*`, `CIS.*`, `ORCA.*`) that assert this exact configuration. Search `references/eidsca-test-index.md` and `references/maester-test-index.md` first for candidate IDs by keyword, then fetch the individual test page (`https://maester.dev/docs/tests/<Test ID>`) to confirm it's still current before citing it.
   - **Never fabricate a test ID, article title, or URL.** Verify every citation with a live fetch before including it in code or documentation. If a claim can't be verified, say so instead of guessing.
   - **Never cite `/docs/next/tests/...` pages** (Maester's unreleased preview docs) in generated documentation — only cite the stable `/docs/tests/...` release path, even if you used `/next/` to check upcoming test coverage.
3. **Compare** the current `.tf` configuration against the researched best practice, resource by resource.
4. **Close gaps with the minimal Terraform change needed**, following the "Repository HCL Conventions" below. Don't refactor unrelated resources.
5. **Flag (don't silently apply) any change that alters live tenant behavior in a non-additive way** — for example disabling a currently enabled feature, narrowing an exclusion, or changing a target group. Ask the user before applying these; safe, additive hardening (adding attestation, shortening a lifetime, adding an `import` block) can be applied directly.
6. **Validate**: run `terraform fmt` and `terraform validate` after every edit.
7. **Create or update the companion markdown file** at the same path and base name as the `.tf` file (for example `terraform/foo.tf` → `terraform/foo.md`).

## Repository HCL Conventions
Apply these regardless of which file is being audited:
- Prefer a typed `azuread_*` resource when the AzureAD provider supports the resource and required properties. Use `msgraph_resource` only for Microsoft Graph APIs without an AzureAD equivalent. When changing an existing resource type, migrate Terraform state before applying.
- `msgraph_resource` `body` must be a plain HCL object literal — never wrap it in `jsonencode(...)`. The provider's `body` attribute is structured/dynamic, and Terraform still pretty-prints plan diffs without an explicit `jsonencode()` call.
- Every resource that targets a fixed, pre-existing API path (anything adopted rather than newly created) must have a matching `import` block directly beneath it:
  ```hcl
  import {
    to = <resource_type>.<resource_name>
    id = "<same value as the resource's url/path>"
  }
  ```
- Use `depends_on` only when a resource's body references another resource's `.id` or output.
- Keep one resource per logical entity; don't combine multiple entities into a single resource block.
- Never hardcode tenant IDs, client secrets, or credentials directly in `.tf` files — reference `variables.tf` or Key Vault, per the repository-wide rule in `.github/copilot-instructions.md`.

## Markdown Guide Requirements (`terraform/<name>.md`)
- A title describing the file's purpose, and a one-line summary of what the resources collectively manage.
- One `##` heading per resource, named after the Terraform resource name.
- A short bullet list per resource explaining non-obvious attribute values and, for any enabled/disabled or hardened choice, the **why**.
- A `## Resources` section at the end with three subsections — **Microsoft articles**, **Maester test files**, **NCSC articles** — citing only verified URLs gathered during the research step.
- Follow the GDS technical-writing conventions in `.github/skills/gds-tech-writer/SKILL.md` (active voice, jargon explained inline on first use, scannable headings, no fabricated jargon).

## Compliance & Test Mapping Reference
Two local, title-only indexes speed up discovery before you fetch anything:
- `references/eidsca-test-index.md` — all `EIDSCA.*` tests (ID, title, severity).
- `references/maester-test-index.md` — all core `MT.*` tests (ID, title, severity, category).

These indexes are for **keyword search only** — they can drift from upstream over time, so always fetch the
individual test page to confirm a test still exists and get its current description/remediation before citing it.
Refresh an index by re-fetching its stable listing page (linked at the top of each file) if a lookup that should
exist is missing, or periodically if the index looks old.

Maintain a running table of audited controls in `references/maester-ncsc-mapping.md`. When auditing a file:
- Check whether relevant rows already exist for the resource types involved.
- Add new rows for any newly verified Area/Control → Maester Test ID(s) → NCSC/Microsoft alignment → link, rather than creating a new mapping file per Terraform file.

## Validation Checklist For Agents
- Confirm every Microsoft/NCSC/Maester reference cited was verified via a live fetch during this session, not recalled from memory.
- Confirm no citation points at a `/docs/next/tests/...` (preview) Maester URL.
- Confirm `terraform fmt` and `terraform validate` both pass after any edit.
- Confirm a markdown guide exists at the same path/basename as the audited `.tf` file and reflects its current state.
- Confirm HCL conventions are followed (no `jsonencode`, `import` blocks present where needed, `depends_on` only where needed).
- Confirm no non-additive/breaking change was applied without asking the user first.
- Confirm `references/maester-ncsc-mapping.md` was updated with any newly verified controls.
