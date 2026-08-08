# Entra ID as Code with Terraform

This repository shows how to manage Microsoft Entra ID as Infrastructure as Code (IaC, a way to define infrastructure in version-controlled files).  
It uses Terraform (an infrastructure provisioning tool) and the AzureAD provider (the Terraform provider for Microsoft Graph APIs).  
It also uses GitHub Actions (GitHub-hosted CI/CD automation) with OpenID Connect, or OIDC (token-based federated authentication), so no long-lived secrets are required.

## What this repository does

- Manages Entra ID configuration from Terraform files in [terraform/main.tf](terraform/main.tf), [terraform/variables.tf](terraform/variables.tf), and [terraform/tenant.tf](terraform/tenant.tf).
- Stores Terraform state in Azure Blob Storage (object storage in Azure Storage) through the azurerm backend (Terraform remote state backend for Azure).
- Runs pull request plan checks with [\.github/workflows/terraform-plan-pr.yml](.github/workflows/terraform-plan-pr.yml).
- Runs apply on merge to main with [\.github/workflows/terraform-apply-main.yml](.github/workflows/terraform-apply-main.yml).
- Reuses shared pipeline logic from [\.github/workflows/terraform-run.yml](.github/workflows/terraform-run.yml).

## Why this pattern is useful

- You can review tenant changes before deployment through pull request plans.
- You can enforce auditable change control with Git history and workflow logs.
- You can remove secret sprawl by using OIDC federation instead of client secrets.

## Current Terraform scope

This example currently defines:

- AzureAD provider configuration for OIDC authentication.
- AzureRM backend configuration for remote state.
- A baseline authentication strength policy in [terraform/tenant.tf](terraform/tenant.tf).

You can extend this pattern with more tenant controls, such as conditional access policies, identity governance policies, and application registrations.

## Repository structure

- [terraform/main.tf](terraform/main.tf): Provider and backend configuration.
- [terraform/variables.tf](terraform/variables.tf): Required root input variables.
- [terraform/tenant.tf](terraform/tenant.tf): Tenant-level Entra ID resources.
- [\.github/workflows/terraform-plan-pr.yml](.github/workflows/terraform-plan-pr.yml): Plan on pull request to main.
- [\.github/workflows/terraform-apply-main.yml](.github/workflows/terraform-apply-main.yml): Apply on push to main.
- [\.github/workflows/terraform-run.yml](.github/workflows/terraform-run.yml): Reusable Terraform workflow.

## Authentication model

The workflows use a federated identity credential (a trust mapping between GitHub and Entra ID).  
GitHub requests an OIDC token at runtime, and Entra ID validates it before issuing access.  
Terraform then authenticates with ARM_USE_OIDC and AzureAD provider OIDC settings.

## Required GitHub secrets

Set these repository or environment secrets:

- ARM_CLIENT_ID: App registration client ID used by Terraform.
- ARM_TENANT_ID: Entra tenant ID.
- ARM_SUBSCRIPTION_ID: Azure subscription ID for backend access.
- TFSTATE_RESOURCE_GROUP_NAME: Resource group that contains the state storage account.
- TFSTATE_STORAGE_ACCOUNT_NAME: Storage account name for Terraform state.
- TFSTATE_CONTAINER_NAME: Blob container name for Terraform state.
- TFSTATE_KEY: Blob object name for state file. If omitted, workflow defaults to terraform.tfstate.

## How the workflows run

Plan workflow:

1. Trigger: Pull request targeting main.
2. Executes fmt, init, validate, then plan.
3. Uses remote state in Azure Blob Storage.

Apply workflow:

1. Trigger: Push to main, including merge commits.
2. Executes fmt, init, validate, then apply.
3. Applies using the same backend and identity model as plan.

## Local usage

From the repository root:

1. cd terraform
2. terraform init -input=false
3. terraform validate
4. terraform plan -input=false -no-color

For local authentication, use Azure CLI login or configure equivalent OIDC and environment variables.

## Permissions and guardrails

- Grant least privilege to the Entra application roles used by Terraform.
- Limit workflow write access to protected branches.
- Use branch protection and required plan checks before merge.
- Keep Terraform state storage locked down with role-based access control, or RBAC (authorization by role assignment).

## Next extension ideas

- Add conditional access baseline policies in report-only mode first.
- Add environment-specific state keys for dev, test, and prod.
- Add policy-as-code checks for Terraform plans before apply.
