provider "consul" {}
provider "vault" {}

module "consul_base" {
  source  = "resinstack/base/consul"
  version = "0.2.0"

  anonymous_node_read    = true
  anonymous_service_read = true
}

module "vault_base" {
  source  = "resinstack/base/vault"
  version = "0.1.1"
}

module "nomad_base" {
  source  = "resinstack/base/nomad"
  version = "0.1.0"
}
