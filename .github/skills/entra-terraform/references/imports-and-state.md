# Preserve adoption and state

Classify the target as a newly created object, existing singleton, or existing collection member.
Determine how it is already managed before proposing import or creation. Preserve existing import intent and lifecycle protections.

Use the selected provider's documented import format. A resource's configured collection URL is not necessarily its import ID.
For example, `msgraph_resource` can use `url = "policies"` and import `policies/authenticationMethodsPolicy`.
Collection members need their actual object identifier. Beta resources require the documented `?api-version=beta` suffix.
Typed resources can use provider-specific identifiers that differ from Graph request URLs.

Do not add imports indiscriminately to new groups, catalogs, or custom authentication strengths.
Do not invent object IDs or assume an existing lifecycle/settings object exists because the API supports it.
Prepare discovery and adoption instructions when IDs are unavailable; perform live reads only within the available authorization.

For a resource-type migration, describe the old address and ID, destination schema and import format, ownership of the remote object, and rollback approach.
Review the plan for replacement or deletion risk. Do not assume `moved` blocks can translate arbitrary provider resource schemas.
Execute state mutation only with authorization. Repository changes alone do not authorize `terraform import`, `state rm`, or apply.

Sources:

- [Microsoft Graph import examples](https://raw.githubusercontent.com/microsoft/terraform-provider-msgraph/main/docs/resources/resource.md)
- [Federated credential import format](https://raw.githubusercontent.com/hashicorp/terraform-provider-azuread/main/docs/resources/application_federated_identity_credential.md)
