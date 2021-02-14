terraform {
  backend "http" {
    address        = "https://terrastate.s.voidlinux.org/state/prod/hashistack"
    lock_address   = "https://terrastate.s.voidlinux.org/state/prod/hashistack/lock"
    unlock_address = "https://terrastate.s.voidlinux.org/state/prod/hashistack/lock"

    lock_method   = "PUT"
    unlock_method = "DELETE"
  }
}
