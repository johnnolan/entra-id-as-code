# Policies

This guide explains each resource in [terraform/policies.tf](policies.tf). These resources manage the tenant-wide Microsoft Entra ID policies that control sign-up flows, authorization defaults, external identity behavior, and whether Security Defaults or the Conditional Access baseline governs sign-in security.

## `authentication_flow_policy`

Configures the tenant's authentication flows policy (`policies/authenticationFlowsPolicy`, beta).

- `selfServiceSignUpEnabled = false` — disables self-service sign-up, so external users can't request to join without an invite or admin-provisioned flow.

## `authorization_policy`

Configures the tenant's authorization policy (`policies/authorizationPolicy`) — a singleton that always exists, adopted here via `import`.

- `allowedToSignUpEmailBasedSubscriptions = false` — blocks users signing up for email-based subscriptions outside admin control.
- `allowedToUseSSPR = true` — lets administrators use self-service password reset (SSPR).
- `allowEmailVerifiedUsersToJoinOrganization = false` — blocks users joining the tenant purely by verifying an email domain match.
- `allowInvitesFrom = "adminsAndGuestInviters"` — restricts who can invite guests to admin and Guest Inviter roles, rather than every member (`everyone`, the cloud default) or `adminsGuestInvitersAndAllMembers`.
- `blockMsolPowerShell = true` — blocks the retired MSOnline (MSOL) PowerShell module's service principal from authenticating. MSOL predates modern authentication controls and is an unsupported, unmonitored administrative access path (Maester MT.1185, High severity).
- `defaultUserRolePermissions` — least-privilege defaults for standard (non-admin) users:
  - `allowedToCreateApps = false`, `allowedToCreateSecurityGroups = false`, `allowedToCreateTenants = false` — non-admins can't create apps, security groups, or new tenants.
  - `allowedToReadBitlockerKeysForOwnedDevice = false` — users can't self-service read their own device's BitLocker recovery key; recovery goes through the help desk.
  - `allowedToReadOtherUsers = false` — restricts the directory-wide read of other users' profiles.
  - `permissionGrantPoliciesAssigned` — scopes user application-consent to Microsoft's dynamically-managed, low-risk permission sets rather than broad self-service consent.
- `guestUserRoleId` — set to the built-in **Restricted Guest User** role template ID, so guests get the most limited directory visibility by default.

## `external_identity_policy`

Configures the tenant's external identities policy (`policies/externalIdentitiesPolicy`, beta).

- `allowExternalIdentitiesToLeave = true` — lets external (B2B guest) users remove themselves from the tenant via self-service, instead of requiring an admin to manually offboard them.
- `allowDeletedIdentitiesDataRemoval = false` — currently a Microsoft Graph property **reserved for future use**; it has no effect today, kept at its default.

## `b2b_management_policy`

Configures the organization-default B2B management policy (`policies/b2bManagementPolicies`, beta). This policy controls the **Collaboration restrictions** section in External Identities.

- `b2b_invitation_domain_mode = "allow_all"` — the default. It matches **Allow invitations to be sent to any domain** and does not create a B2B management policy because Microsoft Entra already uses this behaviour by default.
- `b2b_invitation_domain_mode = "allow_list"` — matches **Allow invitations only to the specified domains**. Set `b2b_invitation_allowed_domains` to at least one allowed domain.
- `b2b_invitation_domain_mode = "block_list"` — matches **Deny invitations to the specified domains**. Set `b2b_invitation_blocked_domains` to the blocked domains.
- Terraform rejects domain lists that do not match the selected mode. Microsoft Entra supports either an allow list or a block list, not both.

To block all invitations, set `allowInvitesFrom = "none"` on `authorization_policy`. Microsoft Graph does not accept an empty B2B allow list.

> **Important:** Microsoft Graph supports this resource only on the beta endpoint. It requires the `Policy.ReadWrite.B2BManagementPolicy` application permission and admin consent. Microsoft Entra permits only one organization-default B2B management policy. Import an existing policy instead of creating another one.

## `security_defaults`

Configures the tenant's Security Defaults enforcement policy (`policies/identitySecurityDefaultsEnforcementPolicy`, beta).

- `isEnabled = false` — Security Defaults stays disabled because this tenant uses a full custom Conditional Access baseline instead (see [conditional-access.tf](conditional-access.tf)). Running both at once is redundant; Microsoft's guidance is to pick one model. Enabling Security Defaults *and* a custom CA baseline isn't itself unsafe, but this repository standardizes on CA-only.

## Secrets and imports

Every resource above targets a Microsoft Entra tenant singleton and has a matching `import` block mapping it to its fixed Microsoft Graph path. These let Terraform adopt the existing tenant configuration on first `terraform apply` instead of trying to create a resource that already exists.

## Resources

### Microsoft articles

- [authorizationPolicy resource type — Microsoft Graph](https://learn.microsoft.com/en-us/graph/api/resources/authorizationpolicy) — property reference for `blockMsolPowerShell`, `allowInvitesFrom`, `guestUserRoleId`, and `defaultUserRolePermissions`.
- [externalIdentitiesPolicy resource type — Microsoft Graph (beta)](https://learn.microsoft.com/en-us/graph/api/resources/externalidentitiespolicy) — confirms `allowDeletedIdentitiesDataRemoval` is reserved for future use and describes `allowExternalIdentitiesToLeave`.
- [authenticationFlowsPolicy resource type — Microsoft Graph](https://learn.microsoft.com/en-us/graph/api/resources/authenticationflowspolicy) — property reference for the self-service sign-up flow configuration.
- [b2bManagementPolicy resource type — Microsoft Graph (beta)](https://learn.microsoft.com/en-us/graph/api/resources/b2bmanagementpolicy?view=graph-rest-beta) — resource reference for B2B invitation domain restrictions.
- [Allow or block invitations — Microsoft Entra External ID](https://learn.microsoft.com/en-us/entra/external-id/allow-deny-list) — describes the portal's allow-list and block-list behaviour.

### Maester test files

- [MT.1185 — Block legacy MSOnline (MSOL) PowerShell module](https://maester.dev/docs/tests/MT.1185) — confirms `authorization_policy.blockMsolPowerShell` stays `true`.

### NCSC articles

- [NCSC Zero Trust Architecture — Principle 3: User identity](https://www.ncsc.gov.uk/guidance/zero-trust-architecture-point-3) — supports least-privilege default user permissions (no self-service app, group, or tenant creation) and restricted guest access.
