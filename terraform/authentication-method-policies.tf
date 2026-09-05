resource "msgraph_resource" "auth_method_policy_root" {
  url = "policies"
  body = {
    # Marks the tenant authentication methods policy migration as complete so Entra can use the current policy model.
    policyMigrationState = "migrationComplete"
  }
}

import {
  to = msgraph_resource.auth_method_policy_root
  id = "policies/authenticationMethodsPolicy"
}

resource "msgraph_resource" "auth_method_policy_authenticator" {
  url = "policies/authenticationMethodsPolicy/authenticationMethodConfigurations"
  body = {
    # Identifies this configuration as the Microsoft Authenticator method policy in Entra.
    "@odata.type" = "#microsoft.graph.microsoftAuthenticatorAuthenticationMethodConfiguration"
    # Enables the Microsoft Authenticator method for users in the tenant.
    state = "enabled"
    # Allows the software OATH token method to be used alongside Microsoft Authenticator where supported.
    isSoftwareOathEnabled = true
    # Applies the configuration to all users so the method is available to the organization by default.
    includeTargets = [
      {
        id                     = "all_users"
        targetType             = "group"
        isRegistrationRequired = false
        authenticationMode     = "any"
      }
    ]
    # Configures the Authenticator feature behaviors for location, companion app, and app information prompts.
    featureSettings = {
      # Requires display of location information when users are signing in with this method.
      displayLocationInformationRequiredState = {
        state         = "enabled"
        includeTarget = { id = "all_users", targetType = "group" }
        excludeTarget = { id = "00000000-0000-0000-0000-000000000000", targetType = "group" }
      }
      # Allows the companion app experience to follow the default tenant policy while still applying the group-wide target.
      companionAppAllowedState = {
        state         = "default"
        includeTarget = { id = "all_users", targetType = "group" }
        excludeTarget = { id = "00000000-0000-0000-0000-000000000000", targetType = "group" }
      }
      # Requires app information to be displayed for users to help them recognize the sign-in prompt.
      displayAppInformationRequiredState = {
        state         = "enabled"
        includeTarget = { id = "all_users", targetType = "group" }
        excludeTarget = { id = "00000000-0000-0000-0000-000000000000", targetType = "group" }
      }
    }
  }
}

import {
  to = msgraph_resource.auth_method_policy_authenticator
  id = "policies/authenticationMethodsPolicy/authenticationMethodConfigurations/MicrosoftAuthenticator"
}

resource "msgraph_resource" "auth_method_policy_email" {
  depends_on = [azuread_group.sec_guest_users]
  url        = "policies/authenticationMethodsPolicy/authenticationMethodConfigurations"
  body = {
    # Identifies this configuration as the email OTP authentication method in Entra.
    "@odata.type" = "#microsoft.graph.emailAuthenticationMethodConfiguration"
    # Enables email-based verification as an available authentication method.
    state = "enabled"
    # Allows external identities to use email one-time passcodes for secure sign-in.
    allowExternalIdToUseEmailOtp = "enabled"
    # Limits email OTP availability to the guest security group so it is targeted to approved users.
    includeTargets = [
      { id = azuread_group.sec_guest_users.object_id, targetType = "group" }
    ]
  }
}

import {
  to = msgraph_resource.auth_method_policy_email
  id = "policies/authenticationMethodsPolicy/authenticationMethodConfigurations/Email"
}

resource "msgraph_resource" "auth_method_policy_sms" {
  url = "policies/authenticationMethodsPolicy/authenticationMethodConfigurations"
  body = {
    # Identifies this configuration as the SMS authentication method in Entra.
    "@odata.type" = "#microsoft.graph.smsAuthenticationMethodConfiguration"
    # Keeps SMS authentication disabled to avoid relying on a weaker or less preferred factor.
    state = "disabled"
    # Leaves the SMS method unassigned to groups by default.
    includeTargets = []
    # Ensures no explicit exclusions are configured for this method.
    excludeTargets = []
  }
}

import {
  to = msgraph_resource.auth_method_policy_sms
  id = "policies/authenticationMethodsPolicy/authenticationMethodConfigurations/Sms"
}

