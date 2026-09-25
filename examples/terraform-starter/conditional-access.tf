# Policies pulled from https://danielchronlund.com/2020/11/26/azure-ad-conditional-access-policy-design-baseline-with-automatic-deployment-support/
# Microsoft Graph Application Permissions: Policy.Read.All, Policy.ReadWrite.ConditionalAccess
# Note: Policies that define an `applications` condition also require `Application.Read.All`.
resource "azuread_conditional_access_policy" "ca_1050_block_high_risk_countries" {
  depends_on = [
    azuread_named_location.named_location_restricted_signin,
  ]
  display_name = "GLOBAL - 1050 - BLOCK - High-Risk Countries"
  state        = "enabledForReportingButNotEnforced"

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
