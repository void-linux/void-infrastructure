server {
  encrypt = "{{lookup('file', 'secret/nomad_gossip_key')}}"
}

consul {
  token = "{{lookup('file', 'secret/nomad_consul_token')}}"
}
