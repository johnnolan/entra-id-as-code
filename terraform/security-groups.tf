# Microsoft Graph Application Permission: Directory.ReadWrite.All
resource "msgraph_resource" "group_lifecycle_policy" {
  url = "groupLifecyclePolicies"
  body = {
    alternateNotificationEmails = "me@johnnolan.dev"
    groupLifetimeInDays         = 170
    managedGroupTypes           = "All"
  }
  response_export_values = {
    id = "id"
  }
}

# If existing group lifecycle policy is created outside Terraform, import it with:
# terraform import msgraph_resource.group_lifecycle_policy groupLifecyclePolicies/<GROUP_LIFECYCLE_POLICY_ID>

# Microsoft Graph Application Permission: GroupSettings.ReadWrite.All
resource "msgraph_resource" "groups_settings" {
  url = "groupSettings"
  body = {
    templateId = "62375ab9-6b52-47ed-826b-58e47e0e304b"
    values = [
      { name = "EnableGroupCreation", value = "false" },
      { name = "AllowGuestsToBeGroupOwner", value = "false" },
      { name = "AllowGuestsToAccessGroups", value = "false" },
    ]
  }
  response_export_values = {
    id = "id"
  }
}

# Import only when an existing Group.Unified setting already exists:
# terraform import msgraph_resource.groups_settings groupSettings/<GROUPS_SETTINGS_ID>

# Microsoft Graph Application Permission: Group.ReadWrite.All
resource "msgraph_resource" "cap_excluded_from_conditional_access" {
  url = "groups"
  body = {
    displayName     = "CAP-Excluded from Conditional Access"
    description     = "Excluded users from Conditional Access rules."
    securityEnabled = true
    mailEnabled     = false
    mailNickname    = "ExcludedfromConditionalAccess"
    groupTypes      = []
  }
  response_export_values = {
    id = "id"
  }
}
