resource "msgraph_resource" "auth_method_policy_root" {
  url = "policies"
  body = {
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
    "@odata.type"         = "#microsoft.graph.microsoftAuthenticatorAuthenticationMethodConfiguration"
    state                 = "enabled"
    isSoftwareOathEnabled = true
    includeTargets = [
      {
        id                     = "all_users"
        targetType             = "group"
        isRegistrationRequired = false
        authenticationMode     = "any"
      }
    ]
    featureSettings = {
      displayLocationInformationRequiredState = {
        state         = "enabled"
        includeTarget = { id = "all_users", targetType = "group" }
        excludeTarget = { id = "00000000-0000-0000-0000-000000000000", targetType = "group" }
      }
      companionAppAllowedState = {
        state         = "default"
        includeTarget = { id = "all_users", targetType = "group" }
        excludeTarget = { id = "00000000-0000-0000-0000-000000000000", targetType = "group" }
      }
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
    "@odata.type"                = "#microsoft.graph.emailAuthenticationMethodConfiguration"
    state                        = "enabled"
    allowExternalIdToUseEmailOtp = "enabled"
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
    "@odata.type"  = "#microsoft.graph.smsAuthenticationMethodConfiguration"
    state          = "disabled"
    includeTargets = []
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
    "@odata.type"                    = "#microsoft.graph.fido2AuthenticationMethodConfiguration"
    state                            = "enabled"
    isAttestationEnforced            = true
    isSelfServiceRegistrationAllowed = true
    includeTargets = [
      { id = "all_users", targetType = "group" }
    ]
    excludeTargets = []
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
    "@odata.type" = "#microsoft.graph.softwareOathAuthenticationMethodConfiguration"
    state         = "enabled"
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
    "@odata.type"            = "#microsoft.graph.temporaryAccessPassAuthenticationMethodConfiguration"
    state                    = "enabled"
    defaultLength            = 8
    defaultLifetimeInMinutes = 60
    isUsableOnce             = true
    maximumLifetimeInMinutes = 480
    minimumLifetimeInMinutes = 15
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
    "@odata.type"        = "#microsoft.graph.voiceAuthenticationMethodConfiguration"
    state                = "disabled"
    isOfficePhoneAllowed = false
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
    "@odata.type"                  = "#microsoft.graph.x509CertificateAuthenticationMethodConfiguration"
    state                          = "disabled"
    requireCertificateSidAlignment = false
    certificateUserBindings = [
      { x509CertificateField = "PrincipalName", userProperty = "userPrincipalName", priority = 1, trustAffinityLevel = "low" },
      { x509CertificateField = "RFC822Name", userProperty = "userPrincipalName", priority = 2, trustAffinityLevel = "low" },
      { x509CertificateField = "SubjectKeyIdentifier", userProperty = "certificateUserIds", priority = 3, trustAffinityLevel = "high" }
    ]
    authenticationModeConfiguration = {
      x509CertificateAuthenticationDefaultMode    = "x509CertificateSingleFactor"
      x509CertificateDefaultRequiredAffinityLevel = "low"
      rules                                       = []
    }
    issuerHintsConfiguration = { state = "disabled" }
    includeTargets = [
      { id = "all_users", targetType = "group" }
    ]
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
    "@odata.type"  = "#microsoft.graph.verifiableCredentialsAuthenticationMethodConfiguration"
    state          = "disabled"
    includeTargets = []
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
    "@odata.type"                = "#microsoft.graph.qrCodePinAuthenticationMethodConfiguration"
    state                        = "disabled"
    standardQRCodeLifetimeInDays = 365
    pinLength                    = 8
    includeTargets = [
      { id = "all_users", targetType = "group" }
    ]
    excludeTargets = []
  }
}

import {
  to = msgraph_resource.auth_method_policy_qr_code_pin
  id = "policies/authenticationMethodsPolicy/authenticationMethodConfigurations/QRCodePin"
}
