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

  token_explicit_max_ttl = 3600 * 12
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

resource "vault_ldap_auth_backend_group" "nomad_apps_admin" {
  groupname = "nomad-apps-admin"
  policies = [
    vault_policy.apps_admin.name,
  ]

  backend = vault_ldap_auth_backend.ldap.path
}
