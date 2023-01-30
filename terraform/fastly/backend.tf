terraform {
  backend "http" {
    address        = "https://terrastate.s.voidlinux.org/state/prod/fastly"
    lock_address   = "https://terrastate.s.voidlinux.org/state/prod/fastly"
    unlock_address = "https://terrastate.s.voidlinux.org/state/prod/fastly"
  }
}
