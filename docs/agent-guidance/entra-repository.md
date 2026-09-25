# Apply Entra skills in this repository

The active skills describe reusable workflows. This guide contains local conventions and observed configuration, not universal Entra requirements.
Read it for Conditional Access work and when adapting skill examples to this repository.

## Locate configuration and versions

Terraform lives in `terraform/`. Read the target file and its companion guide before changing behavior.
[main.tf](../../terraform/main.tf) currently requires Terraform `>= 1.15.0`, AzureAD `~> 3.0`, and Microsoft Graph `~> 0.5`.
The locally available lockfile selected AzureAD 3.9.0 and msgraph 0.5.0 during this review on 2026-09-21; it is ignored by Git.
Those installed schemas were inspected in a temporary configuration without a backend. This is schema evidence, not a tenant plan or deployment test.

AzureAD 3.9.0 has no typed group lifecycle/settings, authentication-method-policy, or cross-tenant-default resource in the inspected schema.
Its Conditional Access session schema lacks `continuousAccessEvaluation`; keep the existing Graph resource until a reviewed migration supports a typed replacement.
Recheck these gaps against the selected version when making changes.

## Preserve the Conditional Access baseline

- Use resource names `ca_<4digit>_<block|grant|session>_<purpose>` and display names `GLOBAL - <4digit> - <BLOCK|GRANT|SESSION> - <title>`.
- Every user-targeted baseline policy must preserve the exclusion of `azuread_group.cap_excluded_from_conditional_access.object_id`.
- Do not remove or narrow emergency-access exclusions without explicit approval.
- New policies start in `enabledForReportingButNotEnforced`. Never create and enforce a policy in the same pull request.
- Promotion requires a follow-up pull request after sign-in impact validation and approval. Existing enabled policies remain enabled during unrelated work.
- Preserve the explicit baseline dependencies on the exclusion group, `azuread_named_location.named_location_restricted_signin`, and `msgraph_resource.security_defaults`.
- Group and location references can imply dependencies. Their explicit inclusion is a local convention; Security Defaults ordering is a behavioral dependency.
- Keep Security Defaults disabled while the established custom baseline is in use. Do not generalize that transition sequence to a new tenant.
- Preserve legacy-authentication blocking, risk responses, and MFA protections for administrators, users, and guests within the requested scope.
- Preserve the baseline's deny-by-default geographic restrictions.
- Keep exclusions narrow; do not add broad user, group, or application exceptions. Trust location exclusions only when explicitly approved.

Use managed authentication-strength IDs from `default_mfa`, `passwordless_mfa`, and `phishing_resistant_mfa` in [policies.tf](../../terraform/policies.tf).
The repository does not define `var.authentication_strength_ids`. Do not recreate that obsolete variable contract or prefix managed `.id` values.

## Separate resource ownership

- [security-groups.tf](../../terraform/security-groups.tf) owns group objects, including the example access-package group.
- [group-settings.tf](../../terraform/group-settings.tf) owns lifecycle and tenant group settings. Preserve its create-or-adopt distinction.
- [authentication-method-policies.tf](../../terraform/authentication-method-policies.tf) includes all configured method resources, including Verifiable Credentials and QR code PIN.
- [service-principles.tf](../../terraform/service-principles.tf) creates an application and federated credential. Requested Maester permissions are separate from Terraform's execution permissions.
- [privileged-role-notifications.tf](../../terraform/privileged-role-notifications.tf) follows the general Entra workflow and its companion guide; research its role-policy operations directly.

## Validate and maintain

Follow [CONTRIBUTING.md](../../CONTRIBUTING.md#local-validation-steps). Documentation-only changes need link and consistency checks, not Terraform execution.
Use the [discovery and behavior scenarios](skill-validation.md) to check agent clients after guidance changes.
The [backup](../skill-backups/2026-09-21/README.md) is historical and must not be loaded as active instructions.
