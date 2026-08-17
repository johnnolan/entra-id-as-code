# Terraform providers and backend

This file configures the Terraform version, remote state backend, and providers used to manage Microsoft Entra ID.

## Terraform version

`required_version = ">= 1.15.0"` prevents older Terraform versions from processing configuration that relies on current language and provider behaviour.

## Azure Blob Storage backend

The `azurerm` backend stores Terraform state in Azure Blob Storage.

- `use_oidc = true` uses OpenID Connect (OIDC), a token federation protocol, instead of a stored client secret.
- `use_azuread_auth = true` authenticates directly to the storage data plane with Microsoft Entra ID.
- The workflow supplies the storage account, container, state key, tenant, client, and subscription values during `terraform init`.
- The backend identity needs `Storage Blob Data Contributor` at the state container or storage account scope.

> **Security requirement:** Keep backend credentials out of `.tf` files and backend command arguments where possible. HashiCorp warns that backend arguments can be written into `.terraform` data and plan files.

## Provider selection

### `azuread`

The HashiCorp AzureAD provider is pinned to `~> 3.0`.

- Use typed `azuread_*` resources whenever the provider supports the required Entra object and properties.
- `tenant_id` and `client_id` select the workload identity used by Terraform.
- `use_oidc = true` enables secretless authentication in GitHub Actions.

### `msgraph`

The Microsoft Graph provider is pinned to `~> 0.4`.

- Use `msgraph_resource` only for Graph APIs without an AzureAD resource or required typed field.
- It uses the same tenant, client, and OIDC workload identity as AzureAD.

## Required permissions

This file performs no Microsoft Graph resource operations. Permissions come from the resources in the other Terraform files.

The backend identity separately needs Azure role-based access control (RBAC) for state storage. Microsoft Graph application permissions do not grant access to Azure Blob Storage.

## Maester coverage

No Maester test directly evaluates Terraform provider or backend declarations. Maester evaluates the resulting Entra tenant configuration.

## Resources

### HashiCorp articles

- [AzureRM backend](https://developer.hashicorp.com/terraform/language/backend/azurerm)
- [Authenticate the AzureAD provider with OIDC](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_oidc)

### Provider documentation

- [AzureAD provider](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs)
- [Microsoft Graph provider](https://registry.terraform.io/providers/microsoft/msgraph/latest/docs)
