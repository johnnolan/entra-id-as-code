# Cross-tenant access policy

This file manages the default policy for collaboration with external Microsoft Entra organisations.

## `cross_tenant_access_policy_default`

Adopts and configures the tenant singleton at `policies/crossTenantAccessPolicy/default`.

### B2B collaboration

Inbound and outbound B2B collaboration block all users and all applications.

- This is stricter than Microsoft's initial default, which enables B2B collaboration.
- Partner access requires a deliberate organisation-specific configuration before users can collaborate.
- Blocking all outbound applications can affect business workflows, including encrypted email and external application access.

### B2B direct connect

Inbound and outbound B2B direct connect block all users and all applications.

- Direct connect requires a mutual trust relationship between both organisations.
- Keeping the default blocked prevents an unapproved tenant-wide trust relationship.

### Inbound trust

The policy does not trust MFA, compliant-device, or hybrid-joined-device claims from external tenants.

- External identities must satisfy this tenant's applicable Conditional Access requirements.
- Trust should be enabled only for an approved partner after assurance review.

> **Security requirement:** Review cross-tenant sign-in logs and business requirements before changing the default deny policy. Microsoft warns that blocking defaults can interrupt business-critical access.

## Import

The import block adopts the existing singleton:

```text
policies/crossTenantAccessPolicy/default
```

This prevents Terraform from treating the tenant default as a new object.

## Required permissions

The Terraform service principal needs the Microsoft Graph application permission:

- `Policy.ReadWrite.CrossTenantAccess`

## Maester coverage

The current local Maester index has no test that directly verifies default cross-tenant inbound, outbound, or trust settings. Do not map an unrelated Conditional Access test to this resource.

## Resources

### Microsoft articles

- [Cross-tenant access overview](https://learn.microsoft.com/en-us/entra/external-id/cross-tenant-access-overview)
- [crossTenantAccessPolicy resource type](https://learn.microsoft.com/en-us/graph/api/resources/crosstenantaccesspolicy)
- [Update crossTenantAccessPolicy](https://learn.microsoft.com/en-us/graph/api/crosstenantaccesspolicy-update)
