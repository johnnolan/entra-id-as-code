# terraform-maester.yml

This workflow runs the [Maester](https://maester.dev) security test suite daily against the Entra ID tenant. Maester (a PowerShell-based security testing framework) validates that the tenant configuration meets Microsoft and CISA security baselines.

## Trigger

- Scheduled daily at `06:15 UTC` (`cron: "15 6 * * *"`)
- `workflow_dispatch` (manual trigger)

## What it does

1. Runs the `maester365/maester-action` with the tenant credentials supplied via secrets.
2. Executes the public Maester test suite against the tenant.
3. Writes a test result summary to the workflow step summary.
4. Uploads the Maester HTML report as a workflow artifact.

## Configuration

| Input | Value |
|---|---|
| `include_public_tests` | `true` — runs the Microsoft-published baseline checks |
| `include_private_tests` | `false` |
| `include_exchange` | `false` |
| `include_teams` | `false` |
| `maester_version` | `latest` |

## Permissions required

| Permission | Reason |
|---|---|
| `id-token: write` | OIDC authentication to Entra ID |
| `contents: read` | Checkout the repository |
| `checks: write` | Publish test results |

## Secrets used

| Secret | Description |
|---|---|
| `ARM_TENANT_ID` | Entra ID tenant ID |
| `ARM_CLIENT_ID` | Client ID of the Maester app registration created by `terraform/service-principles.tf` |
