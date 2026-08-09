# Entra ID as Code with Terraform

This repository demonstrates Microsoft Entra ID management with Infrastructure as Code (IaC, version-controlled infrastructure definitions).  
It uses Terraform (an infrastructure provisioning tool) with two providers: AzureAD and MSGraph (Microsoft Graph API provider).  
It deploys through GitHub Actions with OpenID Connect, or OIDC (token-based federated authentication), to avoid long-lived secrets.

## Purpose

Use this repository to:

- Define tenant configuration as Terraform code.
- Review Entra policy changes in pull requests.
- Apply approved changes automatically on merge to main.

## How it works

- Terraform state is stored in Azure Blob Storage (Azure object storage) through the azurerm backend.
- Workflows authenticate through an Entra app registration using federated credentials.
- Plan and apply jobs run from one reusable workflow for consistency.

## Current repository structure

- [terraform/main.tf](terraform/main.tf): Provider definitions and backend configuration.
- [terraform/variables.tf](terraform/variables.tf): Required root variables.
- [terraform/tenant.tf](terraform/tenant.tf): Tenant-level organization settings.
- [terraform/policies.tf](terraform/policies.tf): Tenant policy resources and imports.
- [\.github/workflows/terraform-plan-pr.yml](.github/workflows/terraform-plan-pr.yml): Pull request plan trigger.
- [\.github/workflows/terraform-apply-main.yml](.github/workflows/terraform-apply-main.yml): Main branch apply trigger.
- [\.github/workflows/terraform-run.yml](.github/workflows/terraform-run.yml): Shared workflow execution logic.
- [docs/github-setup/setup-federated-credentials.md](docs/github-setup/setup-federated-credentials.md): Entra portal setup guide for GitHub federation.

## Managed Entra resources

The current Terraform configuration manages:

- Organization notification settings.
- Authentication flows policy.
- Authorization policy.
- External identities policy using Microsoft Graph beta endpoint.
- Identity security defaults enforcement policy.
- Authentication strength policy.

Some resources already exist as tenant singletons. The configuration uses Terraform import blocks to adopt and manage them.

## Authentication and identity model

- GitHub Actions requests an OIDC token at runtime.
- Entra validates token claims against federated credential subjects.
- Terraform providers use `ARM_USE_OIDC`, `ARM_CLIENT_ID`, and `ARM_TENANT_ID` for non-interactive authentication.

## Required GitHub secrets

Set these repository or environment secrets:

- ARM_CLIENT_ID: Entra app registration client ID.
- ARM_TENANT_ID: Entra tenant ID.
- ARM_SUBSCRIPTION_ID: Azure subscription ID used for state backend access.
- TFSTATE_RESOURCE_GROUP_NAME: Resource group containing the state storage account.
- TFSTATE_STORAGE_ACCOUNT_NAME: Storage account for Terraform state.
- TFSTATE_CONTAINER_NAME: Blob container for Terraform state.
- TFSTATE_KEY: Blob name for the state file.

## CI/CD workflow behavior

Plan workflow:

1. Trigger: pull request to main.
2. Steps: fmt, init, validate, and plan.
3. Outcome: validates and previews changes.

Apply workflow:

1. Trigger: push to main.
2. Steps: fmt, init, validate, and apply.
3. Outcome: applies approved changes.

## Local development

From the repository root:

1. `cd terraform`
2. `terraform init -input=false`
3. `terraform validate`
4. `terraform plan -input=false -no-color`

For local runs, authenticate with Azure CLI or equivalent service principal credentials.

## Security and governance

- Grant least-privilege Microsoft Graph application permissions to the app registration.
- Protect main with branch policies and required status checks.
- Restrict access to the Terraform state storage account with RBAC (role-based access control, role-scoped authorization).
- Follow [SECURITY.md](SECURITY.md) for vulnerability reporting and disclosure.
