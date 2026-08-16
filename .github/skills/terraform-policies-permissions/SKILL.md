# terraform-policies-permissions

**Description:** Lists Microsoft Graph application permissions required by `terraform/policies.tf`.

## Purpose
Use this skill when validating or troubleshooting permissions for tenant policy resources.

## File Scope
- `terraform/policies.tf`

## Provider Selection
Use an AzureAD typed resource where it supports the required policy. Use `msgraph_resource` only when AzureAD has no equivalent. The tenant-wide policy endpoints in this file remain Graph-managed; `azuread_authentication_strength_policy.default_mfa` already uses AzureAD.

## Required Microsoft Graph Application Permissions
- `Policy.ReadWrite.AuthenticationFlows`
- `Policy.ReadWrite.Authorization`
- `Policy.ReadWrite.B2BManagementPolicy`
- `Policy.ReadWrite.CrossTenantAccess`
- `Policy.ReadWrite.ExternalIdentities`
- `Policy.Read.All`
- `Policy.ReadWrite.ConditionalAccess`

## Resources Covered
- `msgraph_resource.authentication_flow_policy`
- `msgraph_resource.authorization_policy`
- `msgraph_resource.external_identity_policy`
- `msgraph_resource.b2b_management_policy`
- `msgraph_resource.security_defaults`
- `azuread_authentication_strength_policy.default_mfa`