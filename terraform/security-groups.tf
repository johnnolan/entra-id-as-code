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
