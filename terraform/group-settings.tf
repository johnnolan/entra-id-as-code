# Microsoft Graph Application Permission: Directory.ReadWrite.All
resource "msgraph_resource" "group_lifecycle_policy" {
  url = "groupLifecyclePolicies"
  body = {
    # Sends lifecycle notifications to this address when group expiration or renewal events occur.
    alternateNotificationEmails = "me@johnnolan.dev"
    # Sets the default maximum age for groups before they require review or renewal in Entra.
    groupLifetimeInDays = 170
    # Allows the lifecycle policy to apply to all group types in the tenant.
    managedGroupTypes = "All"
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
    # Identifies the default Azure Active Directory group settings template used for this policy.
    templateId = "62375ab9-6b52-47ed-826b-58e47e0e304b"
    # Defines the group creation and governance settings that control how Entra manages collaboration and guest access.
    values = [
      # Prevents users from creating new groups in the tenant unless an exception is added.
      { name = "EnableGroupCreation", value = "false" },
      # Blocks guests from owning groups to reduce risk from unmanaged or external administrators.
      { name = "AllowGuestsToBeGroupOwner", value = "false" },
      # Prevents guests from accessing directory groups by default.
      { name = "AllowGuestsToAccessGroups", value = "false" },
      # Enables writeback for unified groups to support the default Microsoft 365 collaboration model.
      { name = "NewUnifiedGroupWritebackDefault", value = "true" },
      # Disables Microsoft Information Protection labels for group content classifications.
      { name = "EnableMIPLabels", value = "false" },
      # Leaves the custom blocked word list empty because the tenant is not using a custom list.
      { name = "CustomBlockedWordsList", value = "" },
      # Disables the built-in Microsoft blocked words list for group naming guidance.
      { name = "EnableMSStandardBlockedWords", value = "false" },
      # Leaves classification descriptions empty so the tenant does not define custom group classifications.
      { name = "ClassificationDescriptions", value = "" },
      # Leaves the default classification blank to avoid automatic classification assignment.
      { name = "DefaultClassification", value = "" },
      # Leaves an explicit naming prefix/suffix policy blank so group names are not restricted by default.
      { name = "PrefixSuffixNamingRequirement", value = "" },
      # Leaves the guest usage guidelines URL blank because no custom guest guidance is configured.
      { name = "GuestUsageGuidelinesUrl", value = "" },
      # Leaves the permitted group ID for group creation empty because the tenant does not allow a custom group-based exception.
      { name = "GroupCreationAllowedGroupId", value = "" },
      # Disables the option to add guests to the group by default.
      { name = "AllowToAddGuests", value = "false" },
      # Leaves the general usage guidelines URL blank because no tenant-specific guidance is configured.
      { name = "UsageGuidelinesUrl", value = "" },
      # Leaves the classification list empty because this tenant is not using custom classifications.
      { name = "ClassificationList", value = "" },
    ]
  }
  response_export_values = {
    id = "id"
  }
}
