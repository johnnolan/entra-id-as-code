# Microsoft Graph Application Permission: Policy.ReadWrite.AuthenticationFlows
resource "msgraph_resource" "authentication_flow_policy" {
  url         = "policies"
  api_version = "beta"
  body = {
    # Disables the self-service sign-up flow so users cannot create accounts through the Entra sign-up experience.
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
    # Prevents users from creating email-based subscriptions in Entra without an admin-controlled process.
    allowedToSignUpEmailBasedSubscriptions = false
    # Enables self-service password reset for users when it is allowed by the tenant configuration.
    allowedToUseSSPR = true
    # Blocks unverified users from joining the organization through an email-based onboarding path.
    allowEmailVerifiedUsersToJoinOrganization = false
    # Restricts invite creation to administrators and designated guest inviter roles.
    allowInvitesFrom = "adminsAndGuestInviters"
    # Disables legacy Msol PowerShell access to reduce the risk of unmanaged tenant administration.
    blockMsolPowerShell = true
    # Sets the default permissions granted to standard users, including app creation and permission-grant controls.
    defaultUserRolePermissions = {
      # Prevents regular users from creating new application registrations in Entra.
      allowedToCreateApps = false
      # Prevents regular users from creating security groups without an admin-driven process.
      allowedToCreateSecurityGroups = false
      # Prevents users from creating new Azure AD tenants or child organizations.
      allowedToCreateTenants = false
      # Stops users from reading BitLocker recovery keys for devices they own.
      allowedToReadBitlockerKeysForOwnedDevice = false
      # Prevents users from reading other users' profile information by default.
      allowedToReadOtherUsers = false
      # Assigns only owned-resource permission-grant policies; omitting a ManagePermissionGrantsForSelf entry blocks user consent to applications (Maester MT.1006).
      permissionGrantPoliciesAssigned = [
        "ManagePermissionGrantsForOwnedResource.microsoft-dynamically-managed-permissions-for-chat",
        "ManagePermissionGrantsForOwnedResource.microsoft-dynamically-managed-permissions-for-team",
      ]
    }
    # Assigns the Restricted Guest role template so guests have the least privileged default access.
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
    # Prevents deleted external identities from being automatically removed from tenant data stores.
    allowDeletedIdentitiesDataRemoval = false
    # Allows external identities to leave the organization when they no longer need access.
    allowExternalIdentitiesToLeave = true
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
    # Identifies this resource as a Microsoft Graph B2B management policy object.
    "@odata.type" = "#microsoft.graph.b2bManagementPolicy"
    # Sets the friendly name shown in Entra for the tenant B2B collaboration policy.
    displayName = "Default B2B collaboration policy"
    # Describes the purpose of the policy so administrators understand the domain restriction it enforces.
    description = "Controls the domains that can receive B2B collaboration invitations."
    # Marks this policy as the organization default for B2B collaboration invitation handling.
    isOrganizationDefault = true
    # Contains the JSON definition that tells Entra which domains are allowed or blocked for guest invitations.
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
    # Disables the legacy security defaults baseline so tenant security is governed by explicit Conditional Access policies.
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
  # Defines which authentication methods and combinations are considered valid for this baseline MFA strength policy in Entra.
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

  # Limits this policy to passwordless methods that satisfy stronger MFA expectations in Entra.
  allowed_combinations = [
    "fido2",
    "windowsHelloForBusiness",
  ]
}

resource "azuread_authentication_strength_policy" "phishing_resistant_mfa" {
  depends_on   = [azuread_authentication_strength_policy.passwordless_mfa]
  display_name = "EIDAC - Phishing MFA"
  description  = "Requires phishing-resistant FIDO2 or Windows Hello for Business authentication in the demo tenant."

  # Requires phishing-resistant methods so Entra treats this strength level as resistant to credential theft and MFA fatigue attacks.
  allowed_combinations = [
    "fido2",
    "windowsHelloForBusiness",
  ]
}
