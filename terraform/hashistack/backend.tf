terraform {
  backend "http" {
    address        = "https://terraform.voidlinux.org/state/prod/hashistack"
    lock_address   = "https://terraform.voidlinux.org/state/prod/hashistack/lock"
    unlock_address = "https://terraform.voidlinux.org/state/prod/hashistack/lock"

    lock_method   = "PUT"
    unlock_method = "DELETE"
  }
}
