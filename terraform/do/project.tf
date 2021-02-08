resource "digitalocean_project" "void_prod" {
  name        = "Production"
  description = "Production Infrastructure"
  purpose     = "Host Void"
  environment = "Production"
}

resource "digitalocean_project_resources" "void" {
  project = digitalocean_project.void_prod.id
  resources = [
    digitalocean_spaces_bucket.custom_images.urn,
    digitalocean_spaces_bucket.generated_content.urn,
    digitalocean_droplet.a_sfo3_us.urn,
    digitalocean_droplet.b_sfo3_us.urn,
    digitalocean_droplet.c_sfo3_us.urn,
    digitalocean_droplet.d_sfo3_us.urn,
    digitalocean_droplet.e_sfo3_us.urn,
    digitalocean_domain.voidlinux_org.urn,
  ]
}
