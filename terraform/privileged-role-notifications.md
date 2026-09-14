# Privileged role activation notifications

This file configures three Privileged Identity Management (PIM) notification rules for Global Administrator and seven other highly privileged built-in directory roles: activation of an eligible assignment, active (direct) assignment, and eligible assignment, so a security monitoring mailbox is notified for each.

## `role_management_policy_assignment` (data source)

Looks up the PIM policy bound to each role at tenant scope (`scopeId eq '/'`, `scopeType eq 'DirectoryRole'`) via `policies/roleManagementPolicyAssignments`. The returned `policyId` is used to target the correct policy for each role, since policy IDs are tenant-generated and can't be hardcoded.

## `role_activation_alert`

Updates the built-in `Notification_Admin_EndUser_Assignment` rule on each role's policy — the same rule the Microsoft Entra admin center exposes as **Role activation alert** under a role's **Notifications** settings.

- `recipientType = "Admin"` and `notificationType = "Email"` match the rule's fixed identity; only the recipient list and level are configurable.
- `isDefaultRecipientsEnabled = true` keeps Microsoft's built-in default recipients (the role's active admins) in addition to the custom mailbox.
- `notificationRecipients` is supplied per role from `var.pim_global_admin_activation_alert_recipients` (Global Administrator) or `var.pim_privileged_role_activation_alert_recipients` (the other seven roles) — kept as separate variables because the remediation guidance calls for a distinct monitoring mailbox for Global Administrator activations.

## `role_active_assignment_alert` and `role_eligible_assignment_alert`

Update the built-in `Notification_Admin_Admin_Assignment` and `Notification_Admin_Admin_Eligibility` rules — shown in the admin center as the **Role assignment alert** settings for active and eligible assignments respectively. Required for CISA.MS.AAD.7.7 ("Eligible and Active highly privileged role assignments SHALL trigger an alert"), which checks both rules independently of the activation alert above. Same recipient/permission shape as `role_activation_alert`.

### Covered roles

| Role | Template ID |
|---|---|
| Global Administrator | `62e90394-69f5-4237-9190-012177145e10` |
| User Administrator | `fe930be7-5e62-47db-91af-98c3a49a38b1` |
| Exchange Administrator | `29232cdf-9323-42fd-ade2-1d097af3e4de` |
| SharePoint Administrator | `f28a1f50-f6e7-4571-818b-6a12f2af6b6c` |
| Application Administrator | `9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3` |
| Privileged Role Administrator | `e8611ab8-c189-46e8-94e1-60213ab1f814` |
| Cloud Application Administrator | `158c047a-c907-4556-b7ef-446551a6b5f7` |
| Hybrid Identity Administrator | `8ac3fc64-6eca-42ea-9e69-59f4c7b60eb2` |

Template IDs are Microsoft's fixed identifiers for built-in roles and are stable across tenants.

## Import

Each role's three rules are adopted via `import` blocks binding `msgraph_resource.role_activation_alert[each.key]`, `msgraph_resource.role_active_assignment_alert[each.key]`, and `msgraph_resource.role_eligible_assignment_alert[each.key]` to their respective existing rules at `policies/roleManagementPolicies/<policy_id>/rules/<rule_id>`. These rules always exist as part of the built-in policy, so Terraform must adopt them rather than create them.

## Required permissions

The Terraform service principal needs the Microsoft Graph application permissions:

- `RoleManagementPolicy.ReadWrite.Directory`
- `RoleManagement.Read.Directory`

## Maester coverage

- [CISA.MS.AAD.7.7 — Eligible and Active highly privileged role assignments SHALL trigger an alert](https://maester.dev/docs/tests/CISA.MS.AAD.7.7) — validated by `role_active_assignment_alert` and `role_eligible_assignment_alert` across all eight role entries.
- [CISA.MS.AAD.7.8 — User activation of the Global Administrator role SHALL trigger an alert](https://maester.dev/docs/tests/CISA.MS.AAD.7.8) — validated by the `global_administrator` entry in `pim_role_activation_alert_roles`.
- [CISA.MS.AAD.7.9 — User activation of other highly privileged roles SHOULD trigger an alert](https://maester.dev/docs/tests/CISA.MS.AAD.7.9) — validated by the remaining seven role entries.

## Resources

### Microsoft articles

- [unifiedRoleManagementPolicyAssignment resource type](https://learn.microsoft.com/en-us/graph/api/resources/unifiedrolemanagementpolicyassignment)
- [unifiedRoleManagementPolicyNotificationRule resource type](https://learn.microsoft.com/en-us/graph/api/resources/unifiedrolemanagementpolicynotificationrule)
- [Rules in PIM — mapping guide](https://learn.microsoft.com/en-us/graph/identity-governance-pim-rules-overview) — maps `Notification_Admin_EndUser_Assignment` to the admin center's **Role activation alert** setting.
- [Microsoft Entra built-in roles](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/permissions-reference) — source of the role template IDs listed above.
