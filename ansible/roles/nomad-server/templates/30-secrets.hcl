server {
  encrypt = "{{lookup('file', 'secret/nomad_gossip_key')}}"
}

vault {
  enabled = true
  create_from_role = "nomad-cluster"
  address = "http://active.vault.service.consul:8200"
  token = "{{lookup('file', 'secret/nomad_vault_token')}}"
}
