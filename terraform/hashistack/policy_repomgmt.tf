data "vault_policy_document" "secrets_repomgmt" {
  rule {
    path         = "secret/repomgmt/*"
    capabilities = ["read"]
    description  = "Read secrets associated with build repo management"
  }
}

resource "vault_policy" "secrets_repomgmt" {
  name   = "void-secrets-repomgmt"
  policy = data.vault_policy_document.secrets_repomgmt.hcl
}
