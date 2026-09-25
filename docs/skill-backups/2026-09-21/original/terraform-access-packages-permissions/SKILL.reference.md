---
name: terraform-access-packages-permissions
description: Trigger when creating, reviewing, or modifying access package resources in terraform/access-packages.tf; validate the required entitlement-management permissions and AzureAD resource selection.
compatibility: Requires terraform, azuread provider ~> 3.0, and msgraph provider ~> 0.4
---

# terraform-access-packages-permissions

## When To Use
- Apply this skill for any change to `terraform/access-packages.tf`.
- Use it when validating or troubleshooting access package catalogs, packages, or associations.
- Use it when deciding whether a change belongs in the AzureAD typed resources or a Graph-managed resource.

## File Scope
- `terraform/access-packages.tf`

## Provider Selection
- Use the typed AzureAD resources for access package catalog, package, and resource association objects where supported by the provider.
- Keep the design aligned to least privilege and tenant-safe access governance.

## Required Microsoft Graph Application Permissions
- `EntitlementManagement.ReadWrite.All`
- `Group.Read.All`

## Resources Covered
- `azuread_access_package_catalog.example`
- `azuread_access_package.example_users`
- `azuread_access_package_resource_catalog_association.example_users`
- `azuread_access_package_resource_package_association.example_users`

## Guardrails
- Keep access package assignments narrow and purposeful.
- Avoid exposing catalog resources beyond the workflow they enable.
- Ensure access package resources are only linked to approved security groups and catalog scopes.
- Do not hardcode tenant IDs, secret values, or credentials in Terraform.
