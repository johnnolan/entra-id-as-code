# Conditional Access

This file manages the tenant Conditional Access baseline. It uses typed AzureAD resources where the provider supports the policy conditions and controls.

## Use AzureAD resources

The following resources use `azuread_conditional_access_policy`:

- Block, grant, and session policies that use application, user, group, guest, location, risk, authentication-strength, persistent-browser, and sign-in-frequency settings.
- The `azuread_named_location.named_location_restricted_signin` country location.
- The `azuread_group.cap_excluded_from_conditional_access` break-glass exclusion group.

Each policy excludes the break-glass group. Do not remove or narrow this exclusion without explicit approval.

## Keep the Graph-only exception

`msgraph_resource.ca_3040_session_continuous_access_evaluation` remains on Microsoft Graph. The AzureAD provider does not expose the `continuousAccessEvaluation` session control. Keep this resource Graph-managed until AzureAD adds typed support.

`msgraph_resource.security_defaults` also remains Graph-managed because AzureAD has no equivalent tenant Security Defaults resource. It must stay disabled while the Conditional Access baseline is in use.
