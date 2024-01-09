terraform {
  backend "http" {
    address        = "https://terrastate.s.voidlinux.org/state/tls/letsencrypt"
    lock_address   = "https://terrastate.s.voidlinux.org/state/tls/letsencrypt"
    unlock_address = "https://terrastate.s.voidlinux.org/state/tls/letsencrypt"
  }
}
