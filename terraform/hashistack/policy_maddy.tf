data "vault_policy_document" "secrets_maddy" {
  rule {
    path = "secret/lego/data/certificates/*"
    capabilities = [
      "read"
    ]
    description = "Maddy uses LEGO certificates"
  }
}

resource "vault_policy" "secrets_maddy" {
  name   = "void-secrets-maddy"
  policy = data.vault_policy_document.secrets_maddy.hcl
}
