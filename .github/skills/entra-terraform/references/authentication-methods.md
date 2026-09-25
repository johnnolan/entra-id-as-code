# Configure authentication methods

Discover the policy root and every method configuration, including methods not listed in older examples.
Read each method's `state`, target groups, exclusions, and fixed import identifier. Review root migration settings separately.
Method availability and Conditional Access enforcement are different controls; changing one does not establish the other.

Check the installed provider before choosing a typed resource or Graph. Match the Graph endpoint and payload to the method and API version.
The root and FIDO2 update APIs document `Policy.ReadWrite.AuthenticationMethod`; verify other method operations individually in the [permission workflow](permissions.md).
Do not infer a need for user-credential management permissions from tenant policy configuration.

Before disabling a method, assess enrollment, recovery, guest access, and affected users.
Before changing attestation or allowed authenticator models, assess existing passkeys, supported hardware, and registration impact.
Prefer phishing-resistant methods where the scenario requires them, while preserving explicitly approved recovery and compatibility decisions.
Do not silently enforce a benchmark setting during unrelated edits.

Preserve imports for existing method configurations. Check that target groups remain valid.
Distinguish observed configuration from intended baseline and from tenant behavior that needs authenticated validation.

Sources:

- [Update authentication methods policy](https://learn.microsoft.com/en-us/graph/api/authenticationmethodspolicy-update?view=graph-rest-1.0)
- [Update FIDO2 configuration](https://learn.microsoft.com/en-us/graph/api/fido2authenticationmethodconfiguration-update?view=graph-rest-1.0)
