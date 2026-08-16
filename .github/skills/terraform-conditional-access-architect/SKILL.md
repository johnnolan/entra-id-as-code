---
name: terraform-conditional-access-architect
description: Trigger when creating, reviewing, or modifying Conditional Access Terraform in terraform/conditional-access.tf; enforce break-glass exclusions, safe rollout states, and Microsoft plus NCSC baseline controls.
compatibility: Requires terraform, tflint, msgraph provider ~> 0.4, and azuread provider ~> 3.0
---

# terraform-conditional-access-architect

## When To Use
- Apply this skill for any change to Conditional Access policy resources in terraform/conditional-access.tf.
- Apply this skill when adding new block, grant, or session policies.
- Apply this skill when validating that policy logic follows tenant safety controls and operational guardrails.

## File Scope
- terraform/conditional-access.tf
- terraform/security-groups.tf
- terraform/named-locations.tf
- terraform/policies.tf

## Provider Selection
- Use `azuread_conditional_access_policy` for every Conditional Access policy that the AzureAD provider supports.
- Use `msgraph_resource` only when AzureAD lacks the required field or resource type. In this repository, `ca_3040_session_continuous_access_evaluation` remains Graph-managed because AzureAD does not expose the `continuousAccessEvaluation` session control.

## Required Permissions
- Microsoft Graph Application Permission: Policy.Read.All
- Microsoft Graph Application Permission: Policy.ReadWrite.ConditionalAccess
- Additional requirement for policies with applications conditions: Application.Read.All

## Mandatory Guardrails
- Always exclude break-glass users via azuread_group.cap_excluded_from_conditional_access.object_id in conditions.users.excluded_groups.
- Always retain depends_on for:
	azuread_group.cap_excluded_from_conditional_access,
	azuread_named_location.named_location_restricted_signin,
	msgraph_resource.security_defaults.
- Always keep security defaults disabled when Conditional Access baseline is in use (see msgraph_resource.security_defaults).
- Never remove or narrow emergency-access exclusions without explicit human approval.
- Require all new Conditional Access policies to start as enabledForReportingButNotEnforced (report-only behavior).
- Never set a brand-new policy to enabled in the same PR that creates it.
- Promote from enabledForReportingButNotEnforced to enabled only in a follow-up PR after sign-in impact validation and approval.
- Keep baseline identity protections enforced:
	block legacy auth,
	block risky sign-ins/users,
	enforce strong MFA for admins,
	enforce MFA for all users and guests.
- Minimize exclusions to break-glass scope only; do not add broad user, group, or app exclusions.
- Use named location exclusions only for explicitly trusted locations; treat geo restrictions as deny-by-default.

## Execution Rules
- Follow resource naming pattern exactly: ca_<4digit>_<block|grant|session>_<purpose>.
- Follow display name pattern exactly: GLOBAL - <4digit> - <BLOCK|GRANT|SESSION> - <title>.
- Use AzureAD typed attributes and nested blocks for Conditional Access policies. Do not use a Graph `url`, `body`, or `response_export_values` for AzureAD-managed policies.
- Prefer authenticationStrength IDs from var.authentication_strength_ids for grant policies.
- Keep clientAppTypes explicit; default to ["all"] unless policy intent requires exchangeActiveSync and other.
- Preserve least privilege and zero trust principles aligned to Microsoft Conditional Access guidance and NCSC identity hardening guidance.

## Canonical Variable Input
Use this exact variable contract when authentication strength is needed:

```hcl
variable "authentication_strength_ids" {
	description = "Map of friendly authentication strength policy name -> object ID. Built-in strengths have well-known IDs in most tenants but confirm via GET /policies/authenticationStrengthPolicies."
	type        = map(string)
	default = {
		passwordless_mfa           = "00000000-0000-0000-0000-000000000003"
		multifactor_authentication = "00000000-0000-0000-0000-000000000002"
		phishing_resistant_mfa     = "00000000-0000-0000-0000-000000000004"
	}
}
```

## Explicit HCL Resource Template
Use this exact module style and shape for new policies:

```hcl
resource "azuread_conditional_access_policy" "ca_0000_block_example" {
	depends_on = [
		azuread_group.cap_excluded_from_conditional_access,
		azuread_named_location.named_location_restricted_signin,
		msgraph_resource.security_defaults
	]
	display_name = "GLOBAL - 0000 - BLOCK - Example Policy"
	state        = "enabledForReportingButNotEnforced"

	conditions {
		client_app_types = ["all"]
		applications {
			included_applications = ["All"]
		}
		users {
			included_users  = ["All"]
			excluded_groups = [azuread_group.cap_excluded_from_conditional_access.object_id]
		}
	}

	grant_controls {
		operator          = "OR"
		built_in_controls = ["block"]
	}
}
```

## Field Cheat-Sheet
- `conditions.users.included_users`: `All`, `None`, or explicit IDs. Use a guest block for guest-only targeting.
- `conditions.users.excluded_groups`: include `azuread_group.cap_excluded_from_conditional_access.object_id`.
- `conditions.users.included_guests_or_external_users` and `excluded_guests_or_external_users`: use `guest_or_external_user_types` and, where required, `external_tenants { membership_kind = "all" }`.
- `conditions.applications.included_applications`: `All`, `None`, `Office365`, `MicrosoftAdminPortals`, or explicit app IDs.
- `conditions.client_app_types`: `all`, `exchangeActiveSync`, or `other`.
- `conditions.locations.excluded_locations`: `azuread_named_location.named_location_restricted_signin.object_id`.
- `conditions.sign_in_risk_levels`, `user_risk_levels`, `insider_risk_levels`, and `authentication_flow_transfer_methods`: use AzureAD snake_case attributes.
- `grant_controls.built_in_controls`: `block`, `compliantDevice`, or `mfa`.
- `grant_controls.authentication_strength_policy_id`: prefix the variable value with `/policies/authenticationStrengthPolicies/`.
- `session_controls`: use `sign_in_frequency_interval`, `sign_in_frequency`, `sign_in_frequency_period`, and `persistent_browser_mode`.
- `continuousAccessEvaluation` has no AzureAD equivalent. Use Graph only for that control.

## Security Control Rules
- Implement NCSC-aligned identity hardening: phishing-resistant MFA for privileged access, minimal standing privilege, and explicit emergency access design.
- Implement Microsoft Conditional Access baseline controls: block legacy authentication, enforce risk-based responses, and protect admin portals.
- Prefer strongest practical authentication strength for privileged scenarios.
- Roll out disruptive controls in report-only first, review sign-in impact, then enforce.
- Preserve auditability by keeping deterministic naming and exported resource IDs.

## Validation Checklist For Agents
- Confirm every policy excludes the break-glass group.
- Confirm every policy has the standard depends_on block.
- Confirm policy state matches rollout intent and blast radius.
- Confirm newly created policies are set to enabledForReportingButNotEnforced.
- Confirm no PR both creates a policy and sets that same policy to enabled.
- Confirm grants use authentication strength where stronger assurance is required.
- Confirm location-based controls only trust approved named locations.
- Confirm policy naming and `display_name` conform exactly to repository convention.

* **Compliance & Test Mapping:** When auditing generated policies against official UK Government baseline standards or Maester assertions, consult:
  `references/maester-ncsc-mapping.md`