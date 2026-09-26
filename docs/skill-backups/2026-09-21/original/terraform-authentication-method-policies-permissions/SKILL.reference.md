---
name: terraform-authentication-method-policies-permissions
description: Trigger when creating, reviewing, or modifying authentication-method policy resources in terraform/authentication-method-policies.tf; confirm the Graph permissions and policy scope for Entra authentication methods.
compatibility: Requires terraform, msgraph provider ~> 0.4, and azuread provider ~> 3.0
---

# terraform-authentication-method-policies-permissions

## When To Use
- Apply this skill for any change to `terraform/authentication-method-policies.tf`.
- Use it when auditing Entra authentication method configuration at the tenant level.
- Use it when validating the `msgraph_resource` policies path and the included/excluded targets.

## File Scope
- `terraform/authentication-method-policies.tf`

## Provider Selection
- Use `msgraph_resource` for the authentication methods policy family because this tenant-level API is Graph-specific and not fully represented by an AzureAD resource.
- Keep the resource names and IDs aligned with the actual Graph authenticationMethodsPolicy endpoints.

## Required Microsoft Graph Application Permissions
- `Policy.Read.All`
- `Policy.ReadWrite.AuthenticationMethod`
- `UserAuthenticationMethod.ReadWrite.All`

## Resources Covered
- `msgraph_resource.auth_method_policy_root`
- `msgraph_resource.auth_method_policy_authenticator`
- `msgraph_resource.auth_method_policy_email`
- `msgraph_resource.auth_method_policy_sms`
- `msgraph_resource.auth_method_policy_fido2`
- `msgraph_resource.auth_method_policy_software_oath`
- `msgraph_resource.auth_method_policy_temporary_access_pass`
- `msgraph_resource.auth_method_policy_voice`
- `msgraph_resource.auth_method_policy_x509_certificate`

## Guardrails
- Prefer strong, phishing-resistant methods for privileged or high-risk scenarios.
- Keep weaker methods disabled by default unless there is a clear, approved business requirement.
- Target methods to approved groups only where least privilege requires it.
- Ensure import blocks remain aligned to the fixed Graph resource IDs used by the authentication methods policy family.
- Do not hardcode tenant IDs or credentials in `.tf` files.
