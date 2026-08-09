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

resource "msgraph_resource" "authorization_policy" {
  url = "policies"
  body = {
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
  }
}

import {
  to = msgraph_resource.authorization_policy
  id = "policies/authorizationPolicy"
}

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

resource "azuread_authentication_strength_policy" "default_mfa" {
  display_name = "Default MFA"
  description  = "Baseline authentication strength policy for tenant-wide conditional access."

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
    "password,sms",
  ]
}
