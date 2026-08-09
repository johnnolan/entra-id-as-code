# Contributing

Thank you for contributing to this repository.

This project manages Microsoft Entra ID through Terraform (an infrastructure provisioning tool).  
Changes can affect tenant-wide policies, so review and validation are mandatory.

## Before you contribute

Read these project documents first:

- [README.md](README.md)
- [SECURITY.md](SECURITY.md)
- [docs/github-setup/setup-federated-credentials.md](docs/github-setup/setup-federated-credentials.md)

## Prerequisites

Install and configure:

- Terraform CLI
- Azure CLI
- Access to an Entra tenant and Azure subscription for testing

You also need a service principal (an Entra application identity for automation) with the required Microsoft Graph application permissions.

## Repository layout

Key files and folders:

- [terraform/main.tf](terraform/main.tf): Providers and backend configuration.
- [terraform/variables.tf](terraform/variables.tf): Root module inputs.
- [terraform/tenant.tf](terraform/tenant.tf): Tenant-level organization settings.
- [terraform/policies.tf](terraform/policies.tf): Policy resources and imports.
- [\.github/workflows/terraform-plan-pr.yml](.github/workflows/terraform-plan-pr.yml): Pull request plan trigger.
- [\.github/workflows/terraform-apply-main.yml](.github/workflows/terraform-apply-main.yml): Apply trigger on main.
- [\.github/workflows/terraform-run.yml](.github/workflows/terraform-run.yml): Shared CI execution workflow.

## Development workflow

1. Create a feature branch from main.
2. Make focused changes with clear intent.
3. Run local Terraform checks.
4. Open a pull request.
5. Wait for CI plan results and complete review.

## Local validation steps

Run from the repository root:

```bash
cd terraform
terraform fmt -check -recursive
terraform init -input=false
terraform validate
terraform plan -input=false -no-color
```

If your change manages existing singleton resources, confirm import blocks remain correct.

## Pull request requirements

Every pull request must include:

- A clear summary of the change
- Rationale for policy or tenant setting changes
- Evidence of local validation
- Any permission changes needed in Entra app registration

Keep pull requests small. Large mixed changes are harder to review and rollback.

## Terraform authoring guidance

- Use explicit provider sources and versions.
- Avoid hardcoded tenant identifiers when dynamic data is available.
- Use `api_version = "beta"` only when the Graph API requires it.
- Add comments only when intent is not obvious from code.

## Security and secrets

- Never commit credentials, tokens, or secret values.
- Use GitHub Actions secrets for runtime variables.
- Report security concerns through [SECURITY.md](SECURITY.md).

## Commit guidance

Use descriptive commit messages that explain what changed and why.  
Prefer one logical change per commit.

## Review and merge

- Plan checks must pass before merge.
- At least one reviewer should approve policy-impacting changes.
- Merge only when the expected Terraform plan is understood.

## Questions and support

If you are unsure about a tenant-wide change, open a draft pull request early.  
Use the draft to discuss permissions, blast radius, and rollback strategy before final review.
