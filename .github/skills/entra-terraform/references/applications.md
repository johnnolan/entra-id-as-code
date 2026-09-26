# Manage applications and federation

Distinguish an application registration, its service principal, requested permissions, app-role assignments, and delegated consent grants.
Discover which objects the configuration actually manages. Requested API permissions do not establish that consent is granted.

Use typed application and federated-credential resources when supported by the selected provider.
For service-principal authentication, provider documentation offers `Application.ReadWrite.OwnedBy` with ownership conditions, or `Application.ReadWrite.All`.
Do not assume ownership exists. Adding an owner is a security decision, especially for a privileged application.
Additional user-owner lookups or role grants need their own permission analysis.

Separate the Terraform execution identity's permissions from the permissions requested for the application being created.
Do not add `Directory.ReadWrite.All` or `AppRoleAssignment.ReadWrite.All` as blanket requirements for application creation and federation.

For federation, verify issuer, audience, and subject against the intended workload and trust boundary.
Preserve explicit repository, branch, or environment scope. Do not copy another repository's subject or introduce a client secret as a troubleshooting shortcut.
Review replacement and rollback implications before changing identity or credential identifiers.

Sources:

- [Application resource](https://raw.githubusercontent.com/hashicorp/terraform-provider-azuread/main/docs/resources/application.md)
- [Application federated credential](https://raw.githubusercontent.com/hashicorp/terraform-provider-azuread/main/docs/resources/application_federated_identity_credential.md)
