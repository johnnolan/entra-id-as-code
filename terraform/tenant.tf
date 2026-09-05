data "azuread_client_config" "current" {}

# Microsoft Graph Application Permission: Organization.ReadWrite.All
resource "msgraph_resource" "tenant_details" {
  url = "organization"
  body = {
    # Clears the email list used for general marketing communications from the tenant contact profile.
    marketingNotificationEmails = []
    # Clears the email addresses used for security and compliance notifications.
    securityComplianceNotificationMails = []
    # Clears security and compliance notification phone numbers to avoid unnecessary tenant communications.
    securityComplianceNotificationPhones = []
    # Clears the email list used for technical service notifications about the tenant.
    technicalNotificationMails = []
  }
}

import {
  to = msgraph_resource.tenant_details
  id = "organization/${data.azuread_client_config.current.tenant_id}"
}
