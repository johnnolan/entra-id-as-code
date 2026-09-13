# Contributing

Thank you for contributing to this repository.

This project manages Microsoft Entra ID through Terraform (an infrastructure provisioning tool).  
Changes can affect tenant-wide policies, so review and validation are mandatory.

## Before you contribute

Read these project documents first:

- [README.md](README.md)
- [SECURITY.md](SECURITY.md)
- [AGENTS.md](AGENTS.md)
- [docs/runbooks/setup-federated-credentials.md](docs/runbooks/setup-federated-credentials.md)

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

For documentation-only changes, check relative links and compare behavior descriptions with the source files.

For Terraform changes, run static checks from the repository root:

```bash
terraform -chdir=terraform fmt -check -recursive
terraform -chdir=terraform init -backend=false -input=false
terraform -chdir=terraform validate
cd terraform
tflint --init
tflint -f compact
```

Backend-disabled initialization can download providers but does not create a tenant plan. Use a clean checkout if existing backend initialization interferes.
For an authorized tenant plan, follow [Run Terraform locally](README.md#run-terraform-locally) with the required backend configuration and authentication.
Record static checks and live plan results separately. Explain missing tools, credentials, or network access rather than claiming unperformed checks passed.

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

## Maintain and verify agent guidance

Keep shared expectations and file-to-skill routing in [AGENTS.md](AGENTS.md).
Keep domain procedures in the linked skills and resource rationale in companion guides. Update these together when behavior changes.

To check discovery after changing guidance:

1. Start a fresh session in each supported agent client at the repository root.
2. Ask: "Without editing files, list the repository instruction files you loaded and identify the guidance for reviewing Conditional Access."
3. Check that it identifies `AGENTS.md`, the Conditional Access skill, and the companion guide.
4. Ask for a review and check that it reports findings without making unrequested edits.
5. If automatic discovery fails, explicitly provide `AGENTS.md` and confirm that the agent follows its links.

For Copilot, also check that `.github/copilot-instructions.md` routes to the root guidance.
Record the client and observed result when reporting a discovery check. Link validation alone does not prove client loading behavior.
