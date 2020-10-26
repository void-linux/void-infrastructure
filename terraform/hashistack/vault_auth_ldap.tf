resource "vault_auth_backend" "ldap" {
  type = "ldap"
}

resource "vault_ldap_auth_backend" "ldap" {
  path        = "ldap"
  url         = "ldap://localhost"
  userdn      = "ou=entities,dc=netauth,dc=voidlinux,dc=org"
  userattr    = "uid"
  discoverdn  = false
  groupdn     = "ou=entities,dc=netauth,dc=voidlinux,dc=org"
  groupfilter = "(uid={{.Username}})"
  groupattr   = "memberOf"
}

resource "vault_ldap_auth_backend_group" "dante" {
  groupname = "dante"
  policies = [
    "resin-root",
    "resin-consul-root",
    "resin-nomad-root",
    "void-secrets-admin",
  ]
  backend = vault_ldap_auth_backend.ldap.path
}
