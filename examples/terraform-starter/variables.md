# Terraform input variables

This file defines the root module inputs used for provider authentication and B2B invitation restrictions. It creates no Entra resources itself.

## `tenant_id`

Identifies the Microsoft Entra tenant that Terraform manages.

- The variable has no default, so callers must supply it.
- GitHub Actions supplies it through `TF_VAR_tenant_id`.
- A tenant ID is an identifier, not a credential, but it should remain environment-specific.

## `client_id`

Identifies the app registration used by the AzureAD and Microsoft Graph providers.

- The variable has no default, so callers must supply it.
- GitHub Actions supplies it through `TF_VAR_client_id`.
- Authentication uses OIDC, so this input does not contain a client secret.

## Resources

### HashiCorp articles

- [Use input variables to add module arguments](https://developer.hashicorp.com/terraform/language/values/variables)
- [Validate Terraform configuration](https://developer.hashicorp.com/terraform/language/validate)
