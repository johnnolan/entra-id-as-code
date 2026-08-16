# Microsoft Graph Application Permission: Policy.ReadWrite.AuthenticationFlows
resource "msgraph_resource" "authentication_flow_policy" {
  url         = "policies"
  api_version = "beta"
  body = {
    selfServiceSignUpEnabled = false
  }
}

import {
  to = msgraph_resource.authentication_flow_policy
  id = "policies/authenticationFlowsPolicy?api-version=beta"
}

# Microsoft Graph Application Permission: Policy.ReadWrite.Authorization
resource "msgraph_resource" "authorization_policy" {
  url = "policies"
  body = {
    allowedToSignUpEmailBasedSubscriptions    = false
    allowedToUseSSPR                          = true
    allowEmailVerifiedUsersToJoinOrganization = false
    allowInvitesFrom                          = "adminsAndGuestInviters"
    blockMsolPowerShell                       = true
    defaultUserRolePermissions = {
      allowedToCreateApps                      = false
      allowedToCreateSecurityGroups            = false
      allowedToCreateTenants                   = false
      allowedToReadBitlockerKeysForOwnedDevice = false
      allowedToReadOtherUsers                  = false
      permissionGrantPoliciesAssigned = [
        "ManagePermissionGrantsForOwnedResource.microsoft-dynamically-managed-permissions-for-chat",
        "ManagePermissionGrantsForOwnedResource.microsoft-dynamically-managed-permissions-for-team",
        "ManagePermissionGrantsForSelf.microsoft-user-default-low",
      ]
    }
    guestUserRoleId = "2af84b1e-32c8-42b7-82bc-daa82404023b" # RestrictedGuest role template id
  }
}

import {
  to = msgraph_resource.authorization_policy
  id = "policies/authorizationPolicy"
}

# Microsoft Graph Application Permission: Policy.ReadWrite.ExternalIdentities
resource "msgraph_resource" "external_identity_policy" {
  url         = "policies"
  api_version = "beta"
  body = {
    allowDeletedIdentitiesDataRemoval = false
    allowExternalIdentitiesToLeave    = true
  }
}

import {
  to = msgraph_resource.external_identity_policy
  id = "policies/externalIdentitiesPolicy?api-version=beta"
}

# Microsoft Graph Application Permission: Policy.ReadWrite.B2BManagementPolicy
resource "msgraph_resource" "b2b_management_policy" {
  count = var.b2b_invitation_domain_mode == "allow_all" ? 0 : 1

  url         = "policies/b2bManagementPolicies"
  api_version = "beta"
  body = {
    "@odata.type"         = "#microsoft.graph.b2bManagementPolicy"
    displayName           = "Default B2B collaboration policy"
    description           = "Controls the domains that can receive B2B collaboration invitations."
    isOrganizationDefault = true
    definition = [
      jsonencode({
        B2BManagementPolicy = merge(
          { Version = 1 },
          var.b2b_invitation_domain_mode == "allow_list" ? {
            invitationsAllowedAndBlocked = {
              AllowedDomains = sort(tolist(var.b2b_invitation_allowed_domains))
            }
            } : var.b2b_invitation_domain_mode == "block_list" ? {
            invitationsAllowedAndBlocked = {
              BlockedDomains = sort(tolist(var.b2b_invitation_blocked_domains))
            }
          } : {}
        )
      })
    ]
  }

  lifecycle {
    precondition {
      condition = (
        var.b2b_invitation_domain_mode == "allow_all" ? (length(var.b2b_invitation_allowed_domains) == 0 && length(var.b2b_invitation_blocked_domains) == 0) :
        var.b2b_invitation_domain_mode == "allow_list" ? (length(var.b2b_invitation_allowed_domains) > 0 && length(var.b2b_invitation_blocked_domains) == 0) :
        length(var.b2b_invitation_allowed_domains) == 0
      )
      error_message = "Set domains only for the selected b2b_invitation_domain_mode. An allow_list requires at least one allowed domain."
    }
  }
}

# Microsoft Graph Application Permissions: Policy.Read.All, Policy.ReadWrite.ConditionalAccess
resource "msgraph_resource" "security_defaults" {
  url         = "policies"
  api_version = "beta"
  body = {
    isEnabled = false
  }
}

import {
  to = msgraph_resource.security_defaults
  id = "policies/identitySecurityDefaultsEnforcementPolicy?api-version=beta"
}

# Microsoft Graph Application Permissions: Policy.Read.All, Policy.ReadWrite.ConditionalAccess
resource "azuread_authentication_strength_policy" "default_mfa" {
  display_name = "EIDAC - Default MFA"
  description  = "Baseline authentication strength policy for the Entra ID as Code demo tenant."

  # Reference: provider-documented allowed_combinations values.
  # Online Reference: https://raw.githubusercontent.com/hashicorp/terraform-provider-azuread/main/docs/resources/authentication_strength_policy.md
  # You can use one or more of these strings in this list:
  # - fido2
  # - password
  # - deviceBasedPush
  # - temporaryAccessPassOneTime
  # - federatedMultiFactor
  # - federatedSingleFactor
  # - hardwareOath,federatedSingleFactor
  # - microsoftAuthenticatorPush,federatedSingleFactor
  # - password,hardwareOath
  # - password,microsoftAuthenticatorPush
  # - password,sms
  # - password,softwareOath
  # - password,voice
  # - sms
  # - sms,federatedSingleFactor
  # - softwareOath,federatedSingleFactor
  # - temporaryAccessPassMultiUse
  # - voice,federatedSingleFactor
  # - windowsHelloForBusiness
  # - x509CertificateMultiFactor
  # - x509CertificateSingleFactor
  # Note: some combinations may still be rejected by Graph in specific tenants.
  allowed_combinations = [
    "fido2",
    "password,microsoftAuthenticatorPush",
    "password,softwareOath",
    "windowsHelloForBusiness",
  ]
}

resource "azuread_authentication_strength_policy" "passwordless_mfa" {
  depends_on   = [azuread_authentication_strength_policy.default_mfa]
  display_name = "EIDAC - Passwordless MFA"
  description  = "Allows FIDO2 and Windows Hello for Business passwordless authentication in the demo tenant."

  allowed_combinations = [
    "fido2",
    "windowsHelloForBusiness",
  ]
}

resource "azuread_authentication_strength_policy" "phishing_resistant_mfa" {
  depends_on   = [azuread_authentication_strength_policy.passwordless_mfa]
  display_name = "EIDAC - Phishing MFA"
  description  = "Requires phishing-resistant FIDO2 or Windows Hello for Business authentication in the demo tenant."

  allowed_combinations = [
    "fido2",
    "windowsHelloForBusiness",
  ]
}
