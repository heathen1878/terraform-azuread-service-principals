variable "admin_approvals" {
  description = "A map of permissions to admin approve"
  default     = {}
  type = map(object(
    {
      role_id = string
    }
  ))
}

variable "delegated_admin_approvals" {
  description = "A map of delegated permissions to admin approve"
  default     = {}
  type = map(object(
    {
      claim_values = list(string)
    }
  ))
}

variable "apis" {
  description = "A map of API configuration"
  default     = {}
  type = map(object(
    {
      known_client_applications = optional(list(string), [])
      mapped_claims_enabled     = optional(bool, false)
      oauth2_permission_scopes = optional(map(object(
        {
          admin_consent_description  = string
          admin_consent_display_name = string
          enabled                    = optional(bool, true)
          id                         = string
          type                       = optional(string, "User")
          user_consent_description   = optional(string)
          user_consent_display_name  = optional(string)
          value                      = optional(string, "default")
        }
      )))
      requested_access_token_version = optional(number, 1)
    }
  ))
}

variable "app_roles" {
  description = "A map of application roles to create"
  default     = {}
  type = map(object(
    {
      allowed_member_types = optional(list(string), [])
      description          = optional(string, null)
      display_name         = optional(string, null)
      enabled              = optional(bool, true)
      id                   = optional(string, null)
      value                = optional(string, null)
    }
  ))
}

variable "description" {
  description = "Service Principals description"
  default     = ""
  type        = string
}

variable "device_only_auth_enabled" {
  description = "Should device only auth be enabled?"
  default     = false
  type        = bool
}

variable "display_name" {
  description = "Service Principals display name"
  type        = string
}

variable "fallback_public_client_enabled" {
  description = "Is the application a public client?"
  default     = false
  type        = bool
}

variable "group_membership_claims" {
  description = "Groups claims token"
  default = [
    "None"
  ]
  type = list(string)
  validation {
    condition = anytrue([
      for claim in var.group_membership_claims : contains(
        [
          "None",
          "SecurityGroup",
          "DirectoryRole",
          "ApplicationGroup",
          "All"
      ], claim)
    ])
    error_message = "The group membership claims must be one of: None, SecurityGroup, DirectoryRole, ApplicationGroup or All"
  }
}

variable "identifier_uris" {
  description = "A set of user defined URI(s) that uniquely identify a Web application within its Azure AD tenant, or within a verified custom domain if the application is multi-tenant."
  default     = []
  type        = list(string)
}

variable "logo_image" {
  description = "A base64 encoded string of the logo...gif. jpeg or png."
  default     = ""
  type        = string
}

variable "logout_url" {
  description = "The applications logout url"
  default     = ""
  type        = string
}

variable "marketing_url" {
  description = "The applications marketing url"
  default     = ""
  type        = string
}

variable "notes" {
  description = "Service Principal notes"
  default     = ""
  type        = string
}

variable "oauth2_post_response_required" {
  description = "Allow POST requests as part of the OAuth 2.0 token request?"
  default     = false
  type        = bool
}

variable "owners" {
  description = "A list of service principal owners"
  default     = []
  type        = list(string)
}

variable "preauthorisation" {
  description = "A map of application and permission ids"
  default     = {}
  type = map(object(
    {
      client_id      = string
      permission_ids = list(string)
    }
  ))
}

variable "prevent_duplicate_names" {
  description = "Prevent service principals with the same name?"
  default     = true
  type        = bool
}

variable "privacy_statement_url" {
  description = "The applications privacy statement url"
  default     = ""
  type        = string
}

variable "redirect_uris" {
  description = "A set of urls where user tokens are sent for signin"
  default     = []
  type        = list(string)
}

variable "required_resource_access" {
  description = "A map of resource access"
  default     = {}
  type = map(object({
    resource_app_id = string
    resource_access = optional(map(object({
      id   = optional(string, null)
      type = optional(string, "Scope")
    })), {})
  }))
}

variable "sign_in_audience" {
  description = "The sign in audience"
  default     = "AzureADMyOrg"
  type        = string
  validation {
    condition = contains(
      [
        "AzureADMyOrg",
        "AzureADMultipleOrgs",
        "AzureADandPersonalMicrosoftAccount",
        "PersonalMicrosoftAccount"
    ], var.sign_in_audience)
    error_message = "The sign in audience must be one of: AzureADMyOrg, AzureADMultipleOrgs, AzureADandPersonalMicrosoftAccount or PersonalMicrosoftAccount"
  }
}

variable "single_page_application" {
  description = "A map of single page application configuration"
  default     = {}
  type = map(object({
    redirect_uris = optional(list(string), [])
  }))
}

variable "support_url" {
  description = "The applications support url"
  default     = ""
  type        = string
}

variable "template_id" {
  description = "A unique id for a templated application in the Azure App Gallery"
  default     = ""
  type        = string
}

variable "terms_of_service_url" {
  description = "The applications terms of service url"
  default     = ""
  type        = string
}

variable "expire_secret_after" {
  description = "The value in days the secret should expire after"
  default     = 180
  type        = number
}

variable "rotate_secret_days_before_expiry" {
  description = "The value in days the secret should be rotated to ensure it does not expire and cause an outage"
  default     = 14
  type        = number
}

variable "webs" {
  description = "A map of web configuration"
  default     = {}
  type = map(object(
    {
      homepage_url  = optional(string)
      logout_url    = optional(string)
      redirect_uris = optional(list(string), [])
      implicit_grants = optional(map(object(
        {
          access_token_issuance_enabled = optional(bool, null)
          id_token_issuance_enabled     = optional(bool, null)
        }
      )))
    }
  ))
}