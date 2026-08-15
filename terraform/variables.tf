variable "tenant_id" {
  description = "The Entra ID tenant ID."
  type        = string
}

variable "client_id" {
  description = "The client ID of the app registration used for authentication."
  type        = string
}

variable "b2b_invitation_domain_mode" {
  description = "B2B invitation domain restriction mode: allow_all, allow_list, or block_list."
  type        = string
  default     = "allow_all"

  validation {
    condition     = contains(["allow_all", "allow_list", "block_list"], var.b2b_invitation_domain_mode)
    error_message = "b2b_invitation_domain_mode must be allow_all, allow_list, or block_list."
  }
}

variable "b2b_invitation_allowed_domains" {
  description = "Domains that can receive B2B invitations when b2b_invitation_domain_mode is allow_list. Provide at least one domain in allow_list mode."
  type        = set(string)
  default     = []
}

variable "b2b_invitation_blocked_domains" {
  description = "Domains that cannot receive B2B invitations when b2b_invitation_domain_mode is block_list."
  type        = set(string)
  default     = []
}
