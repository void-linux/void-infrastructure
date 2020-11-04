consul {
  token = "{{lookup('file', 'secret/nomad_' + nomad_role +'_consul_token')}}"
}
