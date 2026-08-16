# terraform-named-locations-permissions

**Description:** Lists Microsoft Graph application permissions required by `terraform/named-locations.tf`.

## Purpose
Use this skill when validating or troubleshooting permissions for named location resources.

## File Scope
- `terraform/named-locations.tf`

## Provider Selection
Use `azuread_named_location` for named locations. Use `msgraph_resource` only when AzureAD does not support the required named-location capability, and migrate state before changing an existing resource type.

## Required Microsoft Graph Application Permissions
- `Policy.Read.All`
- `Policy.ReadWrite.ConditionalAccess`

## Resources Covered
- `azuread_named_location.named_location_restricted_signin`