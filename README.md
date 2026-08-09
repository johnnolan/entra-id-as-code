# Entra ID as Code with Terraform

This repository manages Microsoft Entra ID by using Infrastructure as Code (IaC, version-controlled infrastructure definitions).  
It uses Terraform (an infrastructure provisioning tool) with AzureAD and MSGraph (Microsoft Graph API) providers.  
It deploys through GitHub Actions with OpenID Connect (OIDC, token-based federated authentication).

## Purpose

Use this repository to:

- Define Entra tenant controls in Terraform.
- Review policy changes in pull requests.
- Apply approved changes automatically on merge to main.

## Architecture

- Terraform state is stored in Azure Blob Storage (Azure object storage) through the azurerm backend.
- GitHub Actions authenticates to Entra through federated credentials.
- Workflows call one reusable workflow for consistent plan and apply behavior.

## Repository Structure

- [terraform/main.tf](terraform/main.tf): Terraform backend and provider definitions.
- [terraform/variables.tf](terraform/variables.tf): Root input variables.
- [terraform/outputs.tf](terraform/outputs.tf): Root output values.
- [terraform/tenant.tf](terraform/tenant.tf): Tenant organization settings.
- [terraform/policies.tf](terraform/policies.tf): Tenant policy resources.
- [terraform/security-groups.tf](terraform/security-groups.tf): Security groups and group settings.
- [terraform/named-locations.tf](terraform/named-locations.tf): Conditional Access named locations.
- [terraform/conditional-access.tf](terraform/conditional-access.tf): Conditional Access policies.
- [terraform/security-groups.md](terraform/security-groups.md): Group settings and lifecycle policy lookup guide.
- [.github/workflows/terraform-plan-pr.yml](.github/workflows/terraform-plan-pr.yml): Pull request plan trigger.
- [.github/workflows/terraform-apply-main.yml](.github/workflows/terraform-apply-main.yml): Main branch apply trigger.
- [.github/workflows/terraform-run.yml](.github/workflows/terraform-run.yml): Reusable Terraform workflow.
- [docs/github-setup/setup-federated-credentials.md](docs/github-setup/setup-federated-credentials.md): Entra federation setup.

## Managed Entra Resources

Terraform currently manages:

- Organization settings.
- Authentication flow policy.
- Authorization policy.
- External identities policy.
- Security defaults policy.
- Authentication strength policy.
- Conditional Access named locations.
- Conditional Access policies.
- Group lifecycle policy.
- Group settings.
- Conditional Access exclusion group.

Some resources are tenant singletons. Terraform import blocks adopt existing singleton objects.

## Required GitHub Secrets

Set these repository or environment secrets:

- ARM_CLIENT_ID: Entra app registration client ID.
- ARM_TENANT_ID: Entra tenant ID.
- ARM_SUBSCRIPTION_ID: Azure subscription ID for state backend access.
- TFSTATE_RESOURCE_GROUP_NAME: Resource group hosting the state storage account.
- TFSTATE_STORAGE_ACCOUNT_NAME: Storage account that holds Terraform state.
- TFSTATE_CONTAINER_NAME: Blob container for Terraform state.
- TFSTATE_KEY: Blob name for the state file.

## Required Microsoft Graph App Permissions

Grant these Microsoft Graph application permissions to the CI app registration:

- Policy.Read.All
- Policy.ReadWrite.ConditionalAccess
- Policy.ReadWrite.AuthenticationFlows
- Policy.ReadWrite.Authorization
- Policy.ReadWrite.ExternalIdentities
- Organization.ReadWrite.All
- Group.ReadWrite.All
- GroupSettings.ReadWrite.All
- Directory.ReadWrite.All
- Application.Read.All

Grant admin consent after you add or update permissions.

## Skills

This repository includes Copilot skills (task-focused instruction files) under [.github/skills](.github/skills).

Use these skills to speed up documentation, permission reviews, and troubleshooting:

- [gds-tech-writer](.github/skills/gds-tech-writer/SKILL.md): Improves technical documentation structure and readability while preserving technical terminology.
- [terraform-main-permissions](.github/skills/terraform-main-permissions/SKILL.md): Explains permission context for [terraform/main.tf](terraform/main.tf).
- [terraform-variables-permissions](.github/skills/terraform-variables-permissions/SKILL.md): Explains permission context for [terraform/variables.tf](terraform/variables.tf).
- [terraform-outputs-permissions](.github/skills/terraform-outputs-permissions/SKILL.md): Explains permission context for [terraform/outputs.tf](terraform/outputs.tf).
- [terraform-tenant-permissions](.github/skills/terraform-tenant-permissions/SKILL.md): Lists Graph permissions for [terraform/tenant.tf](terraform/tenant.tf).
- [terraform-policies-permissions](.github/skills/terraform-policies-permissions/SKILL.md): Lists Graph permissions for [terraform/policies.tf](terraform/policies.tf).
- [terraform-security-groups-permissions](.github/skills/terraform-security-groups-permissions/SKILL.md): Lists Graph permissions for [terraform/security-groups.tf](terraform/security-groups.tf).
- [terraform-named-locations-permissions](.github/skills/terraform-named-locations-permissions/SKILL.md): Lists Graph permissions for [terraform/named-locations.tf](terraform/named-locations.tf).
- [terraform-conditional-access-permissions](.github/skills/terraform-conditional-access-permissions/SKILL.md): Lists Graph permissions for [terraform/conditional-access.tf](terraform/conditional-access.tf).

### How To Use Skills

Use these prompt patterns in Copilot Chat:

1. "Use gds-tech-writer to rewrite [README.md](README.md) for scannability and clarity."
2. "Use terraform-conditional-access-permissions to verify permissions before I run apply."
3. "Use terraform-security-groups-permissions to explain why GroupSettings calls fail with AccessDenied."
4. "Use terraform-policies-permissions to build a least-privilege Graph permission checklist."

For each Terraform file change, run the related permission skill before merging to main.

## CI/CD Workflow Behavior

Plan workflow:

1. Trigger: pull request to main.
2. Steps: fmt, init, validate, and plan.
3. Outcome: validates code and previews changes.

Apply workflow:

1. Trigger: push to main.
2. Steps: fmt, init, validate, and apply.
3. Outcome: applies approved changes.

## Local Development

From repository root:

1. `cd terraform`
2. `terraform init -input=false`
3. `terraform validate`
4. `terraform plan -input=false -no-color`

For local runs, sign in with Azure CLI or use a service principal.

## Troubleshooting

Use these checks for common Microsoft Graph errors:

- 403 AccessDenied with application conditions: add `Application.Read.All` and grant admin consent.
- Invalid authentication strength ID: use built-in IDs from Graph or query `/policies/authenticationStrengthPolicies`.
- Conditional Access policy validation errors: verify allowed condition combinations for each control type.
- Group settings and lifecycle imports: follow [terraform/security-groups.md](terraform/security-groups.md).

## Security and Governance

- Grant least-privilege Graph permissions to the CI app registration.
- Protect main with branch protection and required status checks.
- Restrict state storage access by using RBAC (role-based access control).
- Follow [SECURITY.md](SECURITY.md) for vulnerability reporting.
