provider "consul" {}

module "base" {
  source  = "resinstack/base/consul"
  version = "0.2.0"
}

