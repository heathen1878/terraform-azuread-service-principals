module "service_principal" {

  source = "../.."

  delegated_admin_approvals = {
    application_read_write_all = {
      claim_values = [
        "Application.ReadWrite.All"
      ]
    }
  }
  display_name = "SP-MOD-DELE-EXAMPLE-TF"
}