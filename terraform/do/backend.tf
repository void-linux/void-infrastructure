terraform {
  backend "http" {
    address        = "https://terraform.voidlinux.org/state/prod/digitalocean"
    lock_address   = "https://terraform.voidlinux.org/state/prod/digitalocean/lock"
    unlock_address = "https://terraform.voidlinux.org/state/prod/digitalocean/lock"

    lock_method   = "PUT"
    unlock_method = "DELETE"
  }
}
