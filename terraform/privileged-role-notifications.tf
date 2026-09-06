# Microsoft Graph Application Permissions: RoleManagementPolicy.ReadWrite.Directory, RoleManagement.Read.Directory
locals {
  pim_role_activation_alert_roles = {
    global_administrator = {
      role_id    = "62e90394-69f5-4237-9190-012177145e10"
      recipients = var.pim_global_admin_activation_alert_recipients
    }
    user_administrator = {
      role_id    = "fe930be7-5e62-47db-91af-98c3a49a38b1"
      recipients = var.pim_privileged_role_activation_alert_recipients
    }
    exchange_administrator = {
      role_id    = "29232cdf-9323-42fd-ade2-1d097af3e4de"
      recipients = var.pim_privileged_role_activation_alert_recipients
    }
    sharepoint_administrator = {
      role_id    = "f28a1f50-f6e7-4571-818b-6a12f2af6b6c"
      recipients = var.pim_privileged_role_activation_alert_recipients
    }
    application_administrator = {
      role_id    = "9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3"
      recipients = var.pim_privileged_role_activation_alert_recipients
    }
    privileged_role_administrator = {
      role_id    = "e8611ab8-c189-46e8-94e1-60213ab1f814"
      recipients = var.pim_privileged_role_activation_alert_recipients
    }
    cloud_application_administrator = {
      role_id    = "158c047a-c907-4556-b7ef-446551a6b5f7"
      recipients = var.pim_privileged_role_activation_alert_recipients
    }
    hybrid_identity_administrator = {
      role_id    = "8ac3fc64-6eca-42ea-9e69-59f4c7b60eb2"
      recipients = var.pim_privileged_role_activation_alert_recipients
    }
  }
}

# Looks up the PIM policy bound to each built-in directory role at tenant scope.
data "msgraph_resource" "role_management_policy_assignment" {
  for_each = local.pim_role_activation_alert_roles

  url = "policies/roleManagementPolicyAssignments"
  query_parameters = {
    "$filter" = ["scopeId eq '/' and scopeType eq 'DirectoryRole' and roleDefinitionId eq '${each.value.role_id}'"]
  }
  response_export_values = {
    policy_id = "value[0].policyId"
  }
}

# Updates the built-in "Role activation alert" notification rule to add the security monitoring mailbox.
resource "msgraph_resource" "role_activation_alert" {
  for_each = local.pim_role_activation_alert_roles

  url = "policies/roleManagementPolicies/${data.msgraph_resource.role_management_policy_assignment[each.key].output.policy_id}/rules"
  body = {
    "@odata.type"              = "#microsoft.graph.unifiedRoleManagementPolicyNotificationRule"
    id                         = "Notification_Admin_EndUser_Assignment"
    notificationType           = "Email"
    recipientType              = "Admin"
    notificationLevel          = "All"
    isDefaultRecipientsEnabled = true
    notificationRecipients     = each.value.recipients
  }
}

import {
  for_each = local.pim_role_activation_alert_roles
  to       = msgraph_resource.role_activation_alert[each.key]
  id       = "policies/roleManagementPolicies/${data.msgraph_resource.role_management_policy_assignment[each.key].output.policy_id}/rules/Notification_Admin_EndUser_Assignment"
}
