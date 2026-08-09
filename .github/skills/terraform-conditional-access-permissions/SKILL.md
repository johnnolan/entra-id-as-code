# terraform-conditional-access-permissions

**Description:** Lists Microsoft Graph application permissions required by `terraform/conditional-access.tf`.

## Purpose
Use this skill when validating or troubleshooting permissions for conditional access resources in this repository.

## File Scope
- `terraform/conditional-access.tf`

## Required Microsoft Graph Application Permissions
- `Policy.Read.All`
- `Policy.ReadWrite.ConditionalAccess`

## Resources Covered
- `msgraph_resource.ca_1010_block_legacy_auth`

## Notes
- Additional commented resources in the file would use the same conditional access permission set when enabled.