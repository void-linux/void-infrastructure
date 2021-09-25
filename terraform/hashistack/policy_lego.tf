data "vault_policy_document" "secrets_lego" {
  rule {
    path = "secret/lego/*"
    capabilities = [
      "create",
      "delete",
      "list",
      "read",
      "update",
    ]
    description = "LEGO manages the entire prefix as an fs mirror"
  }
}

resource "vault_policy" "secrets_lego" {
  name   = "void-secrets-lego"
  policy = data.vault_policy_document.secrets_lego.hcl
}

