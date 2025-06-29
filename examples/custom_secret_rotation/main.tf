module "service_principal" {

  source = "../.."

  display_name                     = "SP-TF"
  expire_secret_after              = 90
  rotate_secret_days_before_expiry = 30
}