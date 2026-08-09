data "azuread_client_config" "current" {}

# Microsoft Graph Application Permission: Organization.ReadWrite.All
resource "msgraph_resource" "tenant_details" {
  url = "organization"
  body = {
    marketingNotificationEmails          = []
    securityComplianceNotificationMails  = []
    securityComplianceNotificationPhones = []
    technicalNotificationMails           = []
  }
}

import {
  to = msgraph_resource.tenant_details
  id = "organization/${data.azuread_client_config.current.tenant_id}"
}
