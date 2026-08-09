data "azuread_client_config" "current" {}

resource "msgraph_resource" "tenant_details" {
  url = "organization/${data.azuread_client_config.current.tenant_id}"
  body = jsonencode({
    marketingNotificationEmails          = []
    securityComplianceNotificationMails  = []
    securityComplianceNotificationPhones = []
    technicalNotificationMails           = []
  })
}

import {
  to = msgraph_resource.tenant_details
  id = "organization/${data.azuread_client_config.current.tenant_id}"
}
