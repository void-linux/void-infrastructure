data "vault_policy_document" "secrets_traefik" {
  rule {
    path = "secret/traefik/*"
    capabilities = [
      "read",
    ]
    description = "Read Traefik Secrets"
  }
}

resource "vault_policy" "secrets_traefik" {
  name   = "void-secrets-traefik"
  policy = data.vault_policy_document.secrets_traefik.hcl
}
