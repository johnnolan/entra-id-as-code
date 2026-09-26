---
name: terraform-group-settings-permissions
description: Trigger when creating, reviewing, or modifying group settings and lifecycle configuration in terraform/group-settings.tf; validate the Graph application permissions and provider choice used for tenant-wide group governance.
compatibility: Requires terraform, azuread provider ~> 3.0, and msgraph provider ~> 0.4
---

# terraform-group-settings-permissions

## When To Use
- Apply this skill for any change to `terraform/group-settings.tf`.
- Use it when validating or troubleshooting group lifecycle policies or tenant-wide group settings.
- Use it when checking whether a change should stay as `msgraph_resource` or be moved to an AzureAD typed resource.

## File Scope
- `terraform/group-settings.tf`

## Provider Selection
- Use `msgraph_resource` for the tenant group lifecycle and group settings APIs because AzureAD does not expose a typed resource for these Graph endpoints.
- Use `azuread_group` only for actual group objects created in the tenant.
- Migrate Terraform state before changing an existing resource type.

## Required Microsoft Graph Application Permissions
- `Directory.ReadWrite.All`
- `GroupSettings.ReadWrite.All`

## Resources Covered
- `msgraph_resource.group_lifecycle_policy`
- `msgraph_resource.groups_settings`

## Guardrails
- Keep tenant-level group governance changes explicit and minimal.
- Prefer smallest safe policy scope for lifecycle and guest access controls.
- Avoid hardcoded tenant IDs, client secrets, or credentials in the Terraform file.
- Preserve import blocks where the resource targets a fixed pre-existing Graph object.
