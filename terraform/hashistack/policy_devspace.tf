data "vault_policy_document" "secrets_devspace" {
  rule {
    path = "secret/devspace/*"
    capabilities = [
      "read",
    ]
    description = "Read secrets associated with the devspace systems"
  }
}

resource "vault_policy" "secrets_devspace" {
  name   = "void-secrets-devspace"
  policy = data.vault_policy_document.secrets_devspace.hcl
}
