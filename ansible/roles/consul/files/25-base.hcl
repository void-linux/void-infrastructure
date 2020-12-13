data_dir = "/var/lib/consul"
client_addr = "127.0.0.1 {{ GetPrivateInterfaces | join \"address\" \" \" }}"
advertise_addr = "{{ GetInterfaceIP \"void0\" }}"
datacenter = "void"
acl {
  enabled = true
  default_policy = "deny"
}
