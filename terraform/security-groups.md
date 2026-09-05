# Security groups

This guide covers the Azure AD security group resources in [terraform/security-groups.tf](terraform/security-groups.tf):

- `azuread_group.cap_excluded_from_conditional_access`
- `azuread_group.sec_guest_users`
- `azuread_group.ap_example_users`

These are normal Entra security groups and dynamic membership groups, not the Graph group lifecycle or group settings policies.

## What these resources do

- `cap_excluded_from_conditional_access` creates a security group used to exclude users from Conditional Access policies.
- `sec_guest_users` creates a dynamic group containing guest users only, which is useful for scoping authentication methods or access controls.
- `ap_example_users` creates an example entitlement group for access package testing or demonstration scenarios.

These resources can be created from scratch and imported by object ID only if they already exist in the tenant.

## Import existing groups

To adopt an existing Azure AD group in Terraform, get the object ID and run:

```bash
az ad group list --group "CAP-Excluded from Conditional Access" --query "[0].id" -o tsv
az ad group list --group "SEC-Guest Users" --query "[0].id" -o tsv
az ad group list --group "AP-Example Users" --query "[0].id" -o tsv
```

Then import them:

```bash
terraform import azuread_group.cap_excluded_from_conditional_access <GROUP_OBJECT_ID>
terraform import azuread_group.sec_guest_users <GROUP_OBJECT_ID>
terraform import azuread_group.ap_example_users <GROUP_OBJECT_ID>
```

## Terraform behavior in this repository

In [terraform/security-groups.tf](terraform/security-groups.tf):

- These are AzureAD typed resources because the AzureAD provider supports security groups directly.
- They are ideal for Microsoft Entra group objects that need consistent Terraform lifecycle management.
- The Graph-based settings and lifecycle policies are intentionally kept in [terraform/group-settings.tf](terraform/group-settings.tf) because they are not AzureAD group resources.

## Related file

- [terraform/group-settings.md](terraform/group-settings.md) covers the tenant-wide group lifecycle and Group.Unified settings policy objects.
