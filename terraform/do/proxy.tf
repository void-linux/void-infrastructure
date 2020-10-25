resource "digitalocean_droplet" "e_sfo3_us" {
  image  = data.digitalocean_image.void_20200730RC1.id
  name   = "e-sfo3-us"
  region = "sfo3"
  size   = "s-1vcpu-1gb"

  vpc_uuid = digitalocean_vpc.main.id
  ssh_keys = [digitalocean_ssh_key.maldridge1.fingerprint]
}
