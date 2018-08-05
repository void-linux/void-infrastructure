terraform {
  backend "http" {
    address = "https://terraform.voidlinux.org/state"
    lock_address = "https://terraform.voidlinux.org/locks"
    unlock_address = "https://terraform.voidlinux.org/locks"
  }
}
