# Manage groups and access governance

Separate group objects, tenant group settings, lifecycle policies, and entitlement management. They have different APIs and permission requirements.
Use `azuread_group` for supported group objects. Inspect the selected provider before choosing resources for lifecycle and settings APIs.

Preserve emergency-access group references and membership intent. Assess dynamic membership rules before using a group as a policy target.
Do not mix lifecycle/settings inventories into a security-group file's permission requirements merely because they concern groups.
See [permissions](permissions.md) for operation-specific evidence.

For existing lifecycle or settings objects, discover the object ID and adopt deliberately.
Creation and adoption are separate paths. A collection URL alone does not identify the object to import.
For expiry changes, identify affected groups, owners, renewal behavior, notifications, and potential access loss.
For tenant settings, inspect the exact template and property values; do not infer impact on every group type from a display name.

For access packages, inspect the catalog, package, resource associations, assignment policies, and backing resources.
Keep catalog visibility, publication, requestor scope, approvals, expiry, and review requirements explicit.
Do not imply that creating a package and linking a group creates a complete request-and-assignment workflow.
Assess publishing and assignment-policy changes as access changes. Restrict resources and entitlements to the approved purpose.

Sources:

- [AzureAD group permissions and ownership conditions](https://raw.githubusercontent.com/hashicorp/terraform-provider-azuread/main/docs/resources/group.md)
- [Create group lifecycle policy](https://learn.microsoft.com/en-us/graph/api/grouplifecyclepolicy-post-grouplifecyclepolicies?view=graph-rest-1.0)
- [Create group settings](https://learn.microsoft.com/en-us/graph/api/group-post-settings?view=graph-rest-1.0)
- [Catalog resource association](https://raw.githubusercontent.com/hashicorp/terraform-provider-azuread/main/docs/resources/access_package_resource_catalog_association.md)
