resource "digitalocean_droplet" "f_sfo3_us" {
  image  = data.digitalocean_image.void_20200730RC1.id
  name   = "f-sfo3-us.m.voidlinux.org"
  region = "sfo3"
  size   = "s-1vcpu-1gb"

  vpc_uuid = digitalocean_vpc.main.id
  ssh_keys = [digitalocean_ssh_key.maldridge1.fingerprint]
}

resource "digitalocean_reserved_ip" "mx1" {
  droplet_id = digitalocean_droplet.f_sfo3_us.id
  region     = digitalocean_droplet.f_sfo3_us.region
}