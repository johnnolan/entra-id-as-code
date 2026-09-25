# Microsoft Graph Application Permissions: Policy.Read.All, Policy.ReadWrite.ConditionalAccess
resource "azuread_named_location" "named_location_restricted_signin" {
  display_name = "Restricted Sign-in Locations"

  country {
    countries_and_regions                 = ["GB"]
    include_unknown_countries_and_regions = false
  }
}
