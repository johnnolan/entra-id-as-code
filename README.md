# Entra ID as Code with Terraform

This repository manages Microsoft Entra ID by using Terraform (an infrastructure as code tool). It uses the official `azuread` provider by default and the `msgraph` provider only for Microsoft Graph APIs that AzureAD does not yet support.

GitHub Actions runs plan, apply, drift detection, and Maester checks. Authentication uses OpenID Connect (OIDC, token-based federated authentication) instead of long-lived client secrets.

## Use this repository to

- Define tenant controls in Terraform.
- Review infrastructure changes in pull requests.
- Deploy through the `production` environment on pushes to `main` or manual dispatch.
- Detect configuration drift on a daily schedule.
- Run Maester security tests on a daily schedule.

## Understand the architecture

- Terraform state is stored in Azure Blob Storage by using the `azurerm` backend.
- GitHub Actions authenticates to Entra by using federated credentials.
- The reusable workflow in `.github/workflows/terraform-run.yml` runs `tflint`, `terraform fmt`, `terraform init`, `terraform validate`, and `terraform plan` or `terraform apply`.
- Daily drift detection reuses the same Terraform workflow and opens or updates a GitHub issue when drift exists.
- Terraform creates a dedicated Entra application for Maester and assigns its Microsoft Graph permissions in `terraform/service-principles.tf`.

> **Security requirement**
> Grant least-privilege Microsoft Graph application permissions to the CI application registration.
> Grant admin consent after permission changes.
> Scope Azure RBAC (role-based access control) for remote state as tightly as possible.

## See what Terraform manages now

Terraform currently manages these Entra resources:

- Tenant organization details in `terraform/tenant.tf`.
- Authentication flow policy in `terraform/policies.tf`.
- Authorization policy in `terraform/policies.tf`.
- External identities policy in `terraform/policies.tf`.
- Security defaults policy in `terraform/policies.tf`.
- Authentication strength policy in `terraform/policies.tf`.
- Named locations for Conditional Access in `terraform/named-locations.tf`.
- Conditional Access baseline policies in `terraform/conditional-access.tf`.
- Group lifecycle policy in `terraform/security-groups.tf`.
- Group settings in `terraform/security-groups.tf`.
- Conditional Access exclusion group in `terraform/security-groups.tf`.
- A Maester application registration and federated identity credential in `terraform/service-principles.tf`.

Some tenant objects are singletons. Terraform uses import blocks for some singleton resources so it can adopt existing tenant objects safely.

### Choose a provider

Use a typed `azuread_*` resource when the AzureAD provider supports the Entra object and required properties. Use `msgraph_resource` only when no AzureAD equivalent exists.

The Conditional Access policies, named location, and security groups use AzureAD typed resources. Microsoft Graph continues to manage authentication method policies, tenant-wide policy endpoints, group lifecycle and group settings, cross-tenant access, tenant organization settings, and the Continuous Access Evaluation policy because AzureAD does not expose those APIs or fields.

## Explore additional resource areas

