resource "azuread_application" "this" {

  display_name = var.display_name

  description                    = var.description
  device_only_auth_enabled       = var.device_only_auth_enabled
  fallback_public_client_enabled = var.fallback_public_client_enabled
  group_membership_claims        = var.group_membership_claims
  identifier_uris                = var.identifier_uris
  logo_image                     = var.logo_image
  marketing_url                  = var.marketing_url
  notes                          = var.notes
  oauth2_post_response_required  = var.oauth2_post_response_required
  owners                         = var.owners
  prevent_duplicate_names        = var.prevent_duplicate_names
  privacy_statement_url          = var.privacy_statement_url
  sign_in_audience               = var.sign_in_audience
  support_url                    = var.support_url
  template_id                    = var.template_id
  terms_of_service_url           = var.terms_of_service_url

  dynamic "api" {
    for_each = var.api != null ? [var.api] : []

    content {
      known_client_applications      = api.value.known_client_applications
      mapped_claims_enabled          = api.value.mapped_claims_enabled
      requested_access_token_version = api.value.requested_access_token_version

      dynamic "oauth2_permission_scope" {
        for_each = api.value.oauth2_permission_scopes

        content {
          admin_consent_description  = oauth2_permission_scope.value.admin_consent_description
          admin_consent_display_name = oauth2_permission_scope.value.admin_consent_display_name
          enabled                    = oauth2_permission_scope.value.enabled
          id                         = oauth2_permission_scope.value.id
          type                       = oauth2_permission_scope.value.type
          user_consent_description   = oauth2_permission_scope.value.user_consent_description
          user_consent_display_name  = oauth2_permission_scope.value.user_consent_display_name
          value                      = oauth2_permission_scope.value.value
        }
      }
    }
  }

  dynamic "app_role" {
    for_each = var.app_roles

    content {
      allowed_member_types = app_role.value.allowed_member_types
      description          = app_role.value.description
      display_name         = app_role.value.display_name
      enabled              = app_role.value.enabled
      id                   = app_role.value.id
      value                = app_role.value.value
    }
  }

  dynamic "required_resource_access" {
    for_each = var.required_resource_access

    content {
      resource_app_id = required_resource_access.value.resource_app_id

      dynamic "resource_access" {
        for_each = required_resource_access.value.resource_access

        content {
          id   = resource_access.value.id
          type = resource_access.value.type
        }
      }
    }

  }

  dynamic "single_page_application" {
    for_each = var.single_page_application != null ? [var.single_page_application] : []

    content {
      redirect_uris = single_page_application.value.redirect_uris
    }
  }

  dynamic "web" {
    for_each = var.web != null ? [var.web] : []

    content {
      homepage_url  = web.value.homepage_url
      logout_url    = web.value.logout_url
      redirect_uris = web.value.redirect_uris

      dynamic "implicit_grant" {
        for_each = web.value.implicit_grants != null ? [web.value.implicit_grants] : []

        content {
          access_token_issuance_enabled = implicit_grant.value.access_token_issuance_enabled
          id_token_issuance_enabled     = implicit_grant.value.id_token_issuance_enabled
        }
      }
    }
  }

  # Sleep to allow MS Graph changes to be propagated
  provisioner "local-exec" {
    command = "sleep 60"
  }
}

resource "azuread_service_principal" "app_registrations" {
  client_id = azuread_application.this.client_id

  description = var.description
  owners      = var.owners
}

resource "azuread_app_role_assignment" "this" {
  for_each = var.admin_approvals

  app_role_id         = azuread_service_principal.msgraph.app_role_ids[each.value.role_id]
  principal_object_id = azuread_service_principal.app_registrations.object_id
  resource_object_id  = azuread_service_principal.msgraph.object_id
}

resource "azuread_service_principal_delegated_permission_grant" "this" {
  for_each = var.delegated_admin_approvals

  service_principal_object_id          = azuread_service_principal.app_registrations.object_id
  resource_service_principal_object_id = azuread_service_principal.msgraph.object_id
  claim_values                         = each.value.claim_values
}

resource "azuread_application_password" "initial_secret" {
  application_id = azuread_application.this.object_id

  display_name = "tf-generated"
  end_date     = timeadd(timestamp(), (var.expire_secret_after * 24))
  rotate_when_changed = {
    rotation = time_rotating.initial_secret.id
  }
}

resource "azuread_application_password" "overlapping_secret" {
  application_id = azuread_application.this.object_id

  display_name = "tf-generated"
  end_date     = timeadd(timestamp(), ((var.expire_secret_after + 45) * 24))
  rotate_when_changed = {
    rotation = time_rotating.overlapping_secret.id
  }
}

resource "azuread_application_pre_authorized" "this" {
  for_each = var.preauthorisation

  application_id       = azuread_application.this.object_id
  authorized_client_id = each.value.client_id
  permission_ids       = each.value.permission_ids
}