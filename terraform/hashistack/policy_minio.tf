data "vault_policy_document" "secrets_minio" {
  rule {
    path         = "secret/minio/*"
    capabilities = ["read"]
    description  = "Read minio secrets"
  }
}

resource "vault_policy" "secrets_minio" {
  name   = "void-secrets-minio"
  policy = data.vault_policy_document.secrets_minio.hcl
}

data "vault_policy_document" "secrets_minio_nbuild" {
  rule {
    path         = "secret/minio/nbuild"
    capabilities = ["read"]
    description  = "Read nbuild credentials"
  }
}

resource "vault_policy" "secrets_minio_nbuild" {
  name   = "void-secrets-minio-nbuild"
  policy = data.vault_policy_document.secrets_minio_nbuild.hcl
}
