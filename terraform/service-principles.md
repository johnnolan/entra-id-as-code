# Maester application and federated credential

This file creates the Microsoft Entra application used by Maester and gives GitHub Actions a secretless federated identity credential.

## `maester`

Creates a single-tenant `azuread_application` named `Maester`.

- `sign_in_audience = "AzureADMyOrg"` limits sign-in to this tenant.
- `feature_tags.enterprise = true` marks the linked service principal as an enterprise application.
- `feature_tags.gallery = false` identifies it as a custom, non-gallery application.
- `logo_image` loads the repository's Maester image.
- The OAuth 2.0 implicit grant is disabled for access and ID tokens.
- No password or certificate credential is created.

The application requests these Microsoft Graph application permissions:

- `User.Read.All`
- `AuditLog.Read.All`
- `DeviceManagementConfiguration.Read.All`
- `DeviceManagementManagedDevices.Read.All`
- `DeviceManagementRBAC.Read.All`
- `DeviceManagementServiceConfig.Read.All`
- `Directory.Read.All`
- `DirectoryRecommendations.Read.All`
- `EntitlementManagement.Read.All`
- `IdentityRiskEvent.Read.All`
- `NetworkAccess.Read.All`
- `OnPremDirectorySynchronization.Read.All`
- `OrgSettings-AppsAndServices.Read.All`
- `OrgSettings-Forms.Read.All`
- `Policy.Read.All`
- `Policy.Read.ConditionalAccess`
- `Reports.Read.All`
- `ReportSettings.Read.All`
- `RoleEligibilitySchedule.Read.Directory`
- `RoleManagement.Read.All`
- `RoleManagementAlert.Read.Directory`
- `SecurityIdentitiesHealth.Read.All`
- `SecurityIdentitiesSensors.Read.All`
- `ThreatHunting.Read.All`
- `UserAuthenticationMethod.Read.All`

These declarations request permissions but do not grant tenant-wide admin consent. Grant consent separately and review additions against least privilege.

> **Security consideration:** The current `logout_url` is `https://empty-redirect-uri`, which is a placeholder rather than an application-owned logout endpoint. Remove it if unused or replace it with a controlled HTTPS endpoint.

## `maester` federated identity credential

Creates an `azuread_application_federated_identity_credential` for GitHub Actions.

- `issuer = "https://token.actions.githubusercontent.com"` trusts GitHub's OIDC issuer.
- `audiences = ["api://AzureADTokenExchange"]` restricts the accepted token audience.
- `subject` scopes trust to the configured repository and `main` branch.
- Microsoft requires issuer, subject, and audience values to match the external token case-sensitively.

Workload identity federation avoids storing and rotating a client secret. Review the subject whenever the repository owner, repository identity, branch, or environment changes.

## Required permissions

The identity running Terraform needs one of these Microsoft Graph application permissions to manage both resources:

- `Application.ReadWrite.OwnedBy`, when the Terraform principal owns the application
- `Application.ReadWrite.All`

The requested Maester permissions listed above belong to the created application, not to the Terraform execution identity.

## Maester coverage

- [MT.1063 - All app registration owners should have MFA registered](https://maester.dev/docs/tests/MT.1063) applies if owners are added.
- [MT.1077 - App registrations with privileged API permissions should not have owners](https://maester.dev/docs/tests/MT.1077) checks ownership paths on applications with privileged API permissions.
- [MT.1078 - App registrations with highly privileged directory roles should not have owners](https://maester.dev/docs/tests/MT.1078) checks ownership paths on applications with highly privileged roles.

The resource currently specifies no owners. Keep ownership decisions aligned with the application's effective permissions and delegated administration model.

## Resources

### Microsoft articles

- [Workload Identity Federation](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation)
- [Microsoft Graph permissions reference](https://learn.microsoft.com/en-us/graph/permissions-reference)

### AzureAD provider documentation

- [azuread_application](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application)
- [azuread_application_federated_identity_credential](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_federated_identity_credential)
