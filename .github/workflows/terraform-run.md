# terraform-run.yml

This is the reusable workflow called by all other Terraform workflows in this repository. It handles authentication, storage account firewall management, linting, formatting, initialisation, validation, plan, and optionally apply.

## Trigger

Called via `workflow_call` only. Not triggered directly.

## Inputs

| Input | Required | Default | Description |
|---|---|---|---|
| `command` | Yes | — | Terraform command to run: `plan` or `apply` |
| `plan_detailed_exitcode` | No | `false` | Emit exit code `2` when the plan contains changes (used by drift detection) |

## Outputs

| Output | Description |
|---|---|
| `plan_exit_code` | `0` for no changes, `2` for changes (only set when `plan_detailed_exitcode` is true) |
| `plan_output` | Last 250 lines of the plan output (only set when `plan_detailed_exitcode` is true) |
| `plan_summary` | Formatted plan summary markdown. Callers post this as a pull request comment or issue body themselves. |

## Steps

1. **Get runner public IP** — resolves the runner's egress IP via `checkip.amazonaws.com`.
2. **Azure login** — authenticates to Azure using OIDC federated credentials.
3. **Allow runner IP** — adds the runner IP to the Terraform state storage account firewall. Waits 10 seconds for propagation.
4. **Setup Terraform** and **TFLint**.
5. **tflint** — lints Terraform files.
6. **terraform fmt -check** — fails if any file is not formatted.
7. **terraform init** — initialises the `azurerm` backend with secrets passed as backend config.
8. **terraform validate** — validates configuration syntax and provider schema.
9. **terraform plan** — generates a plan and saves `plan.txt` and `plan.json` artifacts.
10. **Drift evaluation** *(plan only, when `plan_detailed_exitcode` is true)* — reads `plan.json` to determine whether changes exist and sets the `plan_exit_code` output.
11. **terraform apply** *(apply only)* — applies the plan with `-auto-approve`.
12. **Plan summary** — writes the plan output to the workflow step summary and exposes it via the `plan_summary` output for callers to post elsewhere (for example, as a pull request comment).
13. **Remove runner IP** (`if: always()`) — removes the runner IP from the storage account firewall regardless of job outcome.

## Secrets required

| Secret | Description |
|---|---|
| `ARM_CLIENT_ID` | Client ID of the CI app registration |
| `ARM_TENANT_ID` | Entra ID tenant ID |
| `ARM_SUBSCRIPTION_ID` | Azure subscription ID for backend access |
| `TFSTATE_RESOURCE_GROUP_NAME` | Resource group containing the state storage account |
| `TFSTATE_STORAGE_ACCOUNT_NAME` | Storage account name for Terraform state |
| `TFSTATE_CONTAINER_NAME` | Blob container name for Terraform state |
| `TFSTATE_KEY` | Blob name for the state file (defaults to `terraform.tfstate`) |

## Permissions required

| Permission | Reason |
|---|---|
| `id-token: write` | OIDC token exchange with Entra ID and Azure |
| `contents: read` | Checkout the repository |

This workflow does not write to pull requests or issues itself. Callers that need to post the `plan_summary` output as a comment, or raise an issue, must grant themselves the relevant permission (`pull-requests: write` or `issues: write`) on the job that consumes the output.