resource "msgraph_resource" "auth_method_policy_fido2" {
  url = "policies/authenticationMethodsPolicy/authenticationMethodConfigurations"
  body = {
    # Identifies this configuration as the FIDO2 security key authentication method in Entra.
    "@odata.type" = "#microsoft.graph.fido2AuthenticationMethodConfiguration"
    # Enables FIDO2 security keys as a valid login method for users.
    state = "enabled"
    # Requires attestation to validate the security key's authenticity before registration is accepted.
    isAttestationEnforced = true
    # Allows users to self-register FIDO2 keys to improve the user experience without manual admin enrollment.
    isSelfServiceRegistrationAllowed = true
    # Applies the policy to all users so the method is available to the organization by default.
    includeTargets = [
      { id = "all_users", targetType = "group" }
    ]
    # Keeps the FIDO2 method free of explicit exclusions.
    excludeTargets = []
    # Restricts keys to trusted vendor models while allowing the specified device GUIDs to register.
    keyRestrictions = {
      isEnforced      = true
      enforcementType = "allow"
      aaGuids = [
        "d8522d9f-575b-4866-88a9-ba99fa02f35b", #YubiKey Bio - FIDO Edition 5.5, 5.6
        "dd86a2da-86a0-4cbe-b462-4bd31f57bc6f", #YubiKey Bio - FIDO Edition 5.7
        "7409272d-1ff9-4e10-9fc9-ac0019c124fd", #YubiKey Bio - FIDO Edition 5.7
      ]
    }
  }
}

import {
  to = msgraph_resource.auth_method_policy_fido2
  id = "policies/authenticationMethodsPolicy/authenticationMethodConfigurations/Fido2"
}

resource "msgraph_resource" "auth_method_policy_software_oath" {
  url = "policies/authenticationMethodsPolicy/authenticationMethodConfigurations"
  body = {
    # Identifies this configuration as the software OATH token method in Entra.
    "@odata.type" = "#microsoft.graph.softwareOathAuthenticationMethodConfiguration"
    # Enables software-based OATH tokens such as authenticator apps that generate TOTP codes.
    state = "enabled"
    # Applies the software OATH method to all users in the tenant.
    includeTargets = [
      { id = "all_users", targetType = "group" }
    ]
  }
}

import {
  to = msgraph_resource.auth_method_policy_software_oath
  id = "policies/authenticationMethodsPolicy/authenticationMethodConfigurations/SoftwareOath"
}

resource "msgraph_resource" "auth_method_policy_temporary_access_pass" {
  url = "policies/authenticationMethodsPolicy/authenticationMethodConfigurations"
  body = {
    # Identifies this configuration as the Temporary Access Pass method in Entra.
    "@odata.type" = "#microsoft.graph.temporaryAccessPassAuthenticationMethodConfiguration"
    # Enables Temporary Access Passes so administrators can issue short-lived sign-in credentials during onboarding or break-glass access.
    state = "enabled"
    # Sets the default number of characters in a generated temporary access pass.
    defaultLength = 8
    # Sets the default validity period for a temporary access pass before it expires.
    defaultLifetimeInMinutes = 60
    # Ensures each temporary access pass can be used only once to reduce the chance of reuse.
    isUsableOnce = true
    # Caps the maximum lifecycle of any temporary access pass to avoid very long-lived recovery credentials.
    maximumLifetimeInMinutes = 480
    # Prevents extremely short-lived passes that may be impractical for user sign-in or admin recovery.
    minimumLifetimeInMinutes = 15
    # Applies the temporary access pass policy to all users in the organisation.
    includeTargets = [
      { id = "all_users", targetType = "group" }
    ]
  }
}

import {
  to = msgraph_resource.auth_method_policy_temporary_access_pass
  id = "policies/authenticationMethodsPolicy/authenticationMethodConfigurations/TemporaryAccessPass"
}

resource "msgraph_resource" "auth_method_policy_voice" {
  url = "policies/authenticationMethodsPolicy/authenticationMethodConfigurations"
  body = {
    # Identifies this configuration as the voice call authentication method in Entra.
    "@odata.type" = "#microsoft.graph.voiceAuthenticationMethodConfiguration"
    # Keeps voice-based authentication disabled to reduce reliance on less secure or more brittle MFA methods.
    state = "disabled"
    # Blocks office phone numbers from being used as a voice MFA signal.
    isOfficePhoneAllowed = false
    # Applies the voice policy to all users for consistency even though the method remains disabled.
    includeTargets = [
      { id = "all_users", targetType = "group" }
    ]
  }
}

