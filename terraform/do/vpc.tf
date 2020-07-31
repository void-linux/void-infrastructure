resource "digitalocean_vpc" "main" {
  name     = "void-prod"
  region   = "sfo3"
  ip_range = "192.168.100.0/24"
}
