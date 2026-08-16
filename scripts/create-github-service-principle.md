# Create the internal-entra-iac app registration

This script creates the `internal-entra-iac` application registration (app reg) and its service principal (the per-tenant identity object that represents the app) in Microsoft Entra ID (formerly Azure Active Directory).

Use this script to bootstrap the identity required by the entra-id-as-code Terraform pipeline before running `terraform apply` for the first time.

## Prerequisites

- PowerShell 7 or later
- The `Microsoft.Graph` PowerShell SDK (a set of modules wrapping the Microsoft Graph REST API):

  ```powershell
  Install-Module Microsoft.Graph -Scope CurrentUser
  ```

- An Entra ID account with the **Application Administrator** role or equivalent

## Run the script

```powershell
./create-github-service-principle.ps1
```

The script opens a browser prompt. Sign in with an account that has permission to create app registrations. It then creates the app reg and service principal and prints their IDs.

## What the script creates

| Resource | Display name | Sign-in audience |
|---|---|---|
| App registration | `internal-entra-iac` | `AzureADMyOrg` (single tenant) |
| Service principal | Linked to the app reg above | — |

### Microsoft Graph API permissions assigned

The following application roles (app-only permissions that act without a signed-in user) are assigned to the app reg against the Microsoft Graph API (`00000003-0000-0000-c000-000000000000`):

| Permission | Permission ID | Type |
|---|---|---|
| `User.Read` | `e1fe6dd8-ba31-4d61-89e7-88639da4683d` | Scope (delegated) |
| `Application.ReadWrite.All` | `1bfefb4e-e0b5-418b-a88f-73c46d2cc8e9` | Role (application) |
| `Directory.ReadWrite.All` | `19dbc75e-c2e2-444c-a770-ec69d8559fc7` | Role (application) |
| `Domain.ReadWrite.All` | `7e05723c-0bb0-42da-be95-ae9f08a6e53c` | Role (application) |
| `EntitlementManagement.ReadWrite.All` | `9acd699f-1e81-4958-b001-93b1d2506e19` | Role (application) |
| `Group.ReadWrite.All` | `62a82d76-70ea-41e2-9197-370581804d09` | Role (application) |
| `GroupSettings.ReadWrite.All` | `546168c3-1183-4281-9491-fafb24dea37e` | Role (application) |
| `Organization.ReadWrite.All` | `292d869f-3427-49a8-9dab-8c70152b74e9` | Role (application) |
| `Policy.Read.All` | `246dd0d5-5bd0-4def-940b-0421030a5b68` | Role (application) |
| `Policy.ReadWrite.AuthenticationFlows` | `25f85f3c-f66c-4205-8cd5-de92dd7f0cec` | Role (application) |
| `Policy.ReadWrite.Authorization` | `fb221be6-99f2-473f-bd32-01c6a0e9ca3b` | Role (application) |
| `Policy.ReadWrite.ConditionalAccess` | `01c0a623-fc9b-48e9-b794-0756f8e8f067` | Role (application) |
| `Policy.ReadWrite.ExternalIdentities` | `03cc4f92-788e-4ede-b93f-199424d144a5` | Role (application) |

## Grant admin consent

The script assigns the permissions but does not grant admin consent. You must grant consent manually.

> **Required:** Without admin consent, the service principal cannot call Microsoft Graph. Terraform apply will fail with a `403 Forbidden` response.

> **Important:** `EntitlementManagement.ReadWrite.All` allows the application to manage access packages and their catalog resources. Add it only because this repository manages the access package example in [terraform/access-packages.tf](../terraform/access-packages.tf).

1. Open the [Entra ID portal](https://entra.microsoft.com)
2. Go to **App registrations** > **internal-entra-iac** > **API permissions**
3. Select **Grant admin consent for \<your tenant\>**
4. Confirm when prompted

## Next steps

After granting admin consent, configure credentials for the service principal. The script does not create passwords or federated credentials. See [Set up federated credentials](../docs/github-setup/setup-federated-credentials.md) to configure keyless authentication for the GitHub Actions pipeline.
