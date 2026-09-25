# Review external collaboration and trust

Distinguish the cross-tenant policy root, default configuration, and partner-specific configurations.
The default configuration endpoint is `policies/crossTenantAccessPolicy/default`.
Review inbound and outbound collaboration, direct connect, and claims trust separately.

Preserve the approved default posture. For a new design, establish business requirements before selecting restrictive defaults or partner exceptions.
Do not silently block existing collaboration in the name of hardening.
Assess affected partners, guest users, applications, external access, and rollback before changing defaults.

Trust in external MFA or device claims requires an explicit assurance decision.
Do not assume invitation-domain restrictions provide the same controls as cross-tenant access policy.
Retain singleton adoption and verify the API version and actual import ID.

The default-configuration update API documents `Policy.ReadWrite.CrossTenantAccess` for application access.
Analyze reads and any additional operations separately; do not automatically add `Policy.Read.All` to every write workflow.

Source: [Update the default cross-tenant configuration](https://learn.microsoft.com/en-us/graph/api/crosstenantaccesspolicyconfigurationdefault-update?view=graph-rest-1.0).
