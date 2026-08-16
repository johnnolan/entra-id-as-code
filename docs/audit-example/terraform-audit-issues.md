# Terraform Audit Issues

This backlog tracks issues identified during the Entra ID Terraform audit. Work from the top down. Items marked **decision required** change live tenant behavior and need confirmation before implementation.

## High priority

- [ ] **Confirm authentication-strength policy IDs**
  - File: `terraform/variables.tf`, `terraform/conditional-access.tf`
  - Problem: The default `authentication_strength_ids` values are all-zero UUID placeholders. Conditional Access policies reference these IDs for passwordless, multifactor, and phishing-resistant authentication.
  - Fix: Query `GET /policies/authenticationStrengthPolicies`, set tenant-specific inputs, and avoid relying on placeholder defaults.
  - Completion check: Every referenced authentication-strength ID exists in the target tenant and each policy plan resolves to the intended policy.

- [x] **Restrict default cross-tenant B2B collaboration** *(decision required)*
  - File: `terraform/cross-tenant-access.tf`
  - Problem: Inbound and outbound B2B collaboration allow all applications and all users. This permits broad collaboration with external Entra tenants.
  - Fix: Define approved partner tenants and scope applications, users, and groups. Keep B2B Direct Connect blocked unless there is an approved business requirement.
  - Completion check: A policy test confirms that only approved partner configurations permit collaboration and that the default configuration is not broader than intended.

- [x] **Decide whether to enable Continuous Access Evaluation** *(decision required)*
  - File: `terraform/conditional-access.tf`
  - Problem: The Continuous Access Evaluation policy is enabled, but its `continuousAccessEvaluation.mode` is explicitly `disabled`.
  - Fix: Confirm the tenant supports the intended workload coverage, then change the mode to the approved setting.
  - Completion check: The resulting Graph policy reports the expected Continuous Access Evaluation mode and the rollout plan includes monitoring for session interruptions.

- [x] **Define and enforce approved FIDO2 key restrictions** *(decision required)*
  - File: `terraform/authentication-method-policies.tf`
  - Problem: FIDO2 attestation is enforced, but `keyRestrictions.isEnforced` is `false`.
  - Fix: Agree the approved FIDO2 vendors and AAGUIDs, populate `aaGuids`, and enable key restrictions.
  - Completion check: Registration of an approved key succeeds, an unapproved key is rejected, and the configuration satisfies Maester `EIDSCA.AF04`.

- [x] **Review the Maester application's delegated write permission** *(decision required)*
  - File: `terraform/service-principles.tf`
  - Problem: The application requests delegated `User.ReadWrite`, although the application is primarily configured for Maester assessment access.
  - Fix: Confirm whether Maester requires this delegated permission. Remove it if it is unused and obtain consent only for required permissions.
  - Completion check: The application permission list matches the documented Maester requirements and contains no unnecessary write permission.

## Medium priority

- [ ] **Replace `jsonencode` with structured HCL**
  - File: `terraform/policies.tf`
  - Problem: `msgraph_resource.b2b_management_policy` wraps its `definition` object in `jsonencode`, contrary to the repository convention for Graph resource bodies.
  - Fix: Express the nested definition as a plain HCL object while preserving the provider's expected shape.
  - Completion check: `terraform fmt -check -diff`, `terraform validate`, and a plan with both `allow_list` and `block_list` inputs pass without type errors.

- [ ] **Review broad authentication-method targeting** *(decision required)*
  - File: `terraform/authentication-method-policies.tf`
  - Problem: Software OATH, Temporary Access Pass, FIDO2, and several other method configurations target all users. Software OATH in particular may be broader than required.
  - Fix: Confirm the intended user groups for each method. Scope bootstrap and recovery methods to the users who need them.
  - Completion check: Each method has an approved target group, a documented business purpose, and no deleted or unintended group references.

- [ ] **Configure Microsoft Authenticator number matching** *(decision required)*
  - File: `terraform/authentication-method-policies.tf`
  - Problem: The policy displays application and location information, but no number-matching configuration is defined.
  - Fix: Enable number matching for the approved population and define any rollout exclusions.
  - Completion check: The Graph configuration reports number matching enabled for the intended users and Maester checks pass where applicable.

