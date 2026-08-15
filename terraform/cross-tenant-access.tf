resource "msgraph_resource" "cross_tenant_access_policy_default" {
  url = "policies/crossTenantAccessPolicy"
  body = {
    b2bCollaborationInbound = {
      applications = {
        accessType = "allowed"
        targets = [
          { target = "AllApplications", targetType = "application" }
        ]
      }
      usersAndGroups = {
        accessType = "allowed"
        targets = [
          { target = "AllUsers", targetType = "user" }
        ]
      }
    }
    b2bCollaborationOutbound = {
      applications = {
        accessType = "allowed"
        targets = [
          { target = "AllApplications", targetType = "application" }
        ]
      }
      usersAndGroups = {
        accessType = "allowed"
        targets = [
          { target = "AllUsers", targetType = "user" }
        ]
      }
    }
    b2bDirectConnectInbound = {
      applications = {
        accessType = "blocked"
        targets = [
          { target = "AllApplications", targetType = "application" }
        ]
      }
      usersAndGroups = {
        accessType = "blocked"
        targets = [
          { target = "AllUsers", targetType = "user" }
        ]
      }
    }
    b2bDirectConnectOutbound = {
      applications = {
        accessType = "blocked"
        targets = [
          { target = "AllApplications", targetType = "application" }
        ]
      }
      usersAndGroups = {
        accessType = "blocked"
        targets = [
          { target = "AllUsers", targetType = "user" }
        ]
      }
    }
    inboundTrust = {
      isCompliantDeviceAccepted           = false
      isHybridAzureAdJoinedDeviceAccepted = false
      isMfaAccepted                       = false
    }
  }
}

import {
  to = msgraph_resource.cross_tenant_access_policy_default
  id = "policies/crossTenantAccessPolicy/default"
}
