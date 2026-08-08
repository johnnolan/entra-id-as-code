terraform {
  backend "azurerm" {
    use_oidc         = true
    use_azuread_auth = true
  }

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
  }
}

# Authenticates via GitHub Actions OIDC when ARM_USE_OIDC=true and
# ARM_CLIENT_ID / ARM_TENANT_ID are set as environment variables or Actions secrets.
provider "azuread" {
  tenant_id = var.tenant_id
  client_id = var.client_id
  use_oidc  = true
}
