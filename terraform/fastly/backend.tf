terraform {
  backend "http" {
    address        = "https://terrastate.s.voidlinux.org/state/prod/fastly"
    lock_address   = "https://terrastate.s.voidlinux.org/state/prod/fastly/lock"
    unlock_address = "https://terrastate.s.voidlinux.org/state/prod/fastly/lock"

    lock_method   = "PUT"
    unlock_method = "DELETE"
  }
}
