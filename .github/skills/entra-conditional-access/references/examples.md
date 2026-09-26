# Author policy HCL

This example illustrates typed policy structure. Its group reference is a placeholder for an existing, approved emergency-access group.
Adapt names, dependencies, targeting, and controls to the repository and task. Do not deploy the example as an unexplained baseline.

```hcl
resource "azuread_conditional_access_policy" "block_legacy_example" {
  display_name = "Block legacy authentication - example"
  state        = "enabledForReportingButNotEnforced"

  conditions {
    client_app_types = ["exchangeActiveSync", "other"]
    applications {
      included_applications = ["All"]
    }
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.emergency_access.object_id]
    }
  }
  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
}
```

For managed authentication strengths, use the resource's `.id` directly, for example `azuread_authentication_strength_policy.phishing_resistant_mfa.id`.
For external strengths, discover the actual identifier and verify the selected provider's format. Do not prepend a Graph path twice.
Do not introduce a hardcoded built-in strength map when the repository already manages custom strengths.

Inspect the schema for supported client types, guest blocks, risk fields, and session controls rather than treating examples as exhaustive enums.
Use typed snake_case fields for AzureAD resources. Use Graph payload names only in Graph-managed resources.
Preserve explicit dependencies required by local baseline conventions; explain behavioral dependencies that attribute references do not express.

Source: [AzureAD Conditional Access resource](https://raw.githubusercontent.com/hashicorp/terraform-provider-azuread/main/docs/resources/conditional_access_policy.md).
