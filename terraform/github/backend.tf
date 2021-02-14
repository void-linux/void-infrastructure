terraform {
  backend "http" {
    address        = "https://terrastate.s.voidlinux.org/state/prod/github"
    lock_address   = "https://terrastate.s.voidlinux.org/state/prod/github/lock"
    unlock_address = "https://terrastate.s.voidlinux.org/state/prod/github/lock"

    lock_method   = "PUT"
    unlock_method = "DELETE"
  }
}
