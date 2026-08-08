data "azuread_client_config" "current" {}

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
