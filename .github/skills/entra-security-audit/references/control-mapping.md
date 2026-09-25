# Map controls to evidence

This is the single active control mapping for the Entra skill collection.
Use it to locate candidate evidence, not to certify a tenant. Read each current test page and assertion before citing a finding.
The mappings below were checked on 2026-09-21. Historical, broader mappings remain in the repository backup and are not verified substitutes.

| Control | Maester evidence | What the evidence establishes | Limits |
| --- | --- | --- | --- |
| Emergency-access exclusions | [MT.1005](https://maester.dev/docs/tests/MT.1005/) | Checks policies for emergency-account or group exclusions | Does not prove recovery accounts are usable or correctly protected |
| Device compliance | [MT.1001](https://maester.dev/docs/tests/MT.1001/) | Checks for a Conditional Access policy with device compliance | Not an emergency-access test |
| MFA for administrators | [MT.1006](https://maester.dev/docs/tests/MT.1006/) | Checks for an MFA policy for administrators | Does not by itself establish phishing resistance or user-consent restrictions |
| MFA for all users | [MT.1007](https://maester.dev/docs/tests/MT.1007/) | Checks for an MFA policy targeting all users | Verify exclusions, state, and actual assertion coverage |
| Other legacy authentication | [MT.1009](https://maester.dev/docs/tests/MT.1009/) | Checks for a policy blocking other legacy authentication | Distinct from Exchange ActiveSync coverage |
| Exchange ActiveSync legacy authentication | [MT.1010](https://maester.dev/docs/tests/MT.1010/) | Checks for a policy blocking legacy Exchange ActiveSync | Not the all-users MFA test |

For phishing-resistant MFA, look up the current CISA control and inspect the exact authentication-strength assertion.
Do not substitute an ordinary MFA test or a guest-MFA test for phishing-resistant administrator coverage.
For FIDO2 attestation, inspect the actual configured value and method-specific test; a benchmark recommendation is not evidence that attestation is enabled.

Microsoft's [MFA policy guidance](https://learn.microsoft.com/en-us/entra/identity/conditional-access/policy-all-users-mfa-strength) provides targeting and rollout context.
Its [emergency-access guidance](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/security-emergency-access) covers recovery design beyond exclusion checks.
These are contextual sources, not claims that passing the tests establishes complete compliance.

For requested NCSC alignment, verify the precise current guidance and label conceptual alignment separately from direct technical assertions.
Do not invent numbered principles or reproduce unverified quotations from an older mapping.
