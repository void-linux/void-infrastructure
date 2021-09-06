terraform {
  required_providers {
    consul = {
      source  = "hashicorp/consul"
      version = "~> 2.10.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 2.23.0"
    }
    nomad = {
      source  = "hashicorp/nomad"
      version = "~> 1.4.15"
    }
  }
}
