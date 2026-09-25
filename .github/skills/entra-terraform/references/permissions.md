# Verify permissions by operation

Do not grant the union of this table. Build the permission set for the actual workflow and authentication mode.
Application permissions apply to app-only execution; delegated execution can also require a supported directory role.
Azure state-storage RBAC, Terraform execution permissions, managed application requests, and admin consent are separate concerns.

## Trace the workflow

1. Identify resources, data sources, API versions, and auxiliary lookups from configuration and provider behavior.
2. Distinguish refresh/read, create, update, delete, import discovery, and actual consent or app-role grants.
3. Check the matching provider release documentation and each Graph endpoint's permission table.
4. Record the least-privileged supported option, ownership or role conditions, conditional extra permissions, source, and verification date.
5. Diagnose the failing operation before broadening access. Never infer a permission from a resource's filename or a generic 403 alone.

## Consult the evidence matrix

The following application-access entries were checked against primary documentation on 2026-09-21.
Graph rows cover the stated operation only, not every lifecycle operation. Provider rows describe documented resource use.
Provider documentation links track upstream; verify the selected release before changing grants. No tenant permissions were exercised to validate this table.

| Resource/API | Operation | Documented application permission or option | Conditions and extra operations | Evidence |
| --- | --- | --- | --- | --- |
| Authentication methods policy | Update root | `Policy.ReadWrite.AuthenticationMethod` | Analyze read/refresh separately; no blanket user-credential permission | [Microsoft](https://learn.microsoft.com/en-us/graph/api/authenticationmethodspolicy-update?view=graph-rest-1.0) |
| FIDO2 method configuration | Update | `Policy.ReadWrite.AuthenticationMethod` | Check each other method's own endpoint before extending this claim | [Microsoft](https://learn.microsoft.com/en-us/graph/api/fido2authenticationmethodconfiguration-update?view=graph-rest-1.0) |
| Cross-tenant default configuration | Update | `Policy.ReadWrite.CrossTenantAccess` | Root and partner operations are separate; do not add general policy read permission without evidence | [Microsoft](https://learn.microsoft.com/en-us/graph/api/crosstenantaccesspolicyconfigurationdefault-update?view=graph-rest-1.0) |
| Group lifecycle policy | Create | `Directory.ReadWrite.All` | Verify update/delete/refresh separately | [Microsoft](https://learn.microsoft.com/en-us/graph/api/grouplifecyclepolicy-post-grouplifecyclepolicies?view=graph-rest-1.0) |
| Tenant group settings | Create/update | `GroupSettings.ReadWrite.All` | Broader alternatives are not cumulative requirements | [Create](https://learn.microsoft.com/en-us/graph/api/group-post-settings?view=graph-rest-1.0), [update](https://learn.microsoft.com/en-us/graph/api/groupsetting-update?view=graph-rest-1.0) |
| `azuread_group` | Provider resource use | `Group.ReadWrite.All` or `Directory.ReadWrite.All`; ownership-scoped `Group.Create` option | Verify ownership and additional property requirements; do not silently add owners | [Provider](https://raw.githubusercontent.com/hashicorp/terraform-provider-azuread/main/docs/resources/group.md) |
| Catalog resource association | Provider resource use | `EntitlementManagement.ReadWrite.All` | Backing group creation and explicit group lookups are separate operations | [Provider](https://raw.githubusercontent.com/hashicorp/terraform-provider-azuread/main/docs/resources/access_package_resource_catalog_association.md) |
| Application registration | Provider resource use | `Application.ReadWrite.OwnedBy` or `Application.ReadWrite.All` | OwnedBy requires Terraform principal ownership; user owners can require `User.Read.All` | [Provider](https://raw.githubusercontent.com/hashicorp/terraform-provider-azuread/main/docs/resources/application.md) |
| Application federated credential | Provider resource use | `Application.ReadWrite.OwnedBy` or `Application.ReadWrite.All` | OwnedBy requires ownership of the parent application | [Provider](https://raw.githubusercontent.com/hashicorp/terraform-provider-azuread/main/docs/resources/application_federated_identity_credential.md) |
| Conditional Access policy | Provider resource use | `Policy.Read.All` and `Policy.ReadWrite.ConditionalAccess` | Evaluate extra lookups separately; an applications condition alone is not evidence for `Application.Read.All` | [Provider](https://raw.githubusercontent.com/hashicorp/terraform-provider-azuread/main/docs/resources/conditional_access_policy.md) |
| Authentication flows policy | Update | `Policy.ReadWrite.AuthenticationFlows` | This evidence is v1.0; verify beta payloads and operations separately | [Microsoft](https://learn.microsoft.com/en-us/graph/api/authenticationflowspolicy-update?view=graph-rest-1.0) |
| Authorization policy | Update | `Policy.ReadWrite.Authorization` | Do not include consent-request policy permissions when no such operation exists | [Microsoft](https://learn.microsoft.com/en-us/graph/api/authorizationpolicy-update?view=graph-rest-1.0) |
| External identities policy | Update, beta | `Policy.ReadWrite.ExternalIdentities` | Preserve API-version handling | [Microsoft](https://learn.microsoft.com/en-us/graph/api/externalidentitiespolicy-update?view=graph-rest-beta) |
| B2B management policy | Update, beta | `Policy.ReadWrite.B2BManagementPolicy` | Creation and adoption need their own checks | [Microsoft](https://learn.microsoft.com/en-us/graph/api/b2bmanagementpolicy-update?view=graph-rest-beta) |
| Organization | Update | `Organization.ReadWrite.All` | Apply to the actual organization properties being changed | [Microsoft](https://learn.microsoft.com/en-us/graph/api/organization-update?view=graph-rest-1.0) |
| Named location | Provider resource use | `Policy.Read.All` and `Policy.ReadWrite.ConditionalAccess` | Verify country/IP replacement effects separately | [Provider](https://raw.githubusercontent.com/hashicorp/terraform-provider-azuread/main/docs/resources/named_location.md) |
| Authentication strength | Provider resource use | `Policy.Read.All` and `Policy.ReadWrite.ConditionalAccess` | Managed resource IDs can already contain the Graph path | [Provider](https://raw.githubusercontent.com/hashicorp/terraform-provider-azuread/main/docs/resources/authentication_strength_policy.md) |
| Access package catalog/package | Provider resource use | `EntitlementManagement.ReadWrite.All` | Publication and assignment policies are separate decisions | [Catalog, v3.9.0](https://raw.githubusercontent.com/hashicorp/terraform-provider-azuread/v3.9.0/docs/resources/access_package_catalog.md), [package, v3.9.0](https://raw.githubusercontent.com/hashicorp/terraform-provider-azuread/v3.9.0/docs/resources/access_package.md) |
| Package resource association | Provider resource use | `EntitlementManagement.ReadWrite.All` | Does not itself define an assignment policy | [Provider, v3.9.0](https://raw.githubusercontent.com/hashicorp/terraform-provider-azuread/v3.9.0/docs/resources/access_package_resource_package_association.md) |
| Security Defaults | Update, beta | Current English API table lists `Policy.Read.All` and lists `Policy.Read.All` plus `Policy.ReadWrite.ConditionalAccess` as a broader option | Documentation ambiguity remains; do not infer a proven write-capable minimum or change grants solely from this row | [Microsoft](https://learn.microsoft.com/en-us/graph/api/identitysecuritydefaultsenforcementpolicy-update?view=graph-rest-beta) |

For any unlisted resource, inspect the exact provider/API documentation.
This matrix is deliberately not an exhaustive permission grant recipe. Add verified operation rows when work introduces them.

Security Defaults documentation has shown inconsistent permission tables across versions/locales.
Do not resolve that ambiguity by automatically granting every suggested role; verify the actual endpoint/version and report unresolved evidence.

Do not carry `UserAuthenticationMethod.ReadWrite.All` into policy configuration unless an actual user-method operation requires it.
Do not carry `AppRoleAssignment.ReadWrite.All` into application registration merely because `required_resource_access` requests permissions.
Do not add general directory permissions to every file. Distinguish minimum permissions from broader supported alternatives.
