# Harden Terraform state storage account network access

This runbook explains how to restrict network access on the Azure Storage Account (a cloud object storage service) that holds Terraform state, and how the GitHub Actions workflow dynamically manages IP allowlisting so the runner can still read and write state during each pipeline run.

## Understand the risk of leaving the storage account public

By default, Azure Storage Accounts accept connections from all public networks. The Terraform state file contains a full snapshot of your Entra ID configuration, including resource IDs and any sensitive output values.

> **Security requirement**
> An open storage account means anyone with valid credentials — or anyone who obtains them — can read or overwrite your Terraform state from any network.
> Overwriting state can cause Terraform to lose track of existing resources, leading to unintended destructive changes on the next `apply`.
> Restrict network access to reduce the blast radius of a compromised credential.

Locking down network access means that even a leaked `ARM_CLIENT_SECRET` or a stolen OIDC token cannot be used to access state from an arbitrary host.

---

## Step 1: Restrict the storage account firewall in Azure

Do this once, before or alongside deploying the workflow changes.

1. Open the [Azure portal](https://portal.azure.com) and navigate to your storage account.
2. Select **Settings** > **Networking**.
3. Under **Public network access**, select **Enabled from selected virtual networks and IP addresses**.
4. Leave the IP address list empty — the workflow populates it dynamically per run.
5. Under **Exceptions**, ensure **Allow Azure services on the trusted services list to access this storage account** is checked. This allows the `azurerm` Terraform backend to function correctly when called from within trusted Azure contexts.
6. Select **Save**.

> **Warning**
> Do not select **Disabled** for public network access. GitHub-hosted runners do not run inside your Azure Virtual Network (VNet), so a fully private endpoint would block all workflow runs unless you use a self-hosted runner in a VNet.

---

## Step 2: Grant the service principal permission to modify network rules

The workflow uses the existing OIDC federated identity to call `az storage account network-rule`. The service principal needs permission to write network rules on the storage account.

Assign one of the following roles, scoped to the storage account:

| Option | Role | Notes |
|---|---|---|
| Recommended | `Storage Account Contributor` | Includes network rule write; also grants broader storage management |
| Least privilege | Custom role with `Microsoft.Storage/storageAccounts/networkRuleSets/write` | Scoped to network rules only |

Assign via the Azure portal under **Storage account** > **Access control (IAM)** > **Add role assignment**, or use the Azure CLI:

```bash
az role assignment create \
  --assignee "<service-principal-object-id>" \
  --role "Storage Account Contributor" \
  --scope "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Storage/storageAccounts/<storage-account-name>"
```

---

## Step 3: Understand how the workflow manages the runner IP

The reusable workflow in [`.github/workflows/terraform-run.yml`](../../.github/workflows/terraform-run.yml) adds the runner's current egress IP to the storage account firewall at the start of each run and removes it at the end — even if the job fails.

### Add the runner IP

This step runs before `terraform init`. It resolves the runner's public IP, adds it to the allowlist, then waits 10 seconds for the firewall rule to propagate before Terraform attempts to connect.

```yaml
- name: Get runner public IP
  id: runner_ip
  run: echo "ip=$(curl -sf https://checkip.amazonaws.com)" >> "$GITHUB_OUTPUT"

- name: Azure login
  uses: azure/login@f5d393ae46f8fde4be8b75f32e3fc50e654ad0ca #v3.0.1
  with:
    client-id: ${{ secrets.ARM_CLIENT_ID }}
    tenant-id: ${{ secrets.ARM_TENANT_ID }}
    subscription-id: ${{ secrets.ARM_SUBSCRIPTION_ID }}

- name: Allow runner IP on state storage account
  run: |
    az storage account network-rule add \
      --resource-group "${{ secrets.TFSTATE_RESOURCE_GROUP_NAME }}" \
      --account-name "${{ secrets.TFSTATE_STORAGE_ACCOUNT_NAME }}" \
      --ip-address "${{ steps.runner_ip.outputs.ip }}"
    sleep 10
```

### Remove the runner IP

This step runs last with `if: always()`, so it executes regardless of whether earlier steps succeed or fail. It leaves the storage account firewall clean after every run.

```yaml
- name: Remove runner IP from state storage account
  if: always()
  run: |
    az storage account network-rule remove \
      --resource-group "${{ secrets.TFSTATE_RESOURCE_GROUP_NAME }}" \
      --account-name "${{ secrets.TFSTATE_STORAGE_ACCOUNT_NAME }}" \
      --ip-address "${{ steps.runner_ip.outputs.ip }}"
```

> **Note**
> GitHub-hosted runners receive a different public IP on each job. Rules added in one run are always removed at the end of that same run. No stale rules accumulate over time.

---

## Verify the configuration works

After completing Steps 1–3, trigger a workflow run manually via `workflow_dispatch` on any workflow that calls `terraform-run.yml`. Confirm:

- The **Allow runner IP** step completes without a `403` or `AuthorizationFailure` error.
- The **Terraform Init** step connects to the backend successfully.
- The **Remove runner IP** step runs and exits `0`, even if an earlier step failed.

If `terraform init` returns `AuthorizationFailure`, the firewall rule has not propagated. Increase the `sleep` value in the allow step from `10` to `30` seconds.

---

## Rollback

To revert to open access temporarily (for example, during debugging):

1. In the Azure portal, set **Public network access** back to **Enabled from all networks**.
2. Re-apply the restriction once debugging is complete.

Do not leave the storage account open beyond the debugging window.
