resource "nomad_acl_policy" "apps_admin" {
  name        = "apps-admin"
  description = "Manage the general apps pool"

  rules_hcl = <<EOT
namespace "apps" {
  policy = "write"
}
EOT
}

data "vault_policy_document" "apps_admin" {
  rule {
    path         = "nomad/creds/apps-admin"
    capabilities = ["read"]
    description  = "Allow obtaining apps-admin credentials"
  }
}

resource "vault_policy" "apps_admin" {
  name   = "void-nomad-apps-admin"
  policy = data.vault_policy_document.apps_admin.hcl
}

resource "vault_generic_endpoint" "nomad_role_apps_admin" {
  path = "nomad/role/apps-admin"

  data_json = jsonencode({
    policies = ["anonymous", "apps-admin"]
  })
}
