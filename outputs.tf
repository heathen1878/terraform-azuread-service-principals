output "service_principal" {
  description = "Service Principals"
  value = {
    application_id    = azuread_service_principal.this.client_id
    object_id         = azuread_service_principal.this.object_id
    secret_name       = lower(format("%s", substr(azuread_application.this.display_name, 0, -1)))
    secret_value      = timecmp(time_offset.initial_secret.rfc3339, time_offset.overlapping_secret.rfc3339) == 1 ? azuread_application_password.initial_secret.value : azuread_application_password.overlapping_secret.value
    secret_expiration = timecmp(time_offset.initial_secret.rfc3339, time_offset.overlapping_secret.rfc3339) == 1 ? time_offset.initial_secret.rfc3339 : time_offset.overlapping_secret.rfc3339
  }
  sensitive = true
}