import {
  to = msgraph_resource.auth_method_policy_voice
  id = "policies/authenticationMethodsPolicy/authenticationMethodConfigurations/Voice"
}

resource "msgraph_resource" "auth_method_policy_x509_certificate" {
  url = "policies/authenticationMethodsPolicy/authenticationMethodConfigurations"
  body = {
    # Identifies this configuration as the certificate-based authentication method in Entra.
    "@odata.type" = "#microsoft.graph.x509CertificateAuthenticationMethodConfiguration"
    # Keeps certificate-based sign-in disabled until the tenant is ready to support it.
    state = "disabled"
    # Allows certificate subject identifier alignment to be optional rather than mandatory.
    requireCertificateSidAlignment = false
    # Maps certificate fields to user properties so Entra can match a user to a certificate reliably.
    certificateUserBindings = [
      { x509CertificateField = "PrincipalName", userProperty = "userPrincipalName", priority = 1, trustAffinityLevel = "low" },
      { x509CertificateField = "RFC822Name", userProperty = "userPrincipalName", priority = 2, trustAffinityLevel = "low" },
      { x509CertificateField = "SubjectKeyIdentifier", userProperty = "certificateUserIds", priority = 3, trustAffinityLevel = "high" }
    ]
    # Configures the default certificate authentication mode and trust level used when certificate authentication is enabled.
    authenticationModeConfiguration = {
      x509CertificateAuthenticationDefaultMode    = "x509CertificateSingleFactor"
      x509CertificateDefaultRequiredAffinityLevel = "low"
      rules                                       = []
    }
    # Disables issuer hints to keep the certificate method simple and avoid risk from heuristic issuer matching.
    issuerHintsConfiguration = { state = "disabled" }
    # Applies the policy to all users even though the method is currently disabled.
    includeTargets = [
      { id = "all_users", targetType = "group" }
    ]
    # Ensures there are no explicit certificate exclusions configured at the moment.
    excludeTargets = []
  }
}

import {
  to = msgraph_resource.auth_method_policy_x509_certificate
  id = "policies/authenticationMethodsPolicy/authenticationMethodConfigurations/X509Certificate"
}
resource "msgraph_resource" "auth_method_policy_verifiable_credentials" {
  url = "policies/authenticationMethodsPolicy/authenticationMethodConfigurations"
  body = {
    # Identifies this configuration as the verifiable credentials method in Entra.
    "@odata.type" = "#microsoft.graph.verifiableCredentialsAuthenticationMethodConfiguration"
    # Keeps verifiable credentials disabled until the organization is ready to support decentralized identity flows.
    state = "disabled"
    # Leaves the method unassigned to any group because it is not currently in use.
    includeTargets = []
    # Ensures no group exclusions are defined for this inactive method.
    excludeTargets = []
  }
}

import {
  to = msgraph_resource.auth_method_policy_verifiable_credentials
  id = "policies/authenticationMethodsPolicy/authenticationMethodConfigurations/VerifiableCredentials"
}

resource "msgraph_resource" "auth_method_policy_qr_code_pin" {
  url = "policies/authenticationMethodsPolicy/authenticationMethodConfigurations"
  body = {
    # Identifies this configuration as the QR code PIN authentication method in Entra.
    "@odata.type" = "#microsoft.graph.qrCodePinAuthenticationMethodConfiguration"
    # Keeps the QR code PIN method disabled until it is required for a specific workflow.
    state = "disabled"
    # Sets the default validity period for QR codes before they expire and require refresh.
    standardQRCodeLifetimeInDays = 365
    # Defines the number of digits required when a PIN is used for QR code authentication.
    pinLength = 8
    # Applies the policy to all users even though the method remains disabled.
    includeTargets = [
      { id = "all_users", targetType = "group" }
    ]
    # Leaves no explicit exclusions for this method at the moment.
    excludeTargets = []
  }
}

import {
  to = msgraph_resource.auth_method_policy_qr_code_pin
  id = "policies/authenticationMethodsPolicy/authenticationMethodConfigurations/QRCodePin"
}
