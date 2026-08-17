# Conditional Access named locations

This file creates the country-based named location used by location-aware Conditional Access policies.

## `named_location_restricted_signin`

Creates `Restricted Sign-in Locations` with `azuread_named_location`.

- `countries_and_regions = ["GB"]` defines the United Kingdom by its two-letter country code.
- AzureAD uses client IP address geolocation by default because no GPS lookup method is specified.
- `include_unknown_countries_and_regions = false` keeps addresses that Microsoft cannot geolocate outside this named location.
- Conditional Access policies reference the resource's `object_id`, which gives Terraform an implicit dependency on the named location.

> **Security requirement:** Treat country geolocation as a risk signal, not proof of trust. Microsoft warns that IP mappings change and that VPN or proxy egress addresses affect location evaluation.

Location-based blocking is restrictive. Test policy changes in report-only mode before enforcement and preserve emergency-access exclusions.

## Required permissions

The Terraform service principal needs these Microsoft Graph application permissions:

- `Policy.Read.All`
- `Policy.ReadWrite.ConditionalAccess`

## Maester coverage

No current Maester test directly checks the definition of this named location. Conditional Access tests evaluate policies that consume location signals, not the standalone location object.

## Resources

### Microsoft articles

- [Conditional Access: use network signals](https://learn.microsoft.com/en-us/entra/identity/conditional-access/location-condition)

### AzureAD provider documentation

- [azuread_named_location](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/named_location)
