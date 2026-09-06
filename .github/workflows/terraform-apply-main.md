# terraform-apply-main.yml

This workflow runs `terraform apply` when changes merge to `main`. It applies approved infrastructure changes to the Entra ID tenant automatically.

## Trigger

- Push to `main`
- `workflow_dispatch` (manual trigger)

## What it does

1. Calls the reusable [`terraform-run.yml`](terraform-run.yml) workflow with `command: apply` and `environment_name: production`, which gates the run behind the `production` environment's required reviewers.
2. Adds the runner's current IP to the Terraform state storage account firewall.
3. Runs `tflint`, `terraform fmt -check`, `terraform init`, `terraform validate`, `terraform plan -out=tfplan`, then `terraform apply tfplan` so the applied change matches the reviewed plan.
4. Removes the runner IP from the storage account firewall.

> **Note:** The `production` environment must have required reviewers configured in repository settings so a human approves the run before `terraform apply` executes. Ensure pull requests have a passing plan before merging to `main`.

## Permissions required

| Permission | Reason |
|---|---|
| `id-token: write` | OIDC authentication to Entra ID and Azure |
| `contents: read` | Checkout the repository |

## Secrets used

See [`terraform-run.yml`](terraform-run.yml) for the full list of required secrets.
