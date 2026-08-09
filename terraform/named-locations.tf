# Microsoft Graph Application Permissions: Policy.Read.All, Policy.ReadWrite.ConditionalAccess
resource "msgraph_resource" "named_location_restricted_signin" {
  url = "identity/conditionalAccess/namedLocations"
  body = {
    "@odata.type"                     = "#microsoft.graph.countryNamedLocation"
    displayName                       = "Restricted Sign-in Locations"
    countriesAndRegions               = ["GB"]
    includeUnknownCountriesAndRegions = false
  }
  response_export_values = {
    id = "id"
  }
}
