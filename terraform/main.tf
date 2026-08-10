terraform {
  required_version = ">= 1.15.0"
  backend "azurerm" {
    use_oidc         = true
    use_azuread_auth = true
  }

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
    msgraph = {
      source  = "microsoft/msgraph"
      version = "~> 0.4"
    }
  }
}

provider "azuread" {
  tenant_id = var.tenant_id
  client_id = var.client_id
  use_oidc  = true
}

provider "msgraph" {
  tenant_id = var.tenant_id
  client_id = var.client_id
  use_oidc  = true
}
