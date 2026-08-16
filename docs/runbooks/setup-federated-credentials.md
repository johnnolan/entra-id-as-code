# Set Up GitHub Federated Credentials in Entra Portal

Use this guide to configure Microsoft Entra ID and GitHub Actions for OIDC (OpenID Connect, a token-based federation protocol).  
You will create an app registration, add federated identity credentials, and assign the access Terraform needs.

## What this setup gives you

- Passwordless CI authentication from GitHub Actions to Entra ID.
- No long-lived client secret in GitHub.
- Scoped access for Terraform plan and apply workflows.

## Before you start

Collect these values first:

- Entra tenant ID.
- Azure subscription ID.
- GitHub owner and repository name.

Use this repository as an example:

- Owner: `johnnolan`
- Repository: `entra-id-as-code`

## Step 1: Create the app registration

1. Open Entra admin center.
2. Go to **Identity** > **Applications** > **App registrations**.
3. Select **New registration**.
4. Enter a name, for example `terraform-entra-id-as-code`.
5. Keep the default account type unless your tenant needs multi-tenant access.
6. Select **Register**.

Save these values from the app overview page:

- **Application (client) ID**.
- **Directory (tenant) ID**.

## Step 2: Create federated identity credentials

Add one credential for pull requests and one for main branch apply.  
This separation improves least privilege and troubleshooting.

1. Open your app registration.
2. Go to **Certificates & secrets** > **Federated credentials**.
3. Select **Add credential**.
4. Choose **GitHub Actions deploying Azure resources**.

### Credential A: pull request plan

Set these fields:

- Organization: `johnnolan`
- Repository: `entra-id-as-code`
- Entity type: **Pull request**
- Name: `github-pr-plan`

Expected subject identifier format:

- `repo:johnnolan/entra-id-as-code:pull_request`

### Credential B: merge to main apply

Set these fields:

- Organization: `johnnolan`
- Repository: `entra-id-as-code`
- Entity type: **Branch**
- GitHub branch name: `main`
- Name: `github-main-apply`

Expected subject identifier format:

- `repo:johnnolan/entra-id-as-code:ref:refs/heads/main`

### Verify issuer and audience

For both credentials, ensure these values are set:

- Issuer: `https://token.actions.githubusercontent.com`
- Audience: `api://AzureADTokenExchange`

## Step 3: Grant Microsoft Graph application permissions

The AzureAD provider calls Microsoft Graph (Entra directory API).  
Grant only the roles your Terraform resources require.

1. Open app registration.
2. Go to **API permissions**.
3. Select **Add a permission** > **Microsoft Graph** > **Application permissions**.
4. Add the required Graph roles for your managed resources.
5. Select **Grant admin consent**.

For this repository's current policy resources, common required roles include:

- `Policy.Read.All`
- `Policy.ReadWrite.ConditionalAccess`
- `EntitlementManagement.ReadWrite.All`

Add more roles as you add more Terraform resource types.

## Step 4: Grant Azure RBAC for remote state

Terraform backend uses Azure Blob state (state file stored in a storage account).  
Assign RBAC (role-based access control, authorization by role assignment) so the app can read and write state.

1. Open the storage account used for Terraform state.
2. Go to **Access control (IAM)** > **Add role assignment**.
3. Assign **Storage Blob Data Contributor**.
4. Scope the role to the storage account or state container.
5. Select the service principal for your app registration.

## Step 5: Configure GitHub repository secrets

In GitHub, go to **Settings** > **Secrets and variables** > **Actions**.  
Add the secrets used by this repository workflows.

- `ARM_CLIENT_ID`: Entra app client ID.
- `ARM_TENANT_ID`: Entra tenant ID.
- `ARM_SUBSCRIPTION_ID`: Azure subscription ID.
- `TFSTATE_RESOURCE_GROUP_NAME`: Resource group for state storage.
- `TFSTATE_STORAGE_ACCOUNT_NAME`: Storage account for state.
- `TFSTATE_CONTAINER_NAME`: Blob container for state.
- `TFSTATE_KEY`: Blob name for the state file.

## Step 6: Confirm workflow permissions

Your workflow must request the OIDC token.

Check that workflow files include:

```yaml
permissions:
	id-token: write
	contents: read
```

## Step 7: Validate end-to-end

1. Open a pull request that changes Terraform files.
2. Confirm the plan workflow completes successfully.
3. Merge the pull request to main.
4. Confirm the apply workflow completes successfully.

## Troubleshooting

### Error: AADSTS70021 or invalid issuer/subject

Cause: Federated credential values do not match the GitHub token claims.  
Fix: Recheck issuer, audience, and subject pattern in the Entra portal.

### Error: insufficient privileges to complete operation

Cause: Microsoft Graph application roles are missing or consent was not granted.  
Fix: Add required Graph application permissions and grant admin consent.

### Error: backend access denied

Cause: Missing Storage Blob Data Contributor RBAC assignment.  
Fix: Assign RBAC to the app service principal at the storage scope.

## Where to find your GitHub IDs

Organization ID: Open a new tab and go to [https://api.github.com/users/johnnolan](https://api.github.com/users/johnnolan) (use /orgs/johnnolan if it is explicitly set up as an organization rather than a user account). Look for the `"id":` field near the very top of the JSON output.

- User account ID: [https://api.github.com/users/johnnolan](https://api.github.com/users/johnnolan)
- Organization ID: [https://api.github.com/orgs/johnnolan](https://api.github.com/orgs/johnnolan)
- Repository ID: [https://api.github.com/repos/johnnolan/entra-id-as-code](https://api.github.com/repos/johnnolan/entra-id-as-code)