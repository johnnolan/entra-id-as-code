# Policies pulled from https://danielchronlund.com/2020/11/26/azure-ad-conditional-access-policy-design-baseline-with-automatic-deployment-support/
# Microsoft Graph Application Permissions: Policy.Read.All, Policy.ReadWrite.ConditionalAccess
# Note: Policies that define an `applications` condition also require `Application.Read.All`.
resource "azuread_conditional_access_policy" "ca_1010_block_legacy_auth" {
  depends_on = [
    azuread_group.cap_excluded_from_conditional_access,
    azuread_named_location.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  display_name = "GLOBAL - 1010 - BLOCK - Legacy Authentication"
  state        = "enabled"

  conditions {
    client_app_types = ["exchangeActiveSync", "other"]
    applications {
      included_applications = ["All"]
    }
    users {
      included_users = ["All"]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
}

resource "azuread_conditional_access_policy" "ca_1020_block_device_code_flow" {
  depends_on = [
    azuread_group.cap_excluded_from_conditional_access,
    azuread_named_location.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  display_name = "GLOBAL - 1020 - BLOCK - Device Code Auth Flow"
  state        = "enabled"

  conditions {
    client_app_types                     = ["all"]
    authentication_flow_transfer_methods = ["deviceCodeFlow", "authenticationTransfer"]
    applications {
      included_applications = ["All"]
    }
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cap_excluded_from_conditional_access.object_id]
    }
  }
  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
}

resource "azuread_conditional_access_policy" "ca_1050_block_high_risk_countries" {
  depends_on = [
    azuread_group.cap_excluded_from_conditional_access,
    azuread_named_location.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  display_name = "GLOBAL - 1050 - BLOCK - High-Risk Countries"
  state        = "enabled"

  conditions {
    client_app_types = ["all"]
    applications {
      included_applications = ["All"]
    }
    users {
      included_users = ["All"]
    }
    locations {
      included_locations = ["All"]
      excluded_locations = [azuread_named_location.named_location_restricted_signin.object_id]
    }
  }
  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
}

resource "azuread_conditional_access_policy" "ca_1070_block_explicitly_blocked_apps" {
  depends_on = [
    azuread_group.cap_excluded_from_conditional_access,
    azuread_named_location.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  display_name = "GLOBAL - 1070 - BLOCK - Explicitly Blocked Cloud Apps"
  state        = "enabled"

  conditions {
    client_app_types = ["all"]
    applications {
      included_applications = ["None"]
    }
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cap_excluded_from_conditional_access.object_id]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
}

resource "azuread_conditional_access_policy" "ca_1080_block_non_admin_sensitive_apps" {
  depends_on = [
    azuread_group.cap_excluded_from_conditional_access,
    azuread_named_location.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  display_name = "GLOBAL - 1080 - BLOCK - Non-Admin Access to Sensitive Apps"
  state        = "enabled"

  conditions {
    client_app_types = ["all"]
    applications {
      included_applications = ["797f4846-ba00-4fd7-ba43-dac1f8f63013", "MicrosoftAdminPortals"]
    }
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cap_excluded_from_conditional_access.object_id]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
}

resource "azuread_conditional_access_policy" "ca_1085_block_sensitive_apps_untrusted_locations" {
  depends_on = [
    azuread_group.cap_excluded_from_conditional_access,
    azuread_named_location.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  display_name = "GLOBAL - 1085 - BLOCK - Access to Sensitive Apps from untrusted locations"
  state        = "enabled"

  conditions {
    client_app_types = ["all"]
    applications {
      included_applications = ["MicrosoftAdminPortals", "Office365"]
    }
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cap_excluded_from_conditional_access.object_id]
    }
    locations {
      included_locations = ["All"]
      excluded_locations = [azuread_named_location.named_location_restricted_signin.object_id]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
}

resource "azuread_conditional_access_policy" "ca_1088_block_sensitive_apps_noncompliant_devices" {
  depends_on = [
    azuread_group.cap_excluded_from_conditional_access,
    azuread_named_location.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  display_name = "GLOBAL - 1088 - BLOCK - Access to Sensitive Apps from non-compliant devices"
  state        = "enabled"

  conditions {
    client_app_types = ["all"]
    applications {
      included_applications = ["MicrosoftAdminPortals", "Office365"]
    }
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cap_excluded_from_conditional_access.object_id]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["compliantDevice"]
  }
}

resource "azuread_conditional_access_policy" "ca_1090_block_high_risk_signins" {
  depends_on = [
    azuread_group.cap_excluded_from_conditional_access,
    azuread_named_location.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  display_name = "GLOBAL - 1090 - BLOCK - High-Risk Sign-Ins"
  state        = "enabled"

  conditions {
    client_app_types    = ["all"]
    sign_in_risk_levels = ["high"]
    applications {
      included_applications = ["All"]
    }
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cap_excluded_from_conditional_access.object_id]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
}

resource "azuread_conditional_access_policy" "ca_1100_block_high_risk_users" {
  depends_on = [
    azuread_group.cap_excluded_from_conditional_access,
    azuread_named_location.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  display_name = "GLOBAL - 1100 - BLOCK - High-Risk Users"
  state        = "enabled"

  conditions {
    client_app_types = ["all"]
    user_risk_levels = ["high"]
    applications {
      included_applications = ["All"]
    }
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cap_excluded_from_conditional_access.object_id]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
}

resource "azuread_conditional_access_policy" "ca_1110_block_o365_insider_risk" {
  depends_on = [
    azuread_group.cap_excluded_from_conditional_access,
    azuread_named_location.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  display_name = "GLOBAL - 1110 - BLOCK - Access to Office365 apps for users with insider risk"
  state        = "enabled"

  conditions {
    client_app_types    = ["all"]
    insider_risk_levels = "elevated"
    applications {
      included_applications = ["Office365"]
    }
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cap_excluded_from_conditional_access.object_id]
      excluded_guests_or_external_users {
        guest_or_external_user_types = ["b2bDirectConnectUser", "otherExternalUser", "serviceProvider"]
        external_tenants {
          membership_kind = "all"
        }
      }
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
}

# MT.1011: blocks registering security info (MFA/passwordless methods) from outside the trusted location.
resource "azuread_conditional_access_policy" "ca_1120_block_security_info_registration_untrusted_locations" {
  depends_on = [
    azuread_group.cap_excluded_from_conditional_access,
    azuread_named_location.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  display_name = "GLOBAL - 1120 - BLOCK - Security Info Registration from Untrusted Locations"
  state        = "enabled"

  conditions {
    client_app_types = ["all"]
    applications {
      included_user_actions = ["urn:user:registersecurityinfo"]
    }
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cap_excluded_from_conditional_access.object_id]
    }
    locations {
      included_locations = ["All"]
      excluded_locations = [azuread_named_location.named_location_restricted_signin.object_id]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
}

resource "azuread_conditional_access_policy" "ca_2010_grant_medium_risk_signins" {
  depends_on = [
    azuread_group.cap_excluded_from_conditional_access,
    azuread_named_location.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  display_name = "GLOBAL - 2010 - GRANT - Medium and High-Risk Sign-Ins"
  state        = "enabled"

  conditions {
    client_app_types = ["all"]
    # Includes "high" alongside "medium" for MT.1012; ca_1090 already blocks high-risk sign-ins outright, so this grant is a redundant backstop, not a loosening.
    sign_in_risk_levels = ["medium", "high"]
    applications {
      included_applications = ["All"]
    }
    # Break-glass accounts are not excluded so they remain subject to this MFA requirement.
    users {
      included_users = ["All"]
    }
  }

  grant_controls {
    operator                          = "OR"
    authentication_strength_policy_id = azuread_authentication_strength_policy.passwordless_mfa.id
  }

  session_controls {
    sign_in_frequency_interval = "everyTime"
  }
}

resource "azuread_conditional_access_policy" "ca_2020_grant_medium_risk_users" {
  depends_on = [
    azuread_group.cap_excluded_from_conditional_access,
    azuread_named_location.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  display_name = "GLOBAL - 2020 - GRANT - Medium-Risk Users"
  state        = "enabled"

  conditions {
    client_app_types = ["all"]
    user_risk_levels = ["medium"]
    applications {
      included_applications = ["All"]
    }
    # Break-glass accounts are not excluded so they remain subject to this MFA requirement.
    users {
      included_users = ["All"]
    }
  }

  grant_controls {
    operator                          = "OR"
    authentication_strength_policy_id = azuread_authentication_strength_policy.passwordless_mfa.id
  }

  session_controls {
    sign_in_frequency_interval = "everyTime"
  }
}

# MT.1013: requires a self-remediating password change (plus MFA) for high user risk; ca_1100 still blocks the same condition outright.
resource "azuread_conditional_access_policy" "ca_2025_grant_password_change_high_risk_users" {
  depends_on = [
    azuread_group.cap_excluded_from_conditional_access,
    azuread_named_location.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  display_name = "GLOBAL - 2025 - GRANT - Password Change for High-Risk Users"
  state        = "enabled"

  conditions {
    client_app_types = ["all"]
    user_risk_levels = ["high"]
    applications {
      included_applications = ["All"]
    }
    # Break-glass accounts are not excluded so they remain subject to this requirement.
    users {
      included_users = ["All"]
    }
  }

  grant_controls {
    operator          = "AND"
    built_in_controls = ["mfa", "passwordChange"]
  }
}

resource "azuread_conditional_access_policy" "ca_2050_grant_mfa_all_users" {
  depends_on = [
    azuread_group.cap_excluded_from_conditional_access,
    azuread_named_location.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  display_name = "GLOBAL - 2050 - GRANT - MFA for All Users"
  state        = "enabled"

  conditions {
    client_app_types = ["all"]
    applications {
      included_applications = ["All"]
    }
    # Break-glass accounts are not excluded so they remain subject to this MFA requirement.
    users {
      included_users = ["All"]
      excluded_guests_or_external_users {
        guest_or_external_user_types = ["internalGuest", "b2bCollaborationGuest", "b2bCollaborationMember", "b2bDirectConnectUser", "otherExternalUser", "serviceProvider"]
        external_tenants {
          membership_kind = "all"
        }
      }
    }
  }

  grant_controls {
    operator                          = "OR"
    authentication_strength_policy_id = azuread_authentication_strength_policy.default_mfa.id
  }
}

resource "azuread_conditional_access_policy" "ca_2051_grant_mfa_guest_users" {
  depends_on = [
    azuread_group.cap_excluded_from_conditional_access,
    azuread_named_location.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  display_name = "GLOBAL - 2051 - GRANT - MFA for Guest Users"
  state        = "enabled"

  conditions {
    client_app_types = ["all"]
    applications {
      included_applications = ["All"]
    }
    # Break-glass accounts are not excluded so they remain subject to this MFA requirement.
    users {
      included_guests_or_external_users {
        guest_or_external_user_types = ["internalGuest", "b2bCollaborationGuest", "b2bCollaborationMember", "b2bDirectConnectUser", "otherExternalUser", "serviceProvider"]
        external_tenants {
          membership_kind = "all"
        }
      }
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["mfa"]
  }
}

# CISA.MS.AAD.3.6: role-scoped backup control, independent of the all-users policy (ca_2060).
resource "azuread_conditional_access_policy" "ca_2055_grant_phishing_resistant_mfa_admins" {
  depends_on = [
    azuread_group.cap_excluded_from_conditional_access,
    azuread_named_location.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  display_name = "GLOBAL - 2055 - GRANT - Phishing Resistant MFA for Admins"
  state        = "enabled"

  conditions {
    client_app_types = ["all"]
    applications {
      included_applications = ["All"]
    }
    # Break-glass accounts are not excluded so they remain subject to this MFA requirement.
    # CISA highly-privileged roles: Global Administrator, Privileged Role Administrator, User Administrator,
    # SharePoint Administrator, Exchange Administrator, Hybrid Identity Administrator, Application Administrator,
    # Cloud Application Administrator.
    users {
      included_roles = [
        "62e90394-69f5-4237-9190-012177145e10", # Global Administrator
        "e8611ab8-c189-46e8-94e1-60213ab1f814", # Privileged Role Administrator
        "fe930be7-5e62-47db-91af-98c3a49a38b1", # User Administrator
        "f28a1f50-f6e7-4571-818b-6a12f2af6b6c", # SharePoint Administrator
        "29232cdf-9323-42fd-ade2-1d097af3e4de", # Exchange Administrator
        "8ac3fc64-6eca-42ea-9e69-59f4c7b60eb2", # Hybrid Identity Administrator
        "9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3", # Application Administrator
        "158c047a-c907-4556-b7ef-446551a6b5f7", # Cloud Application Administrator
      ]
    }
  }

  grant_controls {
    operator                          = "OR"
    authentication_strength_policy_id = azuread_authentication_strength_policy.phishing_resistant_mfa.id
  }
}

# CISA.MS.AAD.3.1: enforced; all users confirmed enrolled with Authenticator passkeys.
resource "azuread_conditional_access_policy" "ca_2060_grant_phishing_resistant_mfa_all_users" {
  depends_on = [
    azuread_group.cap_excluded_from_conditional_access,
    azuread_named_location.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  display_name = "GLOBAL - 2060 - GRANT - Phishing Resistant MFA for All Users"
  state        = "enabled"

  conditions {
    client_app_types = ["all"]
    applications {
      included_applications = ["All"]
    }
    # Break-glass accounts are not excluded so they remain subject to this MFA requirement.
    users {
      included_users = ["All"]
      excluded_guests_or_external_users {
        guest_or_external_user_types = ["internalGuest", "b2bCollaborationGuest", "b2bCollaborationMember", "b2bDirectConnectUser", "otherExternalUser", "serviceProvider"]
        external_tenants {
          membership_kind = "all"
        }
      }
      excluded_groups = [azuread_group.cap_excluded_from_conditional_access.object_id]
    }
  }

  grant_controls {
    operator                          = "OR"
    authentication_strength_policy_id = azuread_authentication_strength_policy.phishing_resistant_mfa.id
  }
}

resource "azuread_conditional_access_policy" "ca_3020_session_guest_persistent_browser" {
  depends_on = [
    azuread_group.cap_excluded_from_conditional_access,
    azuread_named_location.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  display_name = "GLOBAL - 3020 - SESSION - Guest Users All Apps Persistent Browser"
  state        = "enabled"

  conditions {
    client_app_types = ["all"]
    applications {
      included_applications = ["All"]
    }
    users {
      excluded_groups = [azuread_group.cap_excluded_from_conditional_access.object_id]
      included_guests_or_external_users {
        guest_or_external_user_types = ["internalGuest", "b2bCollaborationGuest", "b2bCollaborationMember", "b2bDirectConnectUser", "otherExternalUser", "serviceProvider"]
        external_tenants {
          membership_kind = "all"
        }
      }
    }
  }

  session_controls {
    persistent_browser_mode = "never"
  }
}

resource "azuread_conditional_access_policy" "ca_3025_session_guest_signin_frequency" {
  depends_on = [
    azuread_group.cap_excluded_from_conditional_access,
    azuread_named_location.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  display_name = "GLOBAL - 3025 - SESSION - Guest Users All Apps Sign-in Frequency"
  state        = "enabled"

  conditions {
    client_app_types = ["all"]
    applications {
      included_applications = ["All"]
    }
    users {
      excluded_groups = [azuread_group.cap_excluded_from_conditional_access.object_id]
      included_guests_or_external_users {
        guest_or_external_user_types = ["internalGuest", "b2bCollaborationGuest", "b2bCollaborationMember", "b2bDirectConnectUser", "otherExternalUser", "serviceProvider"]
        external_tenants {
          membership_kind = "all"
        }
      }
    }
  }

  session_controls {
    sign_in_frequency        = 12
    sign_in_frequency_period = "hours"
  }
}

resource "msgraph_resource" "ca_3040_session_continuous_access_evaluation" {
  depends_on = [
    azuread_group.cap_excluded_from_conditional_access,
    azuread_named_location.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  url         = "identity/conditionalAccess/policies"
  api_version = "beta"
  body = {
    displayName = "GLOBAL - 3040 - SESSION - Continuous Access Evaluation"
    state       = "enabled"
    conditions = {
      users = {
        includeUsers  = ["All"]
        excludeGroups = [azuread_group.cap_excluded_from_conditional_access.object_id]
      }
      applications = {
        includeApplications = ["All"]
      }
      clientAppTypes = ["all"]
    }
    sessionControls = {
      continuousAccessEvaluation = {
        mode = "strictLocation"
      }
    }
  }
  response_export_values = {
    id = "id"
  }
}
