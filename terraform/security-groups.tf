resource "msgraph_resource" "cap_excluded_from_conditional_access" {
  url = "groups"
  body = jsonencode({
    displayName     = "CAP-Excluded from Conditional Access"
    description     = "Excluded users from Conditional Access rules."
    securityEnabled = true
    mailEnabled     = false
    mailNickname    = "ExcludedfromConditionalAccess"
    groupTypes      = []
  })
  response_export_values = {
    id = "id"
  }
}
