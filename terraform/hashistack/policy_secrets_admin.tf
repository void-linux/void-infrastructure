data "vault_policy_document" "secrets_admin" {
  rule {
    path         = "secret/*"
    capabilities = [
      "create",
      "read",
      "update",
      "delete",
      "list",
    ]
    description  = "allow all on secrets"
  }
}

resource "vault_policy" "secrets_admin" {
  name   = "void-secrets-admin"
  policy = data.vault_policy_document.secrets_admin.hcl
}
