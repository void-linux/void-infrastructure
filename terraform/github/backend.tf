terraform {
  backend "http" {
    address        = "https://terraform.voidlinux.org/state/prod/github"
    lock_address   = "https://terraform.voidlinux.org/state/prod/github/lock"
    unlock_address = "https://terraform.voidlinux.org/state/prod/github/lock"

    lock_method   = "PUT"
    unlock_method = "DELETE"
  }
}
