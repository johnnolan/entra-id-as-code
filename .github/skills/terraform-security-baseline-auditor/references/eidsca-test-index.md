# EIDSCA Test Index

Lightweight, locally cached index of Maester's Entra ID Security Config Analyzer (EIDSCA) tests, for fast lookup
during an audit. Sourced from the stable release listing: https://maester.dev/docs/tests/eidsca/

**This index has titles only — no descriptions or remediation text.** Always fetch the individual test page
(`https://maester.dev/docs/tests/<Test ID>`) to verify the current description, rationale, and remediation before
citing it in code or documentation. Do not treat this file as a citable source by itself.

Refresh this index periodically (or when a lookup misses) by re-fetching the listing page above — do not fetch
`/docs/next/tests/eidsca/` (unreleased preview) for anything you plan to cite to a user.

| Test ID | Title | Severity |
| :--- | :--- | :--- |
| EIDSCA.AF01 | Authentication Method - FIDO2 security key - State. | High |
| EIDSCA.AF02 | Authentication Method - FIDO2 security key - Allow self-service set up. | Medium |
| EIDSCA.AF03 | Authentication Method - FIDO2 security key - Enforce attestation. | High |
| EIDSCA.AF04 | Authentication Method - FIDO2 security key - Enforce key restrictions. | High |
| EIDSCA.AF05 | Authentication Method - FIDO2 security key - Restricted. | High |
| EIDSCA.AF06 | Authentication Method - FIDO2 security key - Restrict specific keys. | Medium |
| EIDSCA.AG01 | Authentication Method - General Settings - Manage migration. | High |
| EIDSCA.AG02 | Authentication Method - General Settings - Report suspicious activity - State. | Medium |
| EIDSCA.AG03 | Authentication Method - General Settings - Report suspicious activity - Included users/groups. | Medium |
| EIDSCA.AM01 | Authentication Method - Microsoft Authenticator - State. | High |
| EIDSCA.AM02 | Authentication Method - Microsoft Authenticator - Allow use of Microsoft Authenticator OTP. | Medium |
| EIDSCA.AM03 | Authentication Method - Microsoft Authenticator - Require number matching for push notifications. | Medium |
| EIDSCA.AM04 | Authentication Method - Microsoft Authenticator - Included users/groups of number matching for push notifications. | Medium |
| EIDSCA.AM06 | Authentication Method - Microsoft Authenticator - Show application name in push and passwordless notifications. | Medium |
| EIDSCA.AM07 | Authentication Method - Microsoft Authenticator - Included users/groups to show application name in push and passwordless notifications. | Medium |
| EIDSCA.AM09 | Authentication Method - Microsoft Authenticator - Show geographic location in push and passwordless notifications. | Medium |
| EIDSCA.AM10 | Authentication Method - Microsoft Authenticator - Included users/groups to show geographic location in push and passwordless notifications. | Medium |
| EIDSCA.AP01 | Default Authorization Settings - Enabled Self service password reset for administrators. | High |
| EIDSCA.AP04 | Default Authorization Settings - Guest invite restrictions. | Medium |
| EIDSCA.AP05 | Default Authorization Settings - Sign-up for email based subscription. | Medium |
| EIDSCA.AP06 | Default Authorization Settings - User can join the tenant by email validation. | Medium |
| EIDSCA.AP07 | Default Authorization Settings - Guest user access. | High |
| EIDSCA.AP08 | Default Authorization Settings - User consent policy assigned for applications. | Medium |
| EIDSCA.AP09 | Default Authorization Settings - Allow user consent on risk-based apps. | Medium |
| EIDSCA.AP10 | Default Authorization Settings - Default User Role Permissions - Allowed to create Apps. | High |
| EIDSCA.AP14 | Default Authorization Settings - Default User Role Permissions - Allowed to read other users. | High |
| EIDSCA.AS04 | Authentication Method - SMS - Use for sign-in. | High |
| EIDSCA.AT01 | Authentication Method - Temporary Access Pass - State. | High |
| EIDSCA.AT02 | Authentication Method - Temporary Access Pass - One-time. | High |
| EIDSCA.AV01 | Authentication Method - Voice call - State. | High |
| EIDSCA.CP01 | Default Settings - Consent Policy Settings - Group owner consent for apps accessing data. | High |
| EIDSCA.CP03 | Default Settings - Consent Policy Settings - Block user consent for risky apps. | High |
| EIDSCA.CP04 | Default Settings - Consent Policy Settings - Users can request admin consent to apps they are unable to consent to. | Medium |
| EIDSCA.CR01 | Consent Framework - Admin Consent Request - Policy to enable or disable admin consent request feature. | High |
| EIDSCA.CR02 | Consent Framework - Admin Consent Request - Reviewers will receive email notifications for requests. | Medium |
| EIDSCA.CR03 | Consent Framework - Admin Consent Request - Reviewers will receive email notifications when admin consent requests are about to expire. | Medium |
| EIDSCA.CR04 | Consent Framework - Admin Consent Request - Consent request duration (days). | High |
| EIDSCA.PR01 | Default Settings - Password Rule Settings - Password Protection - Mode. | High |
| EIDSCA.PR02 | Default Settings - Password Rule Settings - Password Protection - Enable password protection on Windows Server Active Directory. | High |
| EIDSCA.PR03 | Default Settings - Password Rule Settings - Enforce custom list. | Medium |
| EIDSCA.PR05 | Default Settings - Password Rule Settings - Smart Lockout - Lockout duration in seconds. | Medium |
| EIDSCA.PR06 | Default Settings - Password Rule Settings - Smart Lockout - Lockout threshold. | Medium |
| EIDSCA.ST08 | Default Settings - Classification and M365 Groups - M365 groups - Allow Guests to become Group Owner. | Medium |
| EIDSCA.ST09 | Default Settings - Classification and M365 Groups - M365 groups - Allow Guests to have access to groups content. | Medium |
