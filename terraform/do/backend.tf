terraform {
  backend "http" {
    address        = "https://terrastate.s.voidlinux.org/state/prod/digitalocean"
    lock_address   = "https://terrastate.s.voidlinux.org/state/prod/digitalocean"
    unlock_address = "https://terrastate.s.voidlinux.org/state/prod/digitalocean"
  }
}
