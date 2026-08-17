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

## `b2b_invitation_domain_mode`

Controls the domain restriction mode used by the B2B management policy.

- `allow_all` creates no B2B domain restriction resource and permits invitations to any domain.
- `allow_list` permits only domains in `b2b_invitation_allowed_domains`.
- `block_list` denies domains in `b2b_invitation_blocked_domains`.
- Variable validation rejects any other mode before Terraform calls Microsoft Graph.

## `b2b_invitation_allowed_domains`

Stores the domains allowed when `b2b_invitation_domain_mode` is `allow_list`.

- The set defaults to empty.
- The policy resource requires at least one value in allow-list mode.
- A set prevents duplicate domains.

## `b2b_invitation_blocked_domains`

Stores the domains denied when `b2b_invitation_domain_mode` is `block_list`.

- The set defaults to empty.
- A set prevents duplicate domains.

## Required permissions

Variable declarations require no Microsoft Graph or Azure permissions. Resources that consume these values determine the effective permission requirements.

## Maester coverage

No Maester test directly evaluates Terraform input declarations. Maester evaluates the tenant policy produced from these values.

## Resources

### HashiCorp articles

- [Use input variables to add module arguments](https://developer.hashicorp.com/terraform/language/values/variables)
- [Validate Terraform configuration](https://developer.hashicorp.com/terraform/language/validate)
