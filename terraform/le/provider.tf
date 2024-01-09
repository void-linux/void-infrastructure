terraform {
  required_providers {
    acme = {
      source  = "vancluever/acme"
      version = "2.19.0"
    }
    nomad = {
      source = "hashicorp/nomad"
      version = "2.1.0"
    }
  }
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

provider "nomad" {}