Access packages, authentication method policies, and cross-tenant access have implemented resources and dedicated domain skills.
Use [AGENTS.md](AGENTS.md#find-domain-guidance) to find their guides and permission context.

## Review the repository structure

### Terraform

- `terraform/main.tf`: Terraform version, backend, and provider definitions.
- `terraform/variables.tf`: Root input variables for `tenant_id` and `client_id`.
- `terraform/outputs.tf`: Output file. It is currently empty.
- `terraform/tenant.tf`: Tenant organization resource definitions.
- `terraform/policies.tf`: Core policy resources.
- `terraform/named-locations.tf`: Named location resources for Conditional Access.
- `terraform/conditional-access.tf`: Conditional Access baseline policies.
- `terraform/security-groups.tf`: Group lifecycle, group settings, and exclusion group resources.
- `terraform/service-principles.tf`: Maester application registration and federated credential.

### Scripts

- `scripts/create-github-service-principle.ps1`: Script to bootstrap the `internal-entra-iac` app registration and service principal.
- `scripts/create-github-service-principle.md`: Usage guide for the bootstrap script.

### Documentation

- `terraform/security-groups.md`: Import and discovery guide for group settings and lifecycle objects.
- `docs/runbooks/setup-federated-credentials.md`: Entra and GitHub OIDC setup guide.
- `docs/runbooks/storage-account-network-hardening.md`: Runbook for restricting Terraform state storage account network access and configuring dynamic runner IP allowlisting.

### GitHub Actions workflows

- `.github/workflows/terraform-plan-pr.yml`: Pull request plan trigger. See [terraform-plan-pr.md](.github/workflows/terraform-plan-pr.md).
- `.github/workflows/terraform-apply-main.yml`: Main branch apply trigger. See [terraform-apply-main.md](.github/workflows/terraform-apply-main.md).
- `.github/workflows/terraform-drift-daily.yml`: Scheduled drift detection workflow. See [terraform-drift-daily.md](.github/workflows/terraform-drift-daily.md).
- `.github/workflows/terraform-maester.yml`: Scheduled Maester test workflow. See [terraform-maester.md](.github/workflows/terraform-maester.md).
- `.github/workflows/terraform-run.yml`: Reusable Terraform workflow called by all other workflows. See [terraform-run.md](.github/workflows/terraform-run.md).

## Understand the workflows

### Pull request validation

Workflow: `.github/workflows/terraform-plan-pr.yml`.

Pull requests to `main` call the reusable workflow with `command: plan` and inherited secrets. It uses OIDC and backend access, runs static checks, and creates a live tenant plan. The workflow also temporarily changes the state storage firewall. Require the successful plan job before merging; this is not credential-free validation.

### Apply through the production environment

Workflow: `.github/workflows/terraform-apply-main.yml`.

Pushes to `main` and manual dispatches start the apply workflow using the `production` environment.
Configure required reviewers and deployment branch restrictions in GitHub; the YAML alone does not establish these protections.
After any environment approval, the job generates and applies its own saved plan. This is a new plan, not the PR plan artifact.
There is no `TERRAFORM_APPLY_ENABLED` switch in the current workflow.
See [deployment setup](docs/runbooks/setup-federated-credentials.md) for federation and environment configuration.

### Daily drift detection

Workflow: `.github/workflows/terraform-drift-daily.yml`

- Trigger: daily at `0 6 * * *` and `workflow_dispatch`.
- Behavior: runs Terraform plan in detailed exit code mode.
- Drift handling: opens or updates a GitHub issue with the `terraform-drift` label when drift exists.

### Daily Maester tests

Workflow: `.github/workflows/terraform-maester.yml`

- Trigger: daily at `15 6 * * *` and `workflow_dispatch`.
- Behavior: runs `maester365/maester-action` against the tenant.
- Output: writes test counts and uploads the Maester HTML artifact through the action.

## Configure required GitHub secrets

The current callers inherit secrets. Plan runs do not select an environment; apply selects `production` and can use its environment secrets. Configure the values using [the deployment setup](docs/runbooks/setup-federated-credentials.md):

- `ARM_CLIENT_ID`: Entra application client ID.
- `ARM_TENANT_ID`: Entra tenant ID.
- `ARM_SUBSCRIPTION_ID`: Azure subscription ID for backend access.
- `TFSTATE_RESOURCE_GROUP_NAME`: Resource group that hosts the Terraform state storage account.
- `TFSTATE_STORAGE_ACCOUNT_NAME`: Storage account that stores Terraform state.
- `TFSTATE_CONTAINER_NAME`: Blob container for Terraform state.
- `TFSTATE_KEY`: Blob name for the Terraform state file.

## Grant Microsoft Graph permissions for Terraform CI

The exact permission set depends on the Terraform resources you manage. For this repository, the current implementation covers policies, groups, directory objects, organization settings, and application-aware Conditional Access conditions.

Use the repository skill files in `.github/skills` to verify the exact permission set before you run `apply`.

Common Microsoft Graph application permissions for the current Terraform implementation include:

- `Policy.Read.All`
- `Policy.ReadWrite.ConditionalAccess`
- `Policy.ReadWrite.AuthenticationFlows`
- `Policy.ReadWrite.Authorization`
- `Policy.ReadWrite.B2BManagementPolicy`
- `Policy.ReadWrite.ExternalIdentities`
- `Policy.ReadWrite.SecurityDefaults`
- `Policy.ReadWrite.AuthenticationMethod`
- `Policy.ReadWrite.CrossTenantAccess`
- `Directory.ReadWrite.All`
- `EntitlementManagement.ReadWrite.All`
- `Group.ReadWrite.All`
- `GroupSettings.ReadWrite.All`
- `Organization.ReadWrite.All`
- `Application.Read.All`

> **Warning**
> Conditional Access policies that use an `applications` condition require `Application.Read.All`.
> Review the file-specific permission skill before you merge changes.

## Understand the Maester application permissions

Terraform creates the Maester application registration in `terraform/service-principles.tf`. That application requests these Microsoft Graph permissions today:

- `User.Read.All`
- `AuditLog.Read.All`
- `DeviceManagementConfiguration.Read.All`
- `DeviceManagementManagedDevices.Read.All`
- `DeviceManagementRBAC.Read.All`
- `DeviceManagementServiceConfig.Read.All`
- `Directory.Read.All`
- `DirectoryRecommendations.Read.All`
- `EntitlementManagement.Read.All`
- `IdentityRiskEvent.Read.All`
- `NetworkAccess.Read.All`
- `OnPremDirectorySynchronization.Read.All`
- `OrgSettings-AppsAndServices.Read.All`
- `OrgSettings-Forms.Read.All`
- `Policy.Read.All`
- `Policy.Read.ConditionalAccess`
- `Reports.Read.All`
- `ReportSettings.Read.All`
- `RoleEligibilitySchedule.Read.Directory`
- `RoleManagement.Read.All`
- `RoleManagementAlert.Read.Directory`
- `SecurityIdentitiesHealth.Read.All`
- `SecurityIdentitiesSensors.Read.All`
- `ThreatHunting.Read.All`
- `UserAuthenticationMethod.Read.All`
- `User.ReadWrite` (delegated scope)

Grant admin consent after you create or update these permissions.

## Work with repository guidance

Start with [AGENTS.md](AGENTS.md) for shared engineering expectations and the maintained file-to-skill mapping.
The task-focused skills in `.github/skills/` support evidence-based reviews, permission checks, implementation, and technical writing.
Agents can read these files directly when their client does not discover them automatically.

[CONTRIBUTING.md](CONTRIBUTING.md) explains how to validate changes and verify guidance discovery.
Companion Terraform guides explain resource intent and supporting evidence. Audit requests produce findings; remediation follows the requested scope.

## Run Terraform locally

Use the same tenant and backend values that the workflows use.

1. Change to the Terraform directory.
2. Run `terraform init` with the backend configuration values.
3. Run `terraform validate`.
4. Run `terraform plan`.

Example:

```bash
cd terraform
terraform init -input=false \
  -backend-config="resource_group_name=<TFSTATE_RESOURCE_GROUP_NAME>" \
  -backend-config="storage_account_name=<TFSTATE_STORAGE_ACCOUNT_NAME>" \
  -backend-config="container_name=<TFSTATE_CONTAINER_NAME>" \
  -backend-config="key=<TFSTATE_KEY>" \
  -backend-config="tenant_id=<ARM_TENANT_ID>" \
  -backend-config="client_id=<ARM_CLIENT_ID>" \
  -backend-config="subscription_id=<ARM_SUBSCRIPTION_ID>"
terraform validate
terraform plan -input=false -no-color
```

## Troubleshoot common issues

- `403 AccessDenied` on Conditional Access resources: add `Application.Read.All` and grant admin consent.
- Invalid authentication strength ID: confirm the built-in IDs or query `/policies/authenticationStrengthPolicies`.
- Group settings or lifecycle import issues: follow `terraform/security-groups.md`.
- OIDC federation failures: follow `docs/runbooks/setup-federated-credentials.md` and verify issuer, audience, and subject values.
- Drift issue noise: review the scheduled plan output in the workflow run and the `terraform-drift` issue comments.

## Protect the repository

- Protect `main` with required status checks.
- Restrict who can approve and merge infrastructure changes.
- Scope backend storage access by RBAC.
- Follow `SECURITY.md` for vulnerability reporting.
