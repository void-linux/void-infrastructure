resource "vault_mount" "secret" {
  path = "secret"
  type = "kv"
  description = "KV Secrets Store"
}
