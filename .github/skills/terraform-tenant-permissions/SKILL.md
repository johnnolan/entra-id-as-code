# terraform-tenant-permissions

**Description:** Lists Microsoft Graph application permissions required by `terraform/tenant.tf`.

## Purpose
Use this skill when validating or troubleshooting permissions for organization settings resources.

## File Scope
- `terraform/tenant.tf`

## Provider Selection
Use an AzureAD typed resource where it supports the required organization property. `tenant_details` remains `msgraph_resource` because AzureAD has no equivalent organization-settings resource.

## Required Microsoft Graph Application Permissions
- `Organization.ReadWrite.All`

## Resources Covered
- `msgraph_resource.tenant_details`