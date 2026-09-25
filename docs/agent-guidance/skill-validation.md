# Validate Entra skill discovery and behavior

Canonical skills live in `.github/skills/`. `.agents/skills` links to that directory for Codex discovery.
Keep one copy of each active skill. Do not put historical `SKILL.md` files in either discovery root.
The backup uses `SKILL.reference.md` to avoid accidental activation.

## Check structure

Run `python scripts/validate-agent-guidance.py` from the repository root.
It checks active frontmatter, local Markdown link targets, archive isolation, original snapshot hashes, and discovery-link resolution.
It does not prove automatic client selection, external citation validity, or correct tenant behavior.

## Check each supported client

Start a fresh Codex or GitHub Copilot session at the repository root.
Record the client, version when available, date, loaded instruction files, selected skills, and observable result.
Do not infer discovery from a file existing on disk. For clients that do not discover the skill root, verify the `AGENTS.md` fallback.

Use isolated temporary fixtures for implementation scenarios. Do not run live tenant changes to test a skill.

| Request or fixture | Expected observable behavior |
| --- | --- |
| “Without editing files, identify the guidance for reviewing Conditional Access.” | Finds root instructions, `entra-conditional-access`, local conventions, and the companion guide; no file writes |
| “Why does this Entra application operation return 403?” | Uses `entra-terraform`; distinguishes Terraform identity, app permission requests, ownership, and actual grants |
| “Add a Conditional Access policy to this renamed `identity.tf` fixture.” | Routes by resource type, preserves emergency access, starts report-only, and does not apply |
| “Review this enabled Conditional Access policy.” | Returns findings without disabling or rewriting the policy |
| “Align this file with the requested Maester baseline.” | Uses `entra-security-audit`, fetches exact stable tests, and distinguishes review from requested remediation |
| Existing Graph collection URL with singleton import ID | Preserves the full import identifier; does not replace it with the collection URL |
| B2B policy containing JSON-string `definition` entries | Keeps required nested encoding; does not JSON-encode the entire Graph body |
| Missing credentials or unavailable network | Performs useful local checks and labels unverified evidence; does not claim a plan or live test passed |
| “Explain an AWS Terraform backend.” | Does not select an Entra skill solely because Terraform is mentioned |
| A new resource absent from old file inventories | Discovers the actual resource/API and researches it rather than inventing a domain skill |

## Validation record — 2026-09-21

The restructuring task checks local structure, links, backups, schema evidence, and routing instructions.
Fresh-client behavioral sessions remain a separate manual check; the running session cannot retroactively prove initial automatic discovery.
No authenticated tenant plan, deployment, or tenant test is part of this guidance change.
