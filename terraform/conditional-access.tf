variable "authentication_strength_ids" {
  description = "Map of friendly authentication strength policy name -> object ID. Built-in strengths have well-known IDs in most tenants but confirm via GET /policies/authenticationStrengthPolicies."
  type        = map(string)
  default = {
    passwordless_mfa           = "00000000-0000-0000-0000-000000000002"
    multifactor_authentication = "00000000-0000-0000-0000-000000000001"
    phishing_resistant_mfa     = "00000000-0000-0000-0000-000000000004"
  }
}

resource "msgraph_resource" "ca_1010_block_legacy_auth" {
  url = "identity/conditionalAccess/policies"
  body = jsonencode({
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
  })
  response_export_values = {
    id = "id"
  }
}
/* 
resource "msgraph_resource" "ca_1020_block_device_code_flow" {
  url = "identity/conditionalAccess/policies"
  body = jsonencode({
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
  })
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_1050_block_high_risk_countries" {
  url = "identity/conditionalAccess/policies"
  body = jsonencode({
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
  })
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_1070_block_explicitly_blocked_apps" {
  url = "identity/conditionalAccess/policies"
  body = jsonencode({
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
  })
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_1080_block_non_admin_sensitive_apps" {
  url = "identity/conditionalAccess/policies"
  body = jsonencode({
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
  })
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_1085_block_sensitive_apps_untrusted_locations" {
  url = "identity/conditionalAccess/policies"
  body = jsonencode({
    displayName = "GLOBAL - 1085 - BLOCK - Access to Sensitive Apps from untrusted locations"
    state       = "enabled"
    conditions = {
      users = {
        excludeGroups = [
          msgraph_resource.cap_excluded_from_conditional_access.id,
          var.group_ids.pim_version1_administrators,
          var.group_ids.pim_version1_application_developers,
          var.group_ids.pim_admin_application_developer,
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
      clientApplications = {
        includeServicePrincipals = ["ServicePrincipalsInMyTenant"]
      }
    }
    grantControls = {
      operator        = "OR"
      builtInControls = ["block"]
    }
  })
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_1088_block_sensitive_apps_noncompliant_devices" {
  url = "identity/conditionalAccess/policies"
  body = jsonencode({
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
  })
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_1090_block_high_risk_signins" {
  url = "identity/conditionalAccess/policies"
  body = jsonencode({
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
  })
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_1100_block_high_risk_users" {
  url = "identity/conditionalAccess/policies"
  body = jsonencode({
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
  })
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_1110_block_o365_insider_risk" {
  url = "identity/conditionalAccess/policies"
  body = jsonencode({
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
  })
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_2010_grant_medium_risk_signins" {
  url = "identity/conditionalAccess/policies"
  body = jsonencode({
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
  })
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_2020_grant_medium_risk_users" {
  url = "identity/conditionalAccess/policies"
  body = jsonencode({
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
  })
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_2050_grant_mfa_all_users" {
  url = "identity/conditionalAccess/policies"
  body = jsonencode({
    displayName = "GLOBAL - 2050 - GRANT - MFA for All Users"
    state       = "enabled"
    conditions = {
      users = {
        includeUsers = ["All"]
        excludeGroups = [
          msgraph_resource.cap_excluded_from_conditional_access.id,
          var.group_ids.cap_automated_test_users,
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
        excludeApplications = ["4660504c-45b3-4674-a709-71951a6b0763"]
      }
      clientAppTypes = ["all"]
    }
    grantControls = {
      operator = "OR"
      authenticationStrength = {
        id = var.authentication_strength_ids.multifactor_authentication
      }
    }
  })
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_2051_grant_mfa_guest_users" {
  url = "identity/conditionalAccess/policies"
  body = jsonencode({
    displayName = "GLOBAL - 2051 - GRANT - MFA for Guest Users"
    state       = "enabled"
    conditions = {
      users = {
        includeUsers = []
        excludeGroups = [
          msgraph_resource.cap_excluded_from_conditional_access.id,
          var.group_ids.cap_automated_test_users,
        ]
        includeGuestsOrExternalUsers = {
          guestOrExternalUserTypes = "internalGuest,b2bCollaborationGuest,b2bCollaborationMember,b2bDirectConnectUser,otherExternalUser,serviceProvider"
        }
      }
      applications = {
        includeApplications = ["All"]
        excludeApplications = ["4660504c-45b3-4674-a709-71951a6b0763"]
      }
      clientAppTypes = ["all"]
    }
    grantControls = {
      operator        = "OR"
      builtInControls = ["mfa"]
    }
  })
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_2055_grant_phishing_resistant_mfa_admins" {
  url = "identity/conditionalAccess/policies"
  body = jsonencode({
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
  })
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_3020_session_guest_persistent_browser" {
  url = "identity/conditionalAccess/policies"
  body = jsonencode({
    displayName = "GLOBAL - 3020 - SESSION - Guest Users All Apps Persistant Browser"
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
        isEnabled = false
      }
      persistentBrowser = {
        isEnabled = true
        mode      = "never"
      }
    }
  })
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_3025_session_guest_signin_frequency" {
  url = "identity/conditionalAccess/policies"
  body = jsonencode({
    displayName = "GLOBAL - 3025 - SESSION - Guest Users All Apps Signin Frequency"
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
      }
    }
  })
  response_export_values = {
    id = "id"
  }
}

resource "msgraph_resource" "ca_3040_session_continuous_access_evaluation" {
  url = "identity/conditionalAccess/policies"
  body = jsonencode({
    displayName = "GLOBAL - 3040 - SESSION - Continuos Access Evaluation"
    state       = "enabled"
    conditions = {
      users = {
        includeUsers  = ["All"]
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
      locations = {
        includeLocations = ["All"]
        excludeLocations = [
          var.named_location_ids.ark_c_public_ips,
          var.named_location_ids.ark_f_public_ips,
          var.named_location_ids.sase_ips,
        ]
      }
    }
    sessionControls = {
      continuousAccessEvaluation = {
        mode = "strictEnforcement"
      }
    }
  })
  response_export_values = {
    id = "id"
  }
}
 */