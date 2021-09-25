data "vault_policy_document" "secrets_traefik" {
  rule {
    path = "secret/traefik/*"
    capabilities = [
      "read",
    ]
    description = "Read Traefik Secrets"
  }

  rule {
    path = "secret/lego/data/certificates/*"
    capabilities = [
      "read"
    ]
    description = "Traefik uses LEGO certificates"
  }
}

resource "vault_policy" "secrets_traefik" {
  name   = "void-secrets-traefik"
  policy = data.vault_policy_document.secrets_traefik.hcl
}
