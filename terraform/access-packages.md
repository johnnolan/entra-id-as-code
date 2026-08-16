# Access packages

This file provides an AzureAD provider example for an Identity Governance access package. It creates a catalog, an access package, and a security group entitlement.

## `ap_example_users`

Creates the `AP-Example Users` security group in [security-groups.tf](security-groups.tf).

- The access package grants members access to this group.
- The group does not use dynamic membership because an access package manages its membership.

## `example`

Creates an unpublished, internal-only access package catalog.

- `externally_visible = false` prevents external users from discovering catalog packages.
- `published = false` prevents package management activity until the example is deliberately enabled.

## `example_users`

Creates a hidden access package in the example catalog.

- The package grants `Member` access to `AP-Example Users` through the catalog and package resource associations.
- The file does not define an `azuread_access_package_assignment_policy`. No user can request or receive the package until you add an assignment policy.

> **Security requirement**
> Do not publish the catalog or add an assignment policy without defining requestor scope, approval, expiry, and access review requirements.

## Required permission

The Terraform application needs the Microsoft Graph application permission `EntitlementManagement.ReadWrite.All`, with admin consent, to manage the catalog, access package, and resource associations.

## Resources

### Microsoft articles

- [Entitlement management overview](https://learn.microsoft.com/en-us/entra/id-governance/entitlement-management-overview) - explains catalogs, access packages, and assignment policies.

### AzureAD provider documentation

- [Access package catalog](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/access_package_catalog)
- [Access package](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/access_package)
- [Catalog resource association](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/access_package_resource_catalog_association)
- [Access package resource association](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/access_package_resource_package_association)