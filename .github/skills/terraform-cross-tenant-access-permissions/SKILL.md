---
name: terraform-cross-tenant-access-permissions
description: Trigger when creating, reviewing, or modifying cross-tenant access policy configuration in terraform/cross-tenant-access.tf; confirm the Graph permissions and default trust controls for inter-tenant access.
compatibility: Requires terraform, msgraph provider ~> 0.4, and azuread provider ~> 3.0
---

# terraform-cross-tenant-access-permissions

## When To Use
- Apply this skill for any change to `terraform/cross-tenant-access.tf`.
- Use it when validating cross-tenant collaboration and inbound/outbound trust controls.
- Use it when checking whether the tenant's default trust posture matches the approved baseline.

## File Scope
- `terraform/cross-tenant-access.tf`

## Provider Selection
- Use `msgraph_resource` for the `policies/crossTenantAccessPolicy` API; the AzureAD provider does not cover the default policy configuration at the same level.
- Keep the resource name and Graph path aligned with the tenant policy object.

## Required Microsoft Graph Application Permissions
- `Policy.Read.All`
- `Policy.ReadWrite.CrossTenantAccess`

## Resources Covered
- `msgraph_resource.cross_tenant_access_policy_default`

## Guardrails
- Start from a restrictive default posture and add trust only where business need is explicit.
- Keep inbound/outbound collaboration and direct connect settings aligned to least privilege and zero trust.
- Preserve clear separation between trusted external access and safe default-deny behavior.
- Do not hardcode secrets, credentials, or tenant IDs in Terraform configuration.
