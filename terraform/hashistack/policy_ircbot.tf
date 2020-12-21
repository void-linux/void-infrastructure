data "vault_policy_document" "secrets_ircbot" {
  rule {
    path = "secret/ircbot/*"
    capabilities = [
      "read",
    ]
    description = "Read IRC Bot Secrets"
  }
}

resource "vault_policy" "secrets_ircbot" {
  name   = "void-secrets-ircbot"
  policy = data.vault_policy_document.secrets_ircbot.hcl
}
