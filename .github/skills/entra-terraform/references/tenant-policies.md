# Manage organization details and tenant policies

Inspect each actual resource and endpoint. Organization properties, authorization, authentication flows, external identities, invitation restrictions, and Security Defaults are separate controls.
Prefer a supported typed resource for authentication strengths. Reference managed resources directly rather than introducing duplicate IDs or variables.

For authorization changes, identify affected standard users, guests, app consent, and recovery flows.
For organization contacts, explain whether clearing a collection removes operational notification recipients.
For B2B invitation restrictions, distinguish policy absence, an unrestricted mode, an allow list, and a block list.
Preserve validation rules and existing-policy adoption intent.

Keep Security Defaults disabled when maintaining an established custom Conditional Access baseline.
For a new transition, plan continuous protection and staged enforcement rather than treating disabling Security Defaults as an isolated hardening step.

Use the [permission matrix](permissions.md) for specific operations. Do not carry permissions from deleted resources into a file-wide requirement list.
Use [imports and state](imports-and-state.md) to distinguish fixed policies from created collection members and custom authentication strengths.

Record API-version constraints and unsupported or unverified properties. Never infer successful tenant enforcement from a Terraform schema check alone.
