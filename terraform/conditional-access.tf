variable "authentication_strength_ids" {
  description = "Map of friendly authentication strength policy name -> object ID. Built-in strengths have well-known IDs in most tenants but confirm via GET /policies/authenticationStrengthPolicies."
  type        = map(string)
  default = {
    passwordless_mfa           = "00000000-0000-0000-0000-000000000003"
    multifactor_authentication = "00000000-0000-0000-0000-000000000002"
    phishing_resistant_mfa     = "00000000-0000-0000-0000-000000000004"
  }
}

# Policies pulled from https://danielchronlund.com/2020/11/26/azure-ad-conditional-access-policy-design-baseline-with-automatic-deployment-support/
# Microsoft Graph Application Permissions: Policy.Read.All, Policy.ReadWrite.ConditionalAccess
# Note: Policies that define an `applications` condition also require `Application.Read.All`.
resource "msgraph_resource" "ca_1010_block_legacy_auth" {
  depends_on = [
    msgraph_resource.cap_excluded_from_conditional_access,
    msgraph_resource.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  url = "identity/conditionalAccess/policies"
  body = {
    displayName = "GLOBAL - 1010 - BLOCK - Legacy Authentication"
    state       = "enabled"
    conditions = {
      users = {
        includeUsers  = ["All"]
        excludeGroups = [msgraph_resource.cap_excluded_from_conditional_access.id]
      }
      applications = {
        includeApplications = ["All"]
      }
      clientAppTypes = ["exchangeActiveSync", "other"]
    }
    grantControls = {
      operator        = "OR"
      builtInControls = ["block"]
    }
  }
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_1020_block_device_code_flow" {
  depends_on = [
    msgraph_resource.cap_excluded_from_conditional_access,
    msgraph_resource.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  url = "identity/conditionalAccess/policies"
  body = {
    displayName = "GLOBAL - 1020 - BLOCK - Device Code Auth Flow"
    state       = "enabled"
    conditions = {
      users = {
        includeUsers  = ["All"]
        excludeGroups = [msgraph_resource.cap_excluded_from_conditional_access.id]
      }
      applications = {
        includeApplications = ["All"]
      }
      clientAppTypes = ["all"]
      authenticationFlows = {
        transferMethods = "deviceCodeFlow,authenticationTransfer"
      }
    }
    grantControls = {
      operator        = "OR"
      builtInControls = ["block"]
    }
  }
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_1050_block_high_risk_countries" {
  depends_on = [
    msgraph_resource.cap_excluded_from_conditional_access,
    msgraph_resource.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  url = "identity/conditionalAccess/policies"
  body = {
    displayName = "GLOBAL - 1050 - BLOCK - High-Risk Countries"
    state       = "enabled"
    conditions = {
      users = {
        includeUsers  = ["All"]
        excludeGroups = [msgraph_resource.cap_excluded_from_conditional_access.id]
      }
      applications = {
        includeApplications = ["All"]
      }
      clientAppTypes = ["all"]
      locations = {
        includeLocations = ["All"]
        excludeLocations = [msgraph_resource.named_location_restricted_signin.id]
      }
    }
    grantControls = {
      operator        = "OR"
      builtInControls = ["block"]
    }
  }
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_1070_block_explicitly_blocked_apps" {
  depends_on = [
    msgraph_resource.cap_excluded_from_conditional_access,
    msgraph_resource.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  url = "identity/conditionalAccess/policies"
  body = {
    displayName = "GLOBAL - 1070 - BLOCK - Explicitly Blocked Cloud Apps"
    state       = "enabled"
    conditions = {
      users = {
        includeUsers = ["All"]
        excludeGroups = [
          msgraph_resource.cap_excluded_from_conditional_access.id
        ]
      }
      applications = {
        includeApplications = ["None"]
      }
      clientAppTypes = ["all"]
    }
    grantControls = {
      operator        = "OR"
      builtInControls = ["block"]
    }
  }
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_1080_block_non_admin_sensitive_apps" {
  depends_on = [
    msgraph_resource.cap_excluded_from_conditional_access,
    msgraph_resource.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  url = "identity/conditionalAccess/policies"
  body = {
    displayName = "GLOBAL - 1080 - BLOCK - Non-Admin Access to Sensitive Apps"
    state       = "enabled"
    conditions = {
      users = {
        includeUsers = ["All"]
        excludeGroups = [
          msgraph_resource.cap_excluded_from_conditional_access.id
        ]
      }
      applications = {
        includeApplications = ["797f4846-ba00-4fd7-ba43-dac1f8f63013", "MicrosoftAdminPortals"]
      }
      clientAppTypes = ["all"]
    }
    grantControls = {
      operator        = "OR"
      builtInControls = ["block"]
    }
  }
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_1085_block_sensitive_apps_untrusted_locations" {
  depends_on = [
    msgraph_resource.cap_excluded_from_conditional_access,
    msgraph_resource.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  url = "identity/conditionalAccess/policies"
  body = {
    displayName = "GLOBAL - 1085 - BLOCK - Access to Sensitive Apps from untrusted locations"
    state       = "enabled"
    conditions = {
      users = {
        includeUsers = ["All"]
        excludeGroups = [
          msgraph_resource.cap_excluded_from_conditional_access.id
        ]
      }
      applications = {
        includeApplications = ["MicrosoftAdminPortals", "Office365"]
      }
      clientAppTypes = ["all"]
      locations = {
        includeLocations = ["All"]
        excludeLocations = [msgraph_resource.named_location_restricted_signin.id]
      }
    }
    grantControls = {
      operator        = "OR"
      builtInControls = ["block"]
    }
  }
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_1088_block_sensitive_apps_noncompliant_devices" {
  depends_on = [
    msgraph_resource.cap_excluded_from_conditional_access,
    msgraph_resource.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  url = "identity/conditionalAccess/policies"
  body = {
    displayName = "GLOBAL - 1088 - BLOCK - Access to Sensitive Apps from non-compliant devices"
    state       = "enabledForReportingButNotEnforced"
    conditions = {
      users = {
        includeUsers  = ["All"]
        excludeGroups = [msgraph_resource.cap_excluded_from_conditional_access.id]
      }
      applications = {
        includeApplications = ["MicrosoftAdminPortals", "Office365"]
      }
      clientAppTypes = ["all"]
    }
    grantControls = {
      operator        = "OR"
      builtInControls = ["compliantDevice"]
    }
  }
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_1090_block_high_risk_signins" {
  depends_on = [
    msgraph_resource.cap_excluded_from_conditional_access,
    msgraph_resource.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  url = "identity/conditionalAccess/policies"
  body = {
    displayName = "GLOBAL - 1090 - BLOCK - High-Risk Sign-Ins"
    state       = "enabled"
    conditions = {
      users = {
        includeUsers  = ["All"]
        excludeGroups = [msgraph_resource.cap_excluded_from_conditional_access.id]
      }
      applications = {
        includeApplications = ["All"]
      }
      clientAppTypes   = ["all"]
      signInRiskLevels = ["high"]
    }
    grantControls = {
      operator        = "OR"
      builtInControls = ["block"]
    }
  }
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_1100_block_high_risk_users" {
  depends_on = [
    msgraph_resource.cap_excluded_from_conditional_access,
    msgraph_resource.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  url = "identity/conditionalAccess/policies"
  body = {
    displayName = "GLOBAL - 1100 - BLOCK - High-Risk Users"
    state       = "enabled"
    conditions = {
      users = {
        includeUsers  = ["All"]
        excludeGroups = [msgraph_resource.cap_excluded_from_conditional_access.id]
      }
      applications = {
        includeApplications = ["All"]
      }
      clientAppTypes = ["all"]
      userRiskLevels = ["high"]
    }
    grantControls = {
      operator        = "OR"
      builtInControls = ["block"]
    }
  }
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_1110_block_o365_insider_risk" {
  depends_on = [
    msgraph_resource.cap_excluded_from_conditional_access,
    msgraph_resource.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  url = "identity/conditionalAccess/policies"
  body = {
    displayName = "GLOBAL - 1110 - BLOCK - Access to Office365 apps for users with insider risk"
    state       = "enabled"
    conditions = {
      users = {
        includeUsers  = ["All"]
        excludeUsers  = []
        excludeGroups = [msgraph_resource.cap_excluded_from_conditional_access.id]
        excludeGuestsOrExternalUsers = {
          guestOrExternalUserTypes = "b2bDirectConnectUser,otherExternalUser,serviceProvider"
          externalTenants = {
            membershipKind = "all"
          }
        }
      }
      applications = {
        includeApplications = ["Office365"]
      }
      clientAppTypes    = ["all"]
      insiderRiskLevels = "elevated"
    }
    grantControls = {
      operator        = "OR"
      builtInControls = ["block"]
    }
  }
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_2010_grant_medium_risk_signins" {
  depends_on = [
    msgraph_resource.cap_excluded_from_conditional_access,
    msgraph_resource.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  url = "identity/conditionalAccess/policies"
  body = {
    displayName = "GLOBAL - 2010 - GRANT - Medium-Risk Sign-Ins"
    state       = "enabled"
    conditions = {
      users = {
        includeUsers  = ["All"]
        excludeGroups = [msgraph_resource.cap_excluded_from_conditional_access.id]
      }
      applications = {
        includeApplications = ["All"]
      }
      clientAppTypes   = ["all"]
      signInRiskLevels = ["medium"]
    }
    grantControls = {
      operator = "OR"
      authenticationStrength = {
        id = var.authentication_strength_ids.passwordless_mfa
      }
    }
    sessionControls = {
      signInFrequency = {
        isEnabled         = true
        frequencyInterval = "everyTime"
      }
    }
  }
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_2020_grant_medium_risk_users" {
  depends_on = [
    msgraph_resource.cap_excluded_from_conditional_access,
    msgraph_resource.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  url = "identity/conditionalAccess/policies"
  body = {
    displayName = "GLOBAL - 2020 - GRANT - Medium-Risk Users"
    state       = "enabled"
    conditions = {
      users = {
        includeUsers  = ["All"]
        excludeGroups = [msgraph_resource.cap_excluded_from_conditional_access.id]
      }
      applications = {
        includeApplications = ["All"]
      }
      clientAppTypes = ["all"]
      userRiskLevels = ["medium"]
    }
    grantControls = {
      operator = "OR"
      authenticationStrength = {
        id = var.authentication_strength_ids.passwordless_mfa
      }
    }
    sessionControls = {
      signInFrequency = {
        isEnabled         = true
        frequencyInterval = "everyTime"
      }
    }
  }
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_2050_grant_mfa_all_users" {
  depends_on = [
    msgraph_resource.cap_excluded_from_conditional_access,
    msgraph_resource.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  url = "identity/conditionalAccess/policies"
  body = {
    displayName = "GLOBAL - 2050 - GRANT - MFA for All Users"
    state       = "enabled"
    conditions = {
      users = {
        includeUsers = ["All"]
        excludeGroups = [
          msgraph_resource.cap_excluded_from_conditional_access.id,
        ]
        excludeGuestsOrExternalUsers = {
          guestOrExternalUserTypes = "internalGuest,b2bCollaborationGuest,b2bCollaborationMember,b2bDirectConnectUser,otherExternalUser,serviceProvider"
          externalTenants = {
            membershipKind = "all"
          }
        }
      }
      applications = {
        includeApplications = ["All"]
      }
      clientAppTypes = ["all"]
    }
    grantControls = {
      operator = "OR"
      authenticationStrength = {
        id = var.authentication_strength_ids.multifactor_authentication
      }
    }
  }
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_2051_grant_mfa_guest_users" {
  depends_on = [
    msgraph_resource.cap_excluded_from_conditional_access,
    msgraph_resource.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  url = "identity/conditionalAccess/policies"
  body = {
    displayName = "GLOBAL - 2051 - GRANT - MFA for Guest Users"
    state       = "enabled"
    conditions = {
      users = {
        includeUsers = []
        excludeGroups = [
          msgraph_resource.cap_excluded_from_conditional_access.id,
        ]
        includeGuestsOrExternalUsers = {
          guestOrExternalUserTypes = "internalGuest,b2bCollaborationGuest,b2bCollaborationMember,b2bDirectConnectUser,otherExternalUser,serviceProvider"
        }
      }
      applications = {
        includeApplications = ["All"]
      }
      clientAppTypes = ["all"]
    }
    grantControls = {
      operator        = "OR"
      builtInControls = ["mfa"]
    }
  }
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_2055_grant_phishing_resistant_mfa_admins" {
  depends_on = [
    msgraph_resource.cap_excluded_from_conditional_access,
    msgraph_resource.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  url = "identity/conditionalAccess/policies"
  body = {
    displayName = "GLOBAL - 2055 - GRANT - Phishing Resistant MFA for Admins"
    state       = "enabled"
    conditions = {
      users = {
        includeUsers  = ["All"]
        excludeGroups = [msgraph_resource.cap_excluded_from_conditional_access.id]
      }
      applications = {
        includeApplications = ["MicrosoftAdminPortals", "Office365"]
      }
      clientAppTypes = ["all"]
    }
    grantControls = {
      operator = "OR"
      authenticationStrength = {
        id = var.authentication_strength_ids.phishing_resistant_mfa
      }
    }
  }
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_3020_session_guest_persistent_browser" {
  depends_on = [
    msgraph_resource.cap_excluded_from_conditional_access,
    msgraph_resource.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  url = "identity/conditionalAccess/policies"
  body = {
    displayName = "GLOBAL - 3020 - SESSION - Guest Users All Apps Persistent Browser"
    state       = "enabled"
    conditions = {
      users = {
        excludeGroups = [msgraph_resource.cap_excluded_from_conditional_access.id]
        includeGuestsOrExternalUsers = {
          guestOrExternalUserTypes = "internalGuest,b2bCollaborationGuest,b2bCollaborationMember,b2bDirectConnectUser,otherExternalUser,serviceProvider"
          externalTenants = {
            membershipKind = "all"
          }
        }
      }
      applications = {
        includeApplications = ["All"]
      }
      clientAppTypes = ["all"]
    }
    sessionControls = {
      persistentBrowser = {
        isEnabled = true
        mode      = "never"
      }
    }
  }
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_3025_session_guest_signin_frequency" {
  depends_on = [
    msgraph_resource.cap_excluded_from_conditional_access,
    msgraph_resource.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  url = "identity/conditionalAccess/policies"
  body = {
    displayName = "GLOBAL - 3025 - SESSION - Guest Users All Apps Sign-in Frequency"
    state       = "enabled"
    conditions = {
      users = {
        excludeGroups = [msgraph_resource.cap_excluded_from_conditional_access.id]
        includeGuestsOrExternalUsers = {
          guestOrExternalUserTypes = "internalGuest,b2bCollaborationGuest,b2bCollaborationMember,b2bDirectConnectUser,otherExternalUser,serviceProvider"
          externalTenants = {
            membershipKind = "all"
          }
        }
      }
      applications = {
        includeApplications = ["All"]
      }
      clientAppTypes = ["all"]
    }
    sessionControls = {
      signInFrequency = {
        isEnabled = true
        type      = "hours"
        value     = 12
      }
      persistentBrowser = {
        isEnabled = false
        mode      = "never"
      }
    }
  }
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_3040_session_continuous_access_evaluation" {
  depends_on = [
    msgraph_resource.cap_excluded_from_conditional_access,
    msgraph_resource.named_location_restricted_signin,
    msgraph_resource.security_defaults
  ]
  url = "identity/conditionalAccess/policies"
  body = {
    displayName = "GLOBAL - 3040 - SESSION - Continuous Access Evaluation"
    state       = "enabled"
    conditions = {
      users = {
        includeUsers  = ["All"]
        excludeGroups = [msgraph_resource.cap_excluded_from_conditional_access.id]
      }
      applications = {
        includeApplications = ["All"]
      }
      clientAppTypes = ["all"]
      locations = {
        includeLocations = ["All"]
        excludeLocations = []
      }
    }
    sessionControls = {
      continuousAccessEvaluation = {
        mode = "disabled"
      }
    }
  }
  response_export_values = {
    id = "id"
  }
}
