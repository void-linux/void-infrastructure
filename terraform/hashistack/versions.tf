terraform {
  required_providers {
    consul = {
      source  = "hashicorp/consul"
      version = "~> 2.10.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.13.0"
    }
    nomad = {
      source  = "hashicorp/nomad"
      version = "~> 2.1.0"
    }
  }
}
