terraform {
  required_providers {
    acme = {
      source  = "vancluever/acme"
      version = "2.41.0"
    }
    nomad = {
      source = "hashicorp/nomad"
      version = "2.5.2"
    }
  }
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

provider "nomad" {}
