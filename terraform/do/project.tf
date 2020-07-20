resource "digitalocean_project" "void" {
  name        = "Void Linux"
  description = "Void's DigitalOcean Infrastructure"
  purpose     = "Host Void"
  environment = "Production"
}
