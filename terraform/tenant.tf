data "azuread_client_config" "current" {}

resource "msgraph_resource" "authentication_flow_policy" {
  url = "policies/authenticationFlowsPolicy"
  body = jsonencode({
    selfServiceSignUpEnabled = false
  })
}

import {
  to = msgraph_resource.authentication_flow_policy
  id = "policies/authenticationFlowsPolicy"
}

resource "msgraph_resource" "authorization_policy" {
  url = "policies/authorizationPolicy"
  body = jsonencode({
    allowedToSignUpEmailBasedSubscriptions    = false
    allowedToUseSSPR                          = true
    allowEmailVerifiedUsersToJoinOrganization = false
    allowInvitesFrom                          = "adminsAndGuestInviters"
    blockMsolPowerShell                       = false
    defaultUserRolePermissions = {
      allowedToCreateApps                      = false
      allowedToCreateSecurityGroups            = false
      allowedToCreateTenants                   = false
      allowedToReadBitlockerKeysForOwnedDevice = false
      allowedToReadOtherUsers                  = false
      permissionGrantPoliciesAssigned = [
        "ManagePermissionGrantsForSelf.microsoft-user-default-low",
        "ManagePermissionGrantsForOwnedResource.microsoft-dynamically-managed-permissions-for-team",
        "ManagePermissionGrantsForOwnedResource.microsoft-dynamically-managed-permissions-for-chat",
      ]
    }
    guestUserRoleId = "2af84b1e-32c8-42b7-82bc-daa82404023b" # RestrictedGuest role template id
  })
}

import {
  to = msgraph_resource.authorization_policy
  id = "policies/authorizationPolicy"
}

resource "msgraph_resource" "external_identity_policy" {
  url = "policies/externalIdentitiesPolicy"
  body = jsonencode({
    allowDeletedIdentitiesDataRemoval = false
    allowExternalIdentitiesToLeave    = true
  })
}

import {
  to = msgraph_resource.external_identity_policy
  id = "policies/externalIdentitiesPolicy"
}

resource "msgraph_resource" "security_defaults" {
  url = "policies/identitySecurityDefaultsEnforcementPolicy"
  body = jsonencode({
    isEnabled = false
  })
}

import {
  to = msgraph_resource.security_defaults
  id = "policies/identitySecurityDefaultsEnforcementPolicy"
}

resource "msgraph_resource" "password_rule_settings" {
  url = "domains" # placeholder collection — see note below
  body = jsonencode({
    lockoutThreshold                    = 3
    lockoutDurationInSeconds            = 120
    bannedPasswordCheckOnPremisesMode   = "Audit"
    enableBannedPasswordCheckOnPremises = false
    enableBannedPasswordCheck           = true
    bannedPasswordList                  = "six seven, yeet, no cap"
  })
}

resource "azuread_authentication_strength_policy" "default_mfa" {
  display_name = "Default MFA"
  description  = "Baseline authentication strength policy for tenant-wide conditional access."

  allowed_combinations = [
    "fido2",
    "microsoftAuthenticatorPush",
    "sms",
    "softwareOath",
    "voice",
  ]
}
