# Security Groups

This guide explains how to discover `GROUPS_SETTINGS_ID` and `GROUP_LIFECYCLE_POLICY_ID` for resources in [terraform/security-groups.tf](terraform/security-groups.tf).

Use these IDs only when the resources already exist in the tenant and you want Terraform to adopt them.

## When you need these IDs

You need IDs for import when:

- A Group Lifecycle Policy already exists.
- A Group.Unified Group Settings object already exists.

You do not need IDs when:

- The API returns no existing objects.
- You want Terraform to create resources from scratch.

## Install Azure CLI on Fedora 44

Run:

```bash
# 1) Add Microsoft package signing key
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

# 2) Add Azure CLI repo
sudo tee /etc/yum.repos.d/azure-cli.repo >/dev/null <<'EOF'
[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

# 3) Install Azure CLI
sudo dnf install -y azure-cli

# 4) Verify
az version
```

## Authenticate for Microsoft Graph

Sign in and ensure you request a Graph token (a token for Microsoft Graph API):

```bash
az login --tenant <TENANT_ID>
az account get-access-token --resource-type ms-graph --query "{tenant:tenant,expires:expiresOn}" -o table
```

If you get `Unauthorized` or `Permission denied`, ensure your identity or app registration has Graph permissions such as `Group.Read.All` and `Directory.Read.All`.

## Get GROUP_LIFECYCLE_POLICY_ID

Run:

```bash
az rest --resource https://graph.microsoft.com/ \
	--method GET \
	--url "https://graph.microsoft.com/v1.0/groupLifecyclePolicies?$select=id,groupLifetimeInDays,managedGroupTypes"
```

Read the response:

- If `"value": []`, no lifecycle policy exists. Terraform should create one.
- If `value` has an object, copy `id` as `GROUP_LIFECYCLE_POLICY_ID`.

## Get GROUPS_SETTINGS_ID (Group.Unified)

Run:

```bash
az rest --resource https://graph.microsoft.com/ \
	--method GET \
	--url "https://graph.microsoft.com/v1.0/groupSettings?$select=id,displayName,templateId"
```

Find the entry where:

- `templateId` is `62375ab9-6b52-47ed-826b-58e47e0e304b` (the Group.Unified template).

Copy that object `id` as `GROUPS_SETTINGS_ID`.

## Import commands (only if resources already exist)

Use these commands from [terraform](terraform):

```bash
terraform import msgraph_resource.group_lifecycle_policy groupLifecyclePolicies/<GROUP_LIFECYCLE_POLICY_ID>
terraform import msgraph_resource.groups_settings groupSettings/<GROUPS_SETTINGS_ID>
```

## Terraform behavior in this repository

In [terraform/security-groups.tf](terraform/security-groups.tf):

- Import blocks are intentionally not active for these two resources.
- The default behavior is create-if-missing.
- You should import only when you confirm objects already exist.
