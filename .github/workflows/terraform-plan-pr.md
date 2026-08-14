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
5. Posts a summary of the plan as a pull request comment.
6. Removes the runner IP from the storage account firewall.

## Permissions required

| Permission | Reason |
|---|---|
| `id-token: write` | OIDC authentication to Entra ID and Azure |
| `contents: read` | Checkout the repository |
| `pull-requests: write` | Post the plan comment on the pull request |
| `issues: write` | Required by the reusable workflow |

## Secrets used

See [`terraform-run.yml`](terraform-run.yml) for the full list of required secrets.
