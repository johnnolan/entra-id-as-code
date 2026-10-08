resource "msgraph_resource_action" "authentication_context_c1" {
  resource_url = "identity/conditionalAccess/authenticationContextClassReferences/c1"
  method       = "PATCH"

  body = {
    displayName = "c1 Test"
    description = "c1 Test description"
    isAvailable = true
  }
}
