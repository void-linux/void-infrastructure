resource "digitalocean_droplet" "g_sfo3_us" {
  image  = data.digitalocean_image.void_20200730RC1.id
  name   = "g-sfo3-us.m.voidlinux.org"
  region = "sfo3"
  size   = "s-1vcpu-2gb"

  vpc_uuid = digitalocean_vpc.main.id
  ssh_keys = [digitalocean_ssh_key.maldridge1.fingerprint]
}
