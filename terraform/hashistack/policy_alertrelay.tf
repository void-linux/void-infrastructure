data "vault_policy_document" "secrets_alertrelay" {
  rule {
    path = "secret/alertrelay/*"
    capabilities = [
      "read",
    ]
    description = "Read IRC Bot Secrets"
  }
}

resource "vault_policy" "secrets_alertrelay" {
  name   = "void-secrets-alertrelay"
  policy = data.vault_policy_document.secrets_alertrelay.hcl
}
