module "service_principal" {

  source = "../.."

  admin_approvals = {
    application_read_write_all = {
      role_id = "Application.ReadWrite.All"
    }
  }
  display_name = "SP-MOD-ADMIN-EXAMPLE-TF"
  required_resource_access = {
    microsoft_graph = {
      resource_app_id = "00000003-0000-0000-c000-000000000000"
      resource_access = {
        application_read_write_all = {
          id   = "1bfefb4e-e0b5-418b-a88f-73c46d2cc8e9"
          type = "Role"
        }
      }
    }
  }
}