# MS Graph API permissions https://learn.microsoft.com/en-us/graph/permissions-reference

#region Measter
resource "azuread_application" "maester" {
  display_name     = "Maester"
  logo_image       = filebase64("assets/maester.png")
  sign_in_audience = "AzureADMyOrg"

  feature_tags {
    enterprise = true
    gallery    = false
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "df021288-bdef-4463-88db-98f22de89214" # User.Read.All
      type = "Role"
    }

    resource_access {
      id   = "b0afded3-3588-46d8-8b3d-9842eff778da" # AuditLog.Read.All
      type = "Role"
    }

    resource_access {
      id   = "dc377aa6-52d8-4e23-b271-2a7ae04cedf3" # DeviceManagementConfiguration.Read.All
      type = "Role"
    }

    resource_access {
      id   = "2f51be20-0bb4-4fed-bf7b-db946066c75e" # DeviceManagementManagedDevices.Read.All
      type = "Role"
    }

    resource_access {
      id   = "58ca0d9a-1575-47e1-a3cb-007ef2e4583b" # DeviceManagementRBAC.Read.All
      type = "Role"
    }

    resource_access {
      id   = "06a5fe6d-c49d-46a7-b082-56b1b14103c7" # DeviceManagementServiceConfig.Read.All
      type = "Role"
    }

    resource_access {
      id   = "7ab1d382-f21e-4acd-a863-ba3e13f7da61" # Directory.Read.All
      type = "Role"
    }

    resource_access {
      id   = "ae73097b-cb2a-4447-b064-5d80f6093921" # DirectoryRecommendations.Read.All
      type = "Role"
    }

    resource_access {
      id   = "c74fd47d-ed3c-45c3-9a9e-b8676de685d2" # EntitlementManagement.Read.All
      type = "Role"
    }

    resource_access {
      id   = "6e472fd1-ad78-48da-a0f0-97ab2c6b769e" # IdentityRiskEvent.Read.All
      type = "Role"
    }

    resource_access {
      id   = "e30060de-caa5-4331-99d3-6ac6c966a9a4" # NetworkAccess.Read.All
      type = "Role"
    }

    resource_access {
      id   = "bb70e231-92dc-4729-aff5-697b3f04be95" # OnPremDirectorySynchronization.Read.All
      type = "Role"
    }

    resource_access {
      id   = "56c84fa9-ea1f-4a15-90f2-90ef41ece2c9" # OrgSettings-AppsAndServices.Read.All
      type = "Role"
    }

    resource_access {
      id   = "434d7c66-07c6-4b1f-ab21-417cf2cdaaca" # OrgSettings-Forms.Read.All
      type = "Role"
    }

    resource_access {
      id   = "246dd0d5-5bd0-4def-940b-0421030a5b68" # Policy.Read.All
      type = "Role"
    }

    resource_access {
      id   = "37730810-e9ba-4e46-b07e-8ca78d182097" # Policy.Read.ConditionalAccess
      type = "Role"
    }

    resource_access {
      id   = "230c1aed-a721-4c5d-9cb4-a90514e508ef" # Reports.Read.All
      type = "Role"
    }

    resource_access {
      id   = "ee353f83-55ef-4b78-82da-555bfa2b4b95" # ReportSettings.Read.All
      type = "Role"
    }

    resource_access {
      id   = "ff278e11-4a33-4d0c-83d2-d01dc58929a5" # RoleEligibilitySchedule.Read.Directory
      type = "Role"
    }

    resource_access {
      id   = "c7fbd983-d9aa-4fa7-84b8-17382c103bc4" # RoleManagement.Read.All
      type = "Role"
    }

    resource_access {
      id   = "ef31918f-2d50-4755-8943-b8638c0a077e" # RoleManagementAlert.Read.Directory
      type = "Role"
    }

    resource_access {
      id   = "f8dcd971-5d83-4e1e-aa95-ef44611ad351" # SecurityIdentitiesHealth.Read.All
      type = "Role"
    }

    resource_access {
      id   = "5f0ffea2-f474-4cf2-9834-61cda2bcea5c" # SecurityIdentitiesSensors.Read.All
      type = "Role"
    }

    resource_access {
      id   = "dd98c7f5-2d42-42d3-a0e4-633161547251" # ThreatHunting.Read.All
      type = "Role"
    }

    resource_access {
      id   = "38d9df27-64da-44fd-b7c5-a6fbac20248f" # UserAuthenticationMethod.Read.All
      type = "Role"
    }

    resource_access {
      id   = "b4e74841-8e56-480b-be8b-910348b18b4c" # User.ReadWrite
      type = "Scope"
    }
  }

  web {
    homepage_url  = ""
    logout_url    = ""
    redirect_uris = []

    implicit_grant {
      access_token_issuance_enabled = false
      id_token_issuance_enabled     = false
    }
  }
}

resource "azuread_application_federated_identity_credential" "maester" {
  application_id = azuread_application.maester.id
  display_name   = "entra-id-as-code"
  description    = "Maester GitHub Action for Entra ID as Code"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:johnnolan@5390820/entra-id-as-code@1326869896:ref:refs/heads/main"
}
#endregion
