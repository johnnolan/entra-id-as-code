# Maester Core Test Index (MT.*)

Lightweight, locally cached index of Maester's core `MT.*` tests, for fast lookup during an audit. Sourced from the
stable release listing: https://maester.dev/docs/tests/maester/

**This index has titles only — no descriptions or remediation text.** Always fetch the individual test page
(`https://maester.dev/docs/tests/<Test ID>`) to verify the current description, rationale, and remediation before
citing it in code or documentation. Do not treat this file as a citable source by itself.

Refresh this index periodically (or when a lookup misses) by re-fetching the listing page above — do not fetch
`/docs/next/tests/maester/` (unreleased preview) for anything you plan to cite to a user.

A few IDs (`MT.1024`, `MT.1033`, `MT.1034`) generate one result per matching object at runtime, so their titles
contain PowerShell template placeholders in the listing — treat those as families of related findings, not a single
fixed message.

| Test ID | Title | Severity | Category |
| :--- | :--- | :--- | :--- |
| MT.1001 | At least one Conditional Access policy is configured with device compliance. | Medium | CA |
| MT.1002 | App management restrictions on applications and service principals is configured and enabled. | High | App |
| MT.1003 | At least one Conditional Access policy is configured with All Apps. | High | CA |
| MT.1004 | At least one Conditional Access policy is configured with All Apps and All Users. | High | CA |
| MT.1005 | All Conditional Access policies are configured to exclude at least one emergency/break glass account or group. | High | CA |
| MT.1006 | At least one Conditional Access policy is configured to require MFA for admins. | High | CA |
| MT.1007 | At least one Conditional Access policy is configured to require MFA for all users. | High | CA |
| MT.1008 | At least one Conditional Access policy is configured to require MFA for Azure management. | High | CA |
| MT.1009 | At least one Conditional Access policy is configured to block other legacy authentication. | High | CA |
| MT.1010 | At least one Conditional Access policy is configured to block legacy authentication for Exchange ActiveSync. | High | CA |
| MT.1011 | At least one Conditional Access policy is configured to secure security info registration only from a trusted location. | High | CA |
| MT.1012 | At least one Conditional Access policy is configured to require MFA for risky sign-ins. | High | CA |
| MT.1013 | At least one Conditional Access policy is configured to require new password when user risk is high. | High | CA |
| MT.1014 | At least one Conditional Access policy is configured to require compliant or Entra hybrid joined devices for admins. | High | CA |
| MT.1015 | At least one Conditional Access policy is configured to block access for unknown or unsupported device platforms. | Medium | CA |
| MT.1016 | At least one Conditional Access policy is configured to require MFA for guest access. | High | CA |
| MT.1017 | At least one Conditional Access policy is configured to enforce non persistent browser session for non-corporate devices. | High | CA |
| MT.1018 | At least one Conditional Access policy is configured to enforce sign-in frequency for non-corporate devices. | Medium | CA |
| MT.1019 | At least one Conditional Access policy is configured to enable application enforced restrictions. | Medium | CA |
| MT.1020 | All Conditional Access policies are configured to exclude directory synchronization accounts or do not scope them. | High | CA |
| MT.1021 | Security Defaults are enabled. | High | CA |
| MT.1022 | All users utilizing a P1 license should be licensed. | Medium | CA |
| MT.1023 | All users utilizing a P2 license should be licensed. | Medium | CA |
| MT.1024 | *(dynamic per-recommendation finding)* | Unknown | Entra |
| MT.1025 | No external user with permanent role assignment on Control Plane. | High | Privileged |
| MT.1026 | No hybrid user with permanent role assignment on Control Plane. | High | Privileged |
| MT.1027 | No Service Principal with Client Secret and permanent role assignment on Control Plane. | High | Privileged |
| MT.1028 | No user with mailbox and permanent role assignment on Control Plane. | High | Privileged |
| MT.1029 | Stale accounts are not assigned to privileged roles. | High | Privileged |
| MT.1030 | Eligible role assignments on Control Plane are in use by administrators. | High | Privileged |
| MT.1031 | Privileged role on Control Plane are managed by PIM only. | High | Privileged |
| MT.1032 | Limited number of Global Admins are assigned. | High | Privileged |
| MT.1033 | *(dynamic per-user finding)* User should be blocked from using legacy authentication. | Unknown | CA |
| MT.1034 | *(dynamic per-user finding)* Emergency access users should not be blocked. | Unknown | CA |
| MT.1035 | All security groups assigned to Conditional Access Policies should be protected by RMAU. | High | CA |
| MT.1036 | All excluded objects should have a fallback include in another policy. | Medium | CA |
| MT.1037 | Only users with Presenter role are allowed to present in Teams meetings | High | Teams |
| MT.1038 | Conditional Access policies should not include or exclude deleted groups. | Medium | CA |
| MT.1039 | Ensure MailTips are enabled for end users | Low | Exchange |
| MT.1041 | Ensure users installing Outlook add-ins is not allowed | High | Exchange |
| MT.1042 | Restrict dial-in users from bypassing a meeting lobby | Medium | Teams |
| MT.1043 | Ensure Spam confidence level (SCL) is configured in mail transport rules with specific domains | Medium | Exchange |
| MT.1044 | Ensure modern authentication for Exchange Online is enabled | High | Exchange |
| MT.1045 | Only invited users should be automatically admitted to Teams meetings | Medium | Teams |
| MT.1046 | Restrict anonymous users from joining meetings | Medium | Teams |
| MT.1047 | Restrict anonymous users from starting Teams meetings | Medium | Teams |
| MT.1048 | Limit external participants from having control in a Teams meeting | Medium | Teams |
| MT.1049 | Conditional Access policies for User Risk and Sign-in Risk should be configured separately. | High | CA |
| MT.1050 | Apps with high-risk permissions having a direct path to Global Administrator | High | App |
| MT.1051 | Apps with high-risk permissions having an indirect path to Global Administrator | High | App |
| MT.1052 | At least one Conditional Access policy is targeting the Device Code authentication flow. | High | CA |
| MT.1053 | Ensure intune device clean-up rule is configured | Medium | Intune |
| MT.1054 | Ensure built-in Device Compliance Policy marks devices with no compliance policy assigned as 'Not compliant' | Medium | Intune |
| MT.1055 | Microsoft 365 Group (and Team) creation should be restricted to approved users. | Medium | Group |
| MT.1056 | Ensure that no person has permanent access to all Azure subscriptions at the root scope | High | Privileged |
| MT.1057 | Upstream title says group-expiration notification, but the stable test implementation checks app registrations for client secrets. | Medium | App |
| MT.1058 | Ensure Microsoft 365 Group (and Team) expiration is configured to auto-expire groups. | Medium | App |
| MT.1059 | Microsoft Defender for Identity health issues should be resolved | Medium | Defender |
| MT.1061 | Device registration MFA control conflicts with Conditional Access policies | Medium | CA |
| MT.1062 | Ensure Direct Send is set to be rejected | Medium | Exchange |
| MT.1063 | All app registration owners should have MFA registered | High | App |
| MT.1064 | Management group creation should be limited to users with explicit write access | High | Azure |
| MT.1065 | Soft Delete should be enabled on all Recovery Services Vaults | High | Backup |
| MT.1066 | Conditional Access policies should not include or exclude deleted users, groups, or roles. | Medium | CA |
| MT.1067 | Authentication methods policies should not reference deleted groups. | Medium | Authentication |
| MT.1068 | Restrict non-admin users from creating tenants | Medium | Entra |
| MT.1069 | Restrict non-admin users from creating security groups. | Low | Entra |
| MT.1070 | Restrict device join to selected users/groups or none. | Medium | Entra |
| MT.1071 | At least one Conditional Access policy explicitly includes Azure DevOps. | Medium | CA |
| MT.1072 | Conditional Access policies should not use the deprecated Approved Client App grant. | High | CA |
| MT.1073 | Soft- and hard-matching of synchronized objects should be blocked. | Medium | Entra |
| MT.1074 | Mailboxes should not send outbound mails using the .onmicrosoft.com domain. | Medium | Exchange |
| MT.1075 | Third Party Entra Apps should only have explicitly assigned users instead of All Users. | Medium | App |
| MT.1076 | MOERA SHOULD NOT be used for sent mail. | High | Exchange |
| MT.1077 | App registrations with privileged API permissions should not have owners | Medium | Privileged |
| MT.1078 | App registrations with highly privileged directory roles should not have owners | Medium | Privileged |
| MT.1079 | Privileged API permissions on service principals should not remain unused | Medium | Privileged |
| MT.1080 | Credentials, tokens, or cookies from highly privileged users should not be exposed on vulnerable endpoints | Medium | Privileged |
| MT.1081 | Hybrid users should not be assigned Entra ID role assignments | Medium | Privileged |
| MT.1083 | Ensure Delicensing Resiliency is enabled | Low | Exchange |
| MT.1084 | Seamless Single SignOn should be disabled for all domains in EntraID Connect servers. | High | Entra |
| MT.1085 | Pending approvals for Critical Asset Management should not be present | Medium | Entra |
| MT.1086 | Devices should not share both critical and non-critical user credentials. | Low | XSPM |
| MT.1087 | Devices should not be publicly exposed with remotely exploitable, highly likely to be exploited, high or critical severity CVE's. | High | XSPM |
| MT.1088 | Devices with critical credentials should be protected by TPM. | Medium | XSPM |
| MT.1089 | Devices with critical credentials should be protected by Credential Guard. | Medium | XSPM |
| MT.1090 | Global Administrator role should not be added as local administrator on the device during Microsoft Entra join | Medium | Entra |
| MT.1091 | Registering user should not be added as local administrator on the device during Microsoft Entra join | Medium | Entra |
| MT.1092 | Intune APNS certificate should be valid for more than 30 days | High | Intune |
| MT.1093 | Apple Automated Device Enrollment Tokens should be valid for more than 30 days | High | Intune |
| MT.1094 | Apple Volume Purchase Program Tokens should be valid for more than 30 days | High | Intune |
| MT.1095 | Android Enterprise Account Connection should be healthy | High | Intune |
| MT.1096 | Intune Multi Admin approval should be configured | Medium | Intune |
| MT.1097 | Certificate Connectors should be healthy and running supported versions | High | Intune |
| MT.1098 | Mobile Threat Defense Connectors should be healthy | Critical | Intune |
| MT.1099 | Windows Diagnostic Data Processing should be enabled | Low | Intune |
| MT.1100 | Intune Audit Logs should be retained | High | Intune |
| MT.1101 | Default Branding Profile should be customized | Low | Intune |
| MT.1102 | Windows Feature Update Policy Settings should not reference end of support builds | High | Intune |
| MT.1103 | Intune RBAC groups should be protected by Restricted Management Administrative Units or Role Assignable groups | High | Intune |
| MT.1105 | MDM Authority should be set to Microsoft Intune | Low | Intune |
| MT.1106 | Catalog resources must have valid roles (no stale app roles or deleted SPNs) | Medium | Governance |
| MT.1107 | Access packages and catalogs should not reference deleted groups | Medium | Governance |
| MT.1108 | Access packages should not have inactive or orphaned assignment policies | Medium | Governance |
| MT.1109 | Access package approval workflows must have valid approvers | Medium | Governance |
| MT.1110 | No catalog should contain resources without any associated access packages | Medium | Governance |
| MT.1111 | High privileged user should be linked to an identity | Low | Privileged |
| MT.1112 | Privileged user accounts should not remain enabled when the linked primary account is disabled | Medium | Privileged |
| MT.1113 | AI agents should not be shared with broad access control policies | High | AIAgent |
| MT.1114 | AI agents should require user authentication | High | AIAgent |
| MT.1115 | AI agents should not have risky HTTP configurations | Medium | AIAgent |
| MT.1116 | AI agents should not send email with AI-controlled inputs | High | AIAgent |
| MT.1117 | Published AI agents should not be dormant | Low | AIAgent |
| MT.1118 | AI agents should avoid using author (maker) authentication for tools | Medium | AIAgent |
| MT.1119 | AI agents should not have hard-coded credentials in topics | High | AIAgent |
| MT.1120 | AI agents should not use MCP server tools without review | Medium | AIAgent |
| MT.1121 | AI agents with generative orchestration should have custom instructions | Medium | AIAgent |
| MT.1122 | AI agents should not have orphaned ownership | Medium | AIAgent |
| MT.1123 | Ensure BitLocker full disk encryption is configured via Intune | High | Intune |
| MT.1147 | Do not sync krbtgt_AzureAD to Entra ID | High | Entra |
| MT.1148 | Archive Scanning should be enabled | High | Defender |
| MT.1149 | Behavior Monitoring should be enabled | High | Defender |
| MT.1150 | Cloud Protection should be enabled | High | Defender |
| MT.1151 | Email Scanning should be enabled | High | Defender |
| MT.1152 | Script Scanning should be enabled | High | Defender |
| MT.1153 | Real-time Monitoring should be enabled | High | Defender |
| MT.1154 | Full Scan Removable Drives should be enabled | High | Defender |
| MT.1155 | Full Scan Mapped Drives should be disabled for performance | High | Defender |
| MT.1156 | Scanning Network Files should be enabled | High | Defender |
| MT.1157 | CPU Load Factor should be optimized (20-30%) | High | Defender |
| MT.1158 | Scan should be scheduled | High | Defender |
| MT.1159 | Quick Scan Time configuration is not required | High | Defender |
| MT.1160 | Signatures should be checked before scan | High | Defender |
| MT.1161 | Cloud Block Level should be High or higher | High | Defender |
| MT.1162 | Cloud Extended Timeout should be 30-50 seconds | High | Defender |
| MT.1163 | Signature Update Interval should be 1-4 hours | High | Defender |
| MT.1164 | PUA Protection should be enabled | High | Defender |
| MT.1165 | Network Protection should be enabled | High | Defender |
| MT.1166 | Local Admin Merge should be disabled | High | Defender |
| MT.1167 | Real-Time Scan Direction should cover both directions | High | Defender |
| MT.1168 | Cleaned Malware should be retained for at least 30 days | High | Defender |
| MT.1169 | Catch-up Full Scan should be disabled | High | Defender |
| MT.1170 | Catch-up Quick Scan should be disabled | High | Defender |
| MT.1171 | Sample Submission should send safe samples automatically | High | Defender |
| MT.1172 | Unified audit log ingestion is enabled | High | Purview |
| MT.1173 | Sensitivity labels are published for files used by Microsoft 365 Copilot | Medium | Purview |
| MT.1174 | Insider Risk Management policy for Risky AI usage is enabled | Medium | Purview |
| MT.1175 | DLP policy is configured for the Microsoft 365 Copilot location | High | Purview |
| MT.1176 | Retention policy is configured for the Microsoft Copilot location | Medium | Purview |
| MT.1177 | Ensure LAPS Configuration Policy is properly set | Unknown | Intune |
| MT.1178 | Ensure ASR Rules are configured correctly | High | Intune |
| MT.1179 | Ensure App Control for Business is enabled | High | Intune |
| MT.1180 | Ensure Managed Installer Rules are configured correctly | Medium | Intune |
| MT.1181 | Conditional Access policy is present that blocks high agent risk signins | High | CA |
| MT.1182 | Entra managed and verified domains should have mature DMARC policy (p=reject, pct=100). | Unknown | Entra |
| MT.1183 | Temporary bypass for onPremisesObjectIdentifier updates should be disabled | Medium | Entra |
| MT.1184 | Conditional Access policy without any target resources configured | Medium | CA |
| MT.1185 | Block legacy MSOnline (MSOL) PowerShell module | High | Entra |
| MT.1186 | High-privilege first-party Entra Apps should only have explicitly assigned users instead of All Users. | High | Entra |
| MT.1187 | The Microsoft 365 traffic forwarding profile in Global Secure Access should be enabled | Unknown | Entra |
| MT.1188 | Entra Private Access applications should be covered by a Conditional Access policy that requires a managed device | Unknown | Entra |
| MT.1189 | Groups assigned to Global Secure Access traffic forwarding profiles should not be nested | Unknown | Entra |
| MT.1190 | Entra Private Access applications should not use the Default connector group | Unknown | Entra |
| MT.1191 | Break-glass accounts should be excluded from the Compliant Network Conditional Access policy | Unknown | Entra |
| MT.1192 | Groups assigned to Entra Private Access applications should not be nested | Unknown | Entra |
| MT.1193 | Entra Private Access application segments should avoid broad or risky destinations | Unknown | Entra |
| MT.1194 | The baseline Global Secure Access security profile should enforce a threat-intelligence floor | Unknown | Entra |
| MT.1195 | The Quick Access app should not be subject to a sign-in frequency Conditional Access control | Unknown | Entra |
