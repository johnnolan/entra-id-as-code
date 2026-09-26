---
name: terraform-service-principles-permissions
description: Trigger when creating, reviewing, or modifying application and service-principal definitions in terraform/service-principles.tf; confirm the required Graph permissions and AzureAD resource selection.
compatibility: Requires terraform, azuread provider ~> 3.0, and msgraph provider ~> 0.4
---

# terraform-service-principles-permissions

## When To Use
- Apply this skill for any change to `terraform/service-principles.tf`.
- Use it when validating application registration and federated identity updates.
- Use it when checking the minimum Graph permissions needed for service principal management.

## File Scope
- `terraform/service-principles.tf`

## Provider Selection
- Prefer `azuread_application` for application registrations and `azuread_application_federated_identity_credential` for the federation credential resource.
- Use Graph-based resources only for APIs and fields not yet supported by the AzureAD provider.

## Required Microsoft Graph Application Permissions
- `Application.ReadWrite.All`
- `Directory.ReadWrite.All`
- `AppRoleAssignment.ReadWrite.All`

## Resources Covered
- `azuread_application.maester`
- `azuread_application_federated_identity_credential.maester`

## Guardrails
- Keep app registrations least-privilege and aligned to the workload's actual use case.
- Do not add broad app permissions beyond what the workload needs.
- Maintain explicit grant and federation values rather than broad secret-based access.
- Keep deployment-safe configuration values in variables or in approved repository-managed assets.
