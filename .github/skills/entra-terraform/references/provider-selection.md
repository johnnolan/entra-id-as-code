# Select providers from evidence

Read `required_providers` wherever it is declared, then the available dependency lockfile for selected versions.
A version constraint is not a tested-version claim. Do not upgrade providers as a side effect of reading or validating a skill.

Inspect `terraform providers schema -json` using installed providers when possible. An initialized remote backend can trigger authentication even for schema inspection.
Use a temporary configuration without a backend when only inspecting schemas. If provider execution is unavailable, inspect the matching release documentation and report the limitation.

Choose a typed resource when it covers the required API and fields. A similarly named resource may govern a different object.
Verify any claimed capability gap against the selected version; avoid permanent claims that a provider will never support an API.

`msgraph_resource.body` is structured/dynamic in the inspected provider. Supply an HCL object rather than JSON-encoding the entire body.
Nested properties defined as JSON strings can still require `jsonencode`, such as a B2B management policy's `definition` entries.
The Graph API's schema and version still determine valid payload fields; Terraform validation does not fully validate them.

Use stable Graph APIs when they cover the required operation. When beta is necessary, explain the dependency and preserve API-version handling in imports.
Use expression references for inferred dependencies. Add explicit `depends_on` only for necessary ordering or an established repository convention.

Provider declarations, variables, and outputs do not independently require Graph application permissions.
Resource operations and data lookups do. Backend access uses separate authorization; never infer storage RBAC from Graph permissions.

Sources:

- [AzureAD provider documentation](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs)
- [Microsoft Graph resource documentation](https://raw.githubusercontent.com/microsoft/terraform-provider-msgraph/main/docs/resources/resource.md)
