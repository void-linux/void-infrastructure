data "vault_policy_document" "secrets_minio" {
  rule {
    path = "secret/minio/*"
    capabilities = ["read"]
    description = "Read minio secrets"
  }
}

resource "vault_policy" "secrets_minio" {
  name = "void-secrets-minio"
  policy = data.vault_policy_document.secrets_minio.hcl
}

