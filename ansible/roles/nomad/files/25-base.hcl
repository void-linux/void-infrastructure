data_dir = "/var/lib/nomad"
datacenter = "void"

advertise {
  http = "{{ GetInterfaceIP \"void0\" }}"
  rpc  = "{{ GetInterfaceIP \"void0\" }}"
  serf = "{{ GetInterfaceIP \"void0\" }}"
}

acl {
  enabled = true
}
