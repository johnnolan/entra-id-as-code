# terraform-maester.yml

This workflow runs the [Maester](https://maester.dev) security test suite daily against the Entra ID tenant. Maester (a PowerShell-based security testing framework) validates that the tenant configuration meets Microsoft and CISA security baselines.

## Trigger

- Scheduled daily at `06:15 UTC` (`cron: "15 6 * * *"`)
- `workflow_dispatch` (manual trigger)

## What it does

1. Runs the `maester365/maester-action` with the tenant credentials supplied via secrets.
2. Executes the Maester test suite, scoped to Entra ID tests only using `include_tags` and `exclude_tags`.
3. Writes a test result summary to the workflow step summary.
4. Uploads the Maester HTML report as a workflow artifact.
5. Files a GitHub issue for each failed test.

## Configuration

| Input | Value |
|---|---|
| `include_public_tests` | `true` — runs the Microsoft-published baseline checks |
| `include_private_tests` | `false` |
| `include_exchange` | `false` |
| `include_teams` | `false` |
| `maester_version` | `latest` |
| `include_tags` | `Entra,CA,App,Privileged,Authentication,Governance,Group,General,Entra ID Free,Entra ID P1,Entra ID P2` |
| `exclude_tags` | `Exchange,EXO,Teams,Intune,Defender,Purview,Azure,Backup,XSPM,AIAgent,spo,exchange` |

### Scope the test run to Entra ID

The `include_tags` and `exclude_tags` inputs filter which Maester tests run. Maester tags each test with the Microsoft product area it checks (for example `CA` for Conditional Access, or `Intune` for device management).

- `include_tags` allows only tests tagged with an Entra ID area: Conditional Access (`CA`), app registrations (`App`), privileged role management (`Privileged`), authentication methods (`Authentication`), entitlement management (`Governance`), groups (`Group`), and the Entra ID Security Config Analyzer checks (`General`), plus the CISA Entra ID baseline license tiers (`Entra ID Free`, `Entra ID P1`, `Entra ID P2`).
- `exclude_tags` blocks tests for other Microsoft 365 products, even if they'd otherwise match an include tag, so Exchange Online, Teams, Intune, Defender, Purview, Azure, Backup, and AI agent tests never run.

> **Note:** Maester's tagging can't guarantee a perfectly pure Entra ID-only test set. Some CIS benchmark tests share a broad `CIS M365` tag across multiple products. This configuration excludes those to stay strictly within Entra ID scope.

## File issues for failed tests

The `File issues for failed tests` step reads the JSON results file at `steps.maester.outputs.results_json` and creates a GitHub issue for each failing test.

- The step only runs when `tests_failed` is non-zero, so a fully passing run creates no issues.
- Each issue gets the `maester` label. The workflow creates this label automatically if it doesn't already exist in the repository.
- The step checks open issues labelled `maester` before creating a new one, and skips any test that already has a matching open issue. This stops the daily schedule from creating duplicate issues for a test that's still failing.
- The issue body includes the test name, its Maester tags, the failure message (if Maester recorded one), and a link back to the workflow run that raised it.

> **Security note:** The step authenticates to the GitHub CLI using the workflow's own `github.token` (the default `GITHUB_TOKEN`), not a personal access token or repository secret.

## Permissions required

| Permission | Reason |
|---|---|
| `id-token: write` | OIDC authentication to Entra ID |
| `contents: read` | Checkout the repository |
| `checks: write` | Publish test results |
| `issues: write` | Create and search issues for failed tests |

## Secrets used

| Secret | Description |
|---|---|
| `ARM_TENANT_ID` | Entra ID tenant ID |
| `ARM_CLIENT_ID` | Client ID of the Maester app registration created by `terraform/service-principles.tf` |
