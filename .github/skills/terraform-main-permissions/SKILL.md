# terraform-main-permissions

**Description:** Describes permission context for `terraform/main.tf`.

## Purpose
Use this skill to understand provider and backend configuration scope.

## File Scope
- `terraform/main.tf`

## Required Microsoft Graph Application Permissions
- No direct Graph resource operations are defined in this file.

## Notes
- This file configures providers and backend only.
- Effective permissions are required by resource files that use the providers.
- Resource skills must prefer AzureAD typed resources and use Microsoft Graph only where AzureAD lacks the required support.