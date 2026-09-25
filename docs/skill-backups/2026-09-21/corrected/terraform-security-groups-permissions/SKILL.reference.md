---
name: terraform-security-groups-permissions
description: "Lists Microsoft Graph application permissions required by `terraform/security-groups.tf`. Use this skill when validating or troubleshooting permissions for security group resources."
---

# terraform-security-groups-permissions

**Description:** Lists Microsoft Graph application permissions required by `terraform/security-groups.tf`.

## Purpose
Use this skill when validating or troubleshooting permissions for security group resources.

## File Scope
- `terraform/security-groups.tf`

## Provider Selection
Use `azuread_group` for security and dynamic-membership groups. Group lifecycle and tenant-wide settings live in `terraform/group-settings.tf`; their permissions are separate. Check the installed provider schema before selecting a resource. Migrate Terraform state before changing an existing resource type.

## Required Microsoft Graph Application Permissions
- `Group.ReadWrite.All`

## Resources Covered
- `azuread_group.cap_excluded_from_conditional_access`
- `azuread_group.sec_guest_users`
- `azuread_group.ap_example_users`
