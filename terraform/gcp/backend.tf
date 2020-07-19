terraform {
  backend "http" {
    address        = "https://terraform.voidlinux.org/state/prod/gcp"
    lock_address   = "https://terraform.voidlinux.org/state/prod/gcp/lock"
    unlock_address = "https://terraform.voidlinux.org/state/prod/gcp/lock"

    lock_method   = "PUT"
    unlock_method = "DELETE"
  }
}
