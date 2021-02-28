data "vault_policy_document" "secrets_buildsync" {
  rule {
    path         = "secret/buildsync/*"
    capabilities = ["read"]
    description  = "Read secrets associated with build repo sync"
  }
}

resource "vault_policy" "secrets_buildsync" {
  name   = "void-secrets-buildsync"
  policy = data.vault_policy_document.secrets_buildsync.hcl
}

