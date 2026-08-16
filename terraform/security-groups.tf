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
      { name = "NewUnifiedGroupWritebackDefault", value = "true" },
      { name = "EnableMIPLabels", value = "false" },
      { name = "CustomBlockedWordsList", value = "" },
      { name = "EnableMSStandardBlockedWords", value = "false" },
      { name = "ClassificationDescriptions", value = "" },
      { name = "DefaultClassification", value = "" },
      { name = "PrefixSuffixNamingRequirement", value = "" },
      { name = "GuestUsageGuidelinesUrl", value = "" },
      { name = "GroupCreationAllowedGroupId", value = "" },
      { name = "AllowToAddGuests", value = "true" },
      { name = "UsageGuidelinesUrl", value = "" },
      { name = "ClassificationList", value = "" },
    ]
  }
  response_export_values = {
    id = "id"
  }
}

# Import only when an existing Group.Unified setting already exists:
# terraform import msgraph_resource.groups_settings groupSettings/<GROUPS_SETTINGS_ID>

# Microsoft Graph Application Permission: Group.ReadWrite.All
resource "azuread_group" "cap_excluded_from_conditional_access" {
  display_name     = "CAP-Excluded from Conditional Access"
  description      = "Excluded users from Conditional Access rules."
  security_enabled = true
  mail_enabled     = false
  mail_nickname    = "ExcludedfromConditionalAccess"
  types            = []
}

# Microsoft Graph Application Permission: Group.ReadWrite.All
resource "azuread_group" "sec_guest_users" {
  display_name     = "SEC-Guest Users"
  description      = "Dynamic membership of all guest/external users, for scoping authentication methods."
  security_enabled = true
  mail_enabled     = false
  mail_nickname    = "SECGuestUsers"
  types            = ["DynamicMembership"]

  dynamic_membership {
    enabled = true
    rule    = "(user.userType -eq \"Guest\")"
  }
}

# Microsoft Graph Application Permission: Group.ReadWrite.All
resource "azuread_group" "ap_example_users" {
  display_name     = "AP-Example Users"
  description      = "Example entitlement group managed through an access package."
  security_enabled = true
  mail_enabled     = false
  mail_nickname    = "APExampleUsers"
}
