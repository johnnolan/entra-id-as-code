# terraform-apply-main.yml

This workflow runs `terraform apply` when changes merge to `main`. It applies approved infrastructure changes to the Entra ID tenant automatically.

## Trigger

- Push to `main` that modifies files under `terraform/**` or `.github/workflows/**/*.yml`
- `workflow_dispatch` (manual trigger)

## What it does

1. Calls the reusable [`terraform-run.yml`](terraform-run.yml) workflow with `command: apply`.
2. Adds the runner's current IP to the Terraform state storage account firewall.
3. Runs `tflint`, `terraform fmt -check`, `terraform init`, `terraform validate`, `terraform plan`, then `terraform apply -auto-approve`.
4. Removes the runner IP from the storage account firewall.

> **Note:** Apply runs automatically on merge. Ensure pull requests have a passing plan before merging to `main`.

## Permissions required

| Permission | Reason |
|---|---|
| `id-token: write` | OIDC authentication to Entra ID and Azure |
| `contents: read` | Checkout the repository |
| `pull-requests: write` | Required by the reusable workflow |
| `issues: write` | Required by the reusable workflow |

## Secrets used

See [`terraform-run.yml`](terraform-run.yml) for the full list of required secrets.
