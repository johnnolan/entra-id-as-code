<#
.SYNOPSIS
    Creates the internal-entra-iac app registration and service principal in Microsoft Entra ID.

.DESCRIPTION
    This script creates an application registration (app reg) and a service principal
    (the per-tenant identity object that represents the app) for use with the
    entra-id-as-code Terraform pipeline.

    It assigns the Microsoft Graph API permissions required by the Terraform provider.
    It does NOT add password credentials or federated credentials. Configure those
    separately after running this script.

.PREREQUISITES
    - PowerShell 7+
    - Microsoft.Graph module:  Install-Module Microsoft.Graph -Scope CurrentUser
    - An Entra ID account with the Application Administrator role or equivalent.

.USAGE
    Run the script interactively:

        ./create-github-service-principle.ps1

    The script prompts you to authenticate via a browser. Sign in with an account
    that has permission to create app registrations.

.NOTES
    After this script runs, grant admin consent for the assigned Microsoft Graph
    application roles in the Entra ID portal under:
    App registrations > internal-entra-iac > API permissions > Grant admin consent.
#>
#Requires -Modules Microsoft.Graph.Applications

[CmdletBinding()]
param()

Connect-MgGraph -Scopes "Application.ReadWrite.All"

$requiredResourceAccess = @(
    @{
        ResourceAppId  = "00000003-0000-0000-c000-000000000000"
        ResourceAccess = @(
            @{ Id = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"; Type = "Scope" } # User.Read (delegated)
            @{ Id = "1bfefb4e-e0b5-418b-a88f-73c46d2cc8e9"; Type = "Role" } # Application.ReadWrite.All
            @{ Id = "19dbc75e-c2e2-444c-a770-ec69d8559fc7"; Type = "Role" } # Directory.ReadWrite.All
            @{ Id = "7e05723c-0bb0-42da-be95-ae9f08a6e53c"; Type = "Role" } # Domain.ReadWrite.All
            @{ Id = "9acd699f-1e81-4958-b001-93b1d2506e19"; Type = "Role" } # EntitlementManagement.ReadWrite.All
            @{ Id = "62a82d76-70ea-41e2-9197-370581804d09"; Type = "Role" } # Group.ReadWrite.All
            @{ Id = "546168c3-1183-4281-9491-fafb24dea37e"; Type = "Role" } # GroupSettings.ReadWrite.All
            @{ Id = "292d869f-3427-49a8-9dab-8c70152b74e9"; Type = "Role" } # Organization.ReadWrite.All
            @{ Id = "246dd0d5-5bd0-4def-940b-0421030a5b68"; Type = "Role" } # Policy.Read.All
            @{ Id = "25f85f3c-f66c-4205-8cd5-de92dd7f0cec"; Type = "Role" } # Policy.ReadWrite.AuthenticationFlows
            @{ Id = "29c18626-4985-4dcd-85c0-193eef327366"; Type = "Role" } # Policy.ReadWrite.AuthenticationMethod
            @{ Id = "fb221be6-99f2-473f-bd32-01c6a0e9ca3b"; Type = "Role" } # Policy.ReadWrite.Authorization
            @{ Id = "886bd2d9-5b8b-4b49-adea-ca75fb50d9ef"; Type = "Role" } # Policy.ReadWrite.B2BManagementPolicy
            @{ Id = "01c0a623-fc9b-48e9-b794-0756f8e8f067"; Type = "Role" } # Policy.ReadWrite.ConditionalAccess
            @{ Id = "338163d7-f101-4c92-94ba-ca46fe52447c"; Type = "Role" } # Policy.ReadWrite.CrossTenantAccess
            @{ Id = "03cc4f92-788e-4ede-b93f-199424d144a5"; Type = "Role" } # Policy.ReadWrite.ExternalIdentities
        )
    }
)

$appParams = @{
    DisplayName            = "internal-entra-iac"
    SignInAudience         = "AzureADMyOrg"
    RequiredResourceAccess = $requiredResourceAccess
}

$app = New-MgApplication @appParams
Write-Output "Created application: $($app.DisplayName) ($($app.AppId))"

$sp = New-MgServicePrincipal -AppId $app.AppId
Write-Output "Created service principal: $($sp.Id)"
