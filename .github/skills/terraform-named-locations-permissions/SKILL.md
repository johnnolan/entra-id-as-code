# terraform-named-locations-permissions

**Description:** Lists Microsoft Graph application permissions required by `terraform/named-locations.tf`.

## Purpose
Use this skill when validating or troubleshooting permissions for named location resources.

## File Scope
- `terraform/named-locations.tf`

## Required Microsoft Graph Application Permissions
- `Policy.Read.All`
- `Policy.ReadWrite.ConditionalAccess`

## Resources Covered
- `msgraph_resource.named_location_restricted_signin`