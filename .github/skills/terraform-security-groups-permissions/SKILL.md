# terraform-security-groups-permissions

**Description:** Lists Microsoft Graph application permissions required by `terraform/security-groups.tf`.

## Purpose
Use this skill when validating or troubleshooting permissions for group lifecycle, group settings, and security group resources.

## File Scope
- `terraform/security-groups.tf`

## Required Microsoft Graph Application Permissions
- `Directory.ReadWrite.All`
- `GroupSettings.ReadWrite.All`
- `Group.ReadWrite.All`

## Resources Covered
- `msgraph_resource.group_lifecycle_policy`
- `msgraph_resource.groups_settings`
- `msgraph_resource.cap_excluded_from_conditional_access`