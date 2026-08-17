# Tenant organisation settings

This file adopts the Microsoft Entra organisation singleton and manages its notification contact collections.

## `current`

The `azuread_client_config.current` data source reads the active tenant ID. Terraform uses it to construct the fixed organisation import path.

## `tenant_details`

Manages the tenant's organisation object through Microsoft Graph because AzureAD has no typed resource for these notification properties.

- `marketingNotificationEmails = []` clears marketing notification recipients.
- `securityComplianceNotificationMails = []` clears security and compliance email recipients.
- `securityComplianceNotificationPhones = []` clears security and compliance phone recipients.
- `technicalNotificationMails = []` clears technical notification recipients.

> **Security consideration:** Empty security and technical contact collections can leave operational notifications without a recipient. Add monitored team addresses or phone contacts if the organisation relies on these Microsoft notifications.

## Import

The import block adopts `organization/<tenant-id>`. Microsoft Graph exposes the organisation as exactly one record, whose ID is also the tenant ID.

## Required permissions

The Terraform service principal needs the Microsoft Graph application permission:

- `Organization.ReadWrite.All`

Microsoft documents this as the least-privileged application permission for updating the organisation object.

## Maester coverage

No current Maester test directly checks these organisation notification collections.

## Resources

### Microsoft articles

- [organization resource type](https://learn.microsoft.com/en-us/graph/api/resources/organization)
- [Update organization](https://learn.microsoft.com/en-us/graph/api/organization-update)
- [Microsoft Graph permissions reference](https://learn.microsoft.com/en-us/graph/permissions-reference)
