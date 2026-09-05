# Group lifecycle and group settings

This guide covers the Microsoft Graph resources in [terraform/group-settings.tf](terraform/group-settings.tf):

- `msgraph_resource.group_lifecycle_policy`
- `msgraph_resource.groups_settings`

These are not security-group objects themselves. They control tenant-wide group lifecycle and the default Microsoft 365 group settings template.

## What these resources do

- `group_lifecycle_policy` manages the tenant lifecycle policy for groups, including how long a group can exist before it must be reviewed or renewed.
- `groups_settings` configures the Group.Unified settings template, which is where the tenant governs things such as group creation, guest access, and naming behavior.

The default behavior is create-if-missing. Only import these resources when the tenant already contains them and you want Terraform to adopt them.

## Find an existing group lifecycle policy

Run:

```bash
az rest --resource https://graph.microsoft.com/ \
  --method GET \
  --url "https://graph.microsoft.com/v1.0/groupLifecyclePolicies?$select=id,groupLifetimeInDays,managedGroupTypes"
```

Interpret the response:

- If `"value": []`, no lifecycle policy exists and Terraform should create one.
- If an object is returned, copy the object `id` as `GROUP_LIFECYCLE_POLICY_ID`.

## Find the Group.Unified settings object

Run:

```bash
az rest --resource https://graph.microsoft.com/ \
  --method GET \
  --url "https://graph.microsoft.com/v1.0/groupSettings?$select=id,displayName,templateId"
```

Look for the record where:

- `templateId` is `62375ab9-6b52-47ed-826b-58e47e0e304b`

Copy that object's `id` as `GROUPS_SETTINGS_ID`.

## Import commands

Run these from the [terraform](terraform) folder only if the objects already exist:

```bash
terraform import msgraph_resource.group_lifecycle_policy groupLifecyclePolicies/<GROUP_LIFECYCLE_POLICY_ID>
terraform import msgraph_resource.groups_settings groupSettings/<GROUPS_SETTINGS_ID>
```

## Terraform behavior in this repository

In [terraform/group-settings.tf](terraform/group-settings.tf):

- Import blocks are intentionally not active for these resources.
- The provider uses `msgraph_resource` because AzureAD has no equivalent typed resources for these Graph objects.
- This is the correct place for tenant-wide group lifecycle and group settings policy management.

## Related file

- [terraform/security-groups.tf](terraform/security-groups.tf) contains Azure AD security group objects, not Graph group settings.
