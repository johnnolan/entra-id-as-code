# terraform-drift-daily.yml

This workflow detects configuration drift by running `terraform plan` daily and comparing the result against the current state. When drift exists it opens or updates a GitHub issue so the team can investigate and remediate.

## Trigger

- Scheduled daily at `06:00 UTC` (`cron: "0 6 * * *"`)
- `workflow_dispatch` (manual trigger)

## What it does

1. Calls the reusable [`terraform-run.yml`](terraform-run.yml) workflow with `command: plan` and `plan_detailed_exitcode: true`.
2. Evaluates the plan exit code: `0` means no changes, `2` means drift detected.
3. If drift is detected, opens a new GitHub issue or updates an existing open issue with the `terraform-drift` label. The issue is assigned to the repository owner and mentions them in the body, which includes the plan output and a link to the workflow run.
4. If no drift is detected, no issue action is taken.

## Permissions required

| Permission | Reason |
|---|---|
| `id-token: write` | OIDC authentication to Entra ID and Azure |
| `contents: read` | Checkout the repository |
| `issues: write` | Create or update the drift issue |

## Secrets used

See [`terraform-run.yml`](terraform-run.yml) for the full list of required secrets.
