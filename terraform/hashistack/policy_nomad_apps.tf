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

resource "nomad_acl_policy" "restricted_apps_admin" {
  name        = "apps-restricted-admin"
  description = "Manage the restricted apps pool"

  rules_hcl = <<EOT
namespace "apps-restricted" {
  policy = "write"
}
EOT
}

data "vault_policy_document" "restricted_apps_admin" {
  rule {
    path         = "nomad/creds/restricted-apps-admin"
    capabilities = ["read"]
    description  = "Allow obtaining restricted-apps-admin credentials"
  }
}

resource "vault_policy" "restricted_apps_admin" {
  name   = "void-nomad-restricted-apps-admin"
  policy = data.vault_policy_document.restricted_apps_admin.hcl
}

resource "vault_generic_endpoint" "nomad_role_restricted_apps_admin" {
  path = "nomad/role/restricted-apps-admin"

  data_json = jsonencode({
    policies = ["anonymous", "restricted-apps-admin"]
  })
}
