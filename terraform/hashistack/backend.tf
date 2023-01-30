terraform {
  backend "http" {
    address        = "https://terrastate.s.voidlinux.org/state/prod/hashistack"
    lock_address   = "https://terrastate.s.voidlinux.org/state/prod/hashistack"
    unlock_address = "https://terrastate.s.voidlinux.org/state/prod/hashistack"
  }
}
