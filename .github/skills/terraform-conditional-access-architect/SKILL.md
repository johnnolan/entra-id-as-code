---
name: terraform-conditional-access-architect
description: Trigger when creating, reviewing, or modifying Conditional Access Terraform in terraform/conditional-access.tf; enforce break-glass exclusions, safe rollout states, and Microsoft plus NCSC baseline controls.
compatibility: Requires terraform, tflint, msgraph provider ~> 0.4, and azuread provider ~> 3.0
---

# terraform-conditional-access-architect

## When To Use
- Apply this skill for any change to Conditional Access policy resources in terraform/conditional-access.tf.
- Apply this skill when adding new block, grant, or session policies using msgraph_resource.
- Apply this skill when validating that policy logic follows tenant safety controls and operational guardrails.

## File Scope
- terraform/conditional-access.tf
- terraform/security-groups.tf
- terraform/named-locations.tf
- terraform/policies.tf

## Required Permissions
- Microsoft Graph Application Permission: Policy.Read.All
- Microsoft Graph Application Permission: Policy.ReadWrite.ConditionalAccess
- Additional requirement for policies with applications conditions: Application.Read.All

## Mandatory Guardrails
- Always exclude break-glass users via msgraph_resource.cap_excluded_from_conditional_access.id in conditions.users.excludeGroups.
- Always retain depends_on for:
	msgraph_resource.cap_excluded_from_conditional_access,
	msgraph_resource.named_location_restricted_signin,
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
- Use url = "identity/conditionalAccess/policies" for every Conditional Access policy resource.
- Export resource IDs with response_export_values = { id = "id" }.
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
resource "msgraph_resource" "ca_0000_block_example" {
	depends_on = [
		msgraph_resource.cap_excluded_from_conditional_access,
		msgraph_resource.named_location_restricted_signin,
		msgraph_resource.security_defaults
	]
	url = "identity/conditionalAccess/policies"
	body = {
		displayName = "GLOBAL - 0000 - BLOCK - Example Policy"
		state       = "enabledForReportingButNotEnforced"
		conditions = {
			users = {
				includeUsers  = ["All"]
				excludeGroups = [msgraph_resource.cap_excluded_from_conditional_access.id]
			}
			applications = {
				includeApplications = ["All"]
			}
			clientAppTypes = ["all"]

			# Optional selectors used in this repository
			# locations = {
			#   includeLocations = ["All"]
			#   excludeLocations = [msgraph_resource.named_location_restricted_signin.id]
			# }
			# signInRiskLevels = ["high"]
			# userRiskLevels   = ["medium"]
			# insiderRiskLevels = "elevated"
			# authenticationFlows = {
			#   transferMethods = "deviceCodeFlow,authenticationTransfer"
			# }
		}
		grantControls = {
			operator        = "OR"
			builtInControls = ["block"]
			# or
			# authenticationStrength = {
			#   id = var.authentication_strength_ids.multifactor_authentication
			# }
		}
		# Optional session controls used in this repository
		# sessionControls = {
		#   signInFrequency = {
		#     isEnabled         = true
		#     frequencyInterval = "everyTime"
		#   }
		#   persistentBrowser = {
		#     isEnabled = true
		#     mode      = "never"
		#   }
		#   continuousAccessEvaluation = {
		#     mode = "disabled"
		#   }
		# }
	}
	response_export_values = {
		id = "id"
	}
}
```

## Field Cheat-Sheet
- state: enabled, enabledForReportingButNotEnforced.
- conditions.users.includeUsers: ["All"] or [] for guest-only targeting.
- conditions.users.excludeGroups: include msgraph_resource.cap_excluded_from_conditional_access.id.
- conditions.users.includeGuestsOrExternalUsers.guestOrExternalUserTypes:
	internalGuest,b2bCollaborationGuest,b2bCollaborationMember,b2bDirectConnectUser,otherExternalUser,serviceProvider.
- conditions.users.excludeGuestsOrExternalUsers.guestOrExternalUserTypes:
	b2bDirectConnectUser,otherExternalUser,serviceProvider.
- conditions.users.*.externalTenants.membershipKind: all.
- conditions.applications.includeApplications: All, None, Office365, MicrosoftAdminPortals, or explicit app IDs.
- conditions.clientAppTypes: all, exchangeActiveSync, other.
- conditions.locations.includeLocations: ["All"].
- conditions.locations.excludeLocations: [msgraph_resource.named_location_restricted_signin.id].
- conditions.signInRiskLevels: ["high"], ["medium"].
- conditions.userRiskLevels: ["high"], ["medium"].
- conditions.insiderRiskLevels: elevated.
- conditions.authenticationFlows.transferMethods: deviceCodeFlow,authenticationTransfer.
- grantControls.operator: OR.
- grantControls.builtInControls: block, compliantDevice, mfa.
- grantControls.authenticationStrength.id:
	var.authentication_strength_ids.passwordless_mfa,
	var.authentication_strength_ids.multifactor_authentication,
	var.authentication_strength_ids.phishing_resistant_mfa.
- sessionControls.signInFrequency:
	everyTime mode or typed window type = hours, value = 12.
- sessionControls.persistentBrowser.mode: never.
- sessionControls.continuousAccessEvaluation.mode: disabled.

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
- Confirm policy naming and displayName conform exactly to repository convention.