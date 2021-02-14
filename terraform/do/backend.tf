terraform {
  backend "http" {
    address        = "https://terrastate.s.voidlinux.org/state/prod/digitalocean"
    lock_address   = "https://terrastate.s.voidlinux.org/state/prod/digitalocean/lock"
    unlock_address = "https://terrastate.s.voidlinux.org/state/prod/digitalocean/lock"

    lock_method   = "PUT"
    unlock_method = "DELETE"
  }
}
