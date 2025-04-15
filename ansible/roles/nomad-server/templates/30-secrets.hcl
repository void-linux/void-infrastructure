server {
  encrypt = "{{lookup('file', 'secret/nomad_gossip_key')}}"
}
