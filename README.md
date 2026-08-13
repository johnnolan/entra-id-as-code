# Entra ID as Code with Terraform

This repository manages Microsoft Entra ID by using Terraform (an infrastructure as code tool). It uses the `azuread` provider and the `msgraph` provider to manage tenant configuration through Microsoft Graph.

GitHub Actions runs plan, apply, drift detection, and Maester checks. Authentication uses OpenID Connect (OIDC, token-based federated authentication) instead of long-lived client secrets.

## Use this repository to

- Define tenant controls in Terraform.
- Review infrastructure changes in pull requests.
- Apply approved changes on merge to `main`.
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

## Note the placeholder modules

These Terraform files exist but are still placeholders:

- `terraform/access-packages.tf`
- `terraform/authentication-method-policies.tf`
- `terraform/cross-tenant-access.tf`

Each file currently contains `# TODO` only.

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
- `docs/github-setup/setup-federated-credentials.md`: Entra and GitHub OIDC setup guide.

### GitHub Actions workflows

- `.github/workflows/terraform-plan-pr.yml`: Pull request plan trigger.
- `.github/workflows/terraform-apply-main.yml`: Main branch apply trigger.
- `.github/workflows/terraform-drift-daily.yml`: Scheduled drift detection workflow.
- `.github/workflows/terraform-maester.yml`: Scheduled Maester test workflow.
- `.github/workflows/terraform-run.yml`: Reusable Terraform workflow.

## Understand the workflows

### Pull request plan

Workflow: `.github/workflows/terraform-plan-pr.yml`

- Trigger: pull request to `main`.
- Path filter: `terraform/**` and `.github/workflows/**/*.yml`.
- Behavior: runs the reusable Terraform workflow with `command: plan`.
- Output: uploads plan artifacts, writes a workflow summary, and posts a pull request comment with the plan summary.

### Main branch apply

Workflow: `.github/workflows/terraform-apply-main.yml`

- Trigger: push to `main`.
- Path filter: `terraform/**` and `.github/workflows/**/*.yml`.
- Behavior: runs the reusable Terraform workflow with `command: apply`.

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

Set these GitHub Actions secrets:

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
- `Policy.ReadWrite.ExternalIdentities`
- `Policy.ReadWrite.SecurityDefaults`
- `Directory.ReadWrite.All`
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

## Use the included Copilot skills

This repository includes task-focused Copilot skills in `.github/skills`.

Available skills:

- `gds-tech-writer`: Rewrite or review technical documentation.
- `terraform-conditional-access-architect`: Review or modify `terraform/conditional-access.tf` with baseline and rollout guardrails.
- `terraform-main-permissions`: Explain permission context for `terraform/main.tf`.
- `terraform-named-locations-permissions`: Explain permission context for `terraform/named-locations.tf`.
- `terraform-outputs-permissions`: Explain permission context for `terraform/outputs.tf`.
- `terraform-policies-permissions`: Explain permission context for `terraform/policies.tf`.
- `terraform-security-groups-permissions`: Explain permission context for `terraform/security-groups.tf`.
- `terraform-tenant-permissions`: Explain permission context for `terraform/tenant.tf`.
- `terraform-variables-permissions`: Explain permission context for `terraform/variables.tf`.

Files without a dedicated skill yet include:

- `terraform/access-packages.tf`
- `terraform/authentication-method-policies.tf`
- `terraform/cross-tenant-access.tf`
- `terraform/service-principles.tf`

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

If you use Azure CLI locally, ensure you can get a Microsoft Graph token before you run import or discovery commands.

## Troubleshoot common issues

- `403 AccessDenied` on Conditional Access resources: add `Application.Read.All` and grant admin consent.
- Invalid authentication strength ID: confirm the built-in IDs or query `/policies/authenticationStrengthPolicies`.
- Group settings or lifecycle import issues: follow `terraform/security-groups.md`.
- OIDC federation failures: follow `docs/github-setup/setup-federated-credentials.md` and verify issuer, audience, and subject values.
- Drift issue noise: review the scheduled plan output in the workflow run and the `terraform-drift` issue comments.

## Protect the repository

- Protect `main` with required status checks.
- Restrict who can approve and merge infrastructure changes.
- Scope backend storage access by RBAC.
- Follow `SECURITY.md` for vulnerability reporting.
