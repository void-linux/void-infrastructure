terraform {
  backend "http" {
    address        = "https://terrastate.s.voidlinux.org/state/prod/github"
    lock_address   = "https://terrastate.s.voidlinux.org/state/prod/github"
    unlock_address = "https://terrastate.s.voidlinux.org/state/prod/github"
  }
}
