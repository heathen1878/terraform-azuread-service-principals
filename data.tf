data "azuread_application_published_app_ids" "well_known" {}

data "azuread_client_config" "this" {}

resource "azuread_service_principal" "msgraph" {
  client_id    = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
  use_existing = true
}