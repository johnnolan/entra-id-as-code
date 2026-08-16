# Microsoft Graph Application Permission: EntitlementManagement.ReadWrite.All
# This example creates the package and links it to the AP-Example Users group,
# which is defined in security-groups.tf. It does not add an assignment policy.
# Users cannot request the package until a policy exists.
resource "azuread_access_package_catalog" "example" {
  display_name       = "Example Access Package Catalog"
  description        = "Example catalog for access package resources."
  externally_visible = false
  published          = false
}

resource "azuread_access_package" "example_users" {
  catalog_id   = azuread_access_package_catalog.example.id
  display_name = "Example User Access"
  description  = "Grants member access to the AP-Example Users security group."
  hidden       = true
}

resource "azuread_access_package_resource_catalog_association" "example_users" {
  catalog_id             = azuread_access_package_catalog.example.id
  resource_origin_id     = azuread_group.ap_example_users.object_id
  resource_origin_system = "AadGroup"
}

resource "azuread_access_package_resource_package_association" "example_users" {
  access_package_id               = azuread_access_package.example_users.id
  catalog_resource_association_id = azuread_access_package_resource_catalog_association.example_users.id
  access_type                     = "Member"
}