- [ ] **Promote the noncompliant-device policy after rollout** *(decision required)*
  - File: `terraform/conditional-access.tf`
  - Problem: `ca_1088_block_sensitive_apps_noncompliant_devices` remains `enabledForReportingButNotEnforced`.
  - Fix: Review report-only results, remediate expected device-registration issues, then promote the policy when approved.
  - Completion check: Enforcement criteria are documented, sign-in impact is reviewed, and the policy state is intentionally enabled or remains report-only with an owner and review date.

- [ ] **Move the group lifecycle notification address to an input**
  - File: `terraform/security-groups.tf`, `terraform/variables.tf`
  - Problem: The notification address is hardcoded as `me@johnnolan.dev`.
  - Fix: Add a validated variable for the notification address and use it in the lifecycle policy.
  - Completion check: No owner-specific email remains in the resource file, and the value is supplied through environment-specific Terraform input.

- [ ] **Review guest-addition settings for consistency** *(decision required)*
  - File: `terraform/security-groups.tf`
  - Problem: `AllowToAddGuests` is `true` while guest access to groups and guest ownership are disabled. The combination may not express the intended collaboration boundary.
  - Fix: Confirm whether guests should be addable to groups, then align the related group settings.
  - Completion check: The resulting settings have a documented guest collaboration outcome and pass the relevant group-security checks.

## Low priority

- [ ] **Remove or replace the placeholder logout URL**
  - File: `terraform/service-principles.tf`
  - Problem: The application uses `https://empty-redirect-uri` as `logout_url`.
  - Fix: Remove the property if it is unnecessary, or replace it with a valid HTTPS URL owned by the application.
  - Completion check: The application contains no placeholder URL and Terraform validation still passes.

- [ ] **Review the GitHub federated credential subject**
  - File: `terraform/service-principles.tf`
  - Problem: The subject is tightly coupled to a repository owner and numeric identifiers.
  - Fix: Confirm the subject exactly matches the intended GitHub Actions repository, organization, and branch. Consider environment-specific inputs if this configuration is reused.
  - Completion check: A GitHub Actions token from the intended subject exchanges successfully, while tokens from other repositories and branches do not.

- [ ] **Add missing companion guides**
  - Files: `terraform/main.tf`, `terraform/variables.tf`, `terraform/named-locations.tf`, `terraform/cross-tenant-access.tf`, `terraform/service-principles.tf`, `terraform/tenant.tf`, `terraform/outputs.tf`
  - Problem: These Terraform files do not have companion Markdown guides.
  - Fix: Add one guide per file with resource purpose, security rationale, required permissions, and verified Microsoft and Maester references.
  - Completion check: Every non-empty Terraform file has a same-name Markdown guide, and every citation is verified against a stable URL.

- [ ] **Correct the shared Maester and NCSC mapping**
  - File: `.github/skills/terraform-security-baseline-auditor/references/maester-ncsc-mapping.md`
  - Problem: Several existing rows use test IDs or names that do not match the current local index. The live `MT.1057` page currently describes application secrets rather than group expiration.
  - Fix: Reverify every existing row against the stable Maester test page and remove or correct stale mappings. Verify NCSC URLs before citing them.
  - Completion check: Every mapping row has a current stable Maester URL, an accurate test title, and a verified Microsoft or NCSC alignment.

## Validation after each change

Run from the repository root:

```text
terraform fmt -check -diff
terraform validate
tflint --format compact
```

For behavior-changing Conditional Access, authentication-method, and cross-tenant changes, review the plan and test in a non-production tenant before enabling enforcement.

## Verified references

- [Microsoft Entra Conditional Access overview](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview)
- [Manage authentication methods](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-methods-manage)
- [Authorization policy resource](https://learn.microsoft.com/en-us/graph/api/resources/authorizationpolicy)
- [Cross-tenant access policy resource](https://learn.microsoft.com/en-us/graph/api/resources/crosstenantaccesspolicy)
- [Maester MT.1005](https://maester.dev/docs/tests/MT.1005)
- [Maester MT.1016](https://maester.dev/docs/tests/MT.1016)
- [Maester EIDSCA.AF03](https://maester.dev/docs/tests/EIDSCA.AF03)
- [Maester EIDSCA.AF04](https://maester.dev/docs/tests/EIDSCA.AF04)
- [Maester EIDSCA.AT02](https://maester.dev/docs/tests/EIDSCA.AT02)
