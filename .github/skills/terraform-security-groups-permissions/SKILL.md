# terraform-security-groups-permissions

**Description:** Lists Microsoft Graph application permissions required by `terraform/security-groups.tf`.

## Purpose
Use this skill when validating or troubleshooting permissions for group lifecycle, group settings, and security group resources.

## File Scope
- `terraform/security-groups.tf`

## Provider Selection
Use `azuread_group` for security and dynamic-membership groups. Use `msgraph_resource` only for group APIs without an AzureAD resource, such as group lifecycle policies and tenant-wide group settings. Migrate Terraform state before changing an existing resource type.

## Required Microsoft Graph Application Permissions
- `Directory.ReadWrite.All`
- `GroupSettings.ReadWrite.All`
- `Group.ReadWrite.All`

## Resources Covered
- `msgraph_resource.group_lifecycle_policy`
- `msgraph_resource.groups_settings`
- `azuread_group.cap_excluded_from_conditional_access`
- `azuread_group.sec_guest_users`