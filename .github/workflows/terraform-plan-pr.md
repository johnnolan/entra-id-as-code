# terraform-plan-pr.yml

This workflow runs `terraform plan` against pull requests targeting `main`. It posts the plan output as a pull request comment so reviewers can assess infrastructure changes before approving.

## Trigger

- Pull request to `main` that modifies files under `terraform/**` or `.github/workflows/**/*.yml`
- `workflow_dispatch` (manual trigger)

## What it does

1. Calls the reusable [`terraform-run.yml`](terraform-run.yml) workflow with `command: plan`.
2. Adds the runner's current IP to the Terraform state storage account firewall.
3. Runs `tflint`, `terraform fmt -check`, `terraform init`, `terraform validate`, and `terraform plan`.
4. Uploads the plan as a workflow artifact.
5. A separate `post-pr-comment` job posts the `plan_summary` output as a pull request comment, scoped to `pull_request` events only.
6. Removes the runner IP from the storage account firewall.

## Permissions required

| Permission | Reason | Scope |
|---|---|---|
| `id-token: write` | OIDC authentication to Entra ID and Azure | Workflow |
| `contents: read` | Checkout the repository | Workflow |
| `pull-requests: write` | Post the plan comment on the pull request | `post-pr-comment` job only |

## Secrets used

See [`terraform-run.yml`](terraform-run.yml) for the full list of required secrets.
