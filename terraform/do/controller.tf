resource "digitalocean_droplet" "b_sfo3_us" {
  image  = data.digitalocean_image.void_20200730RC1.id
  name   = "b-sfo3-us"
  region = "sfo3"
  size   = "s-1vcpu-2gb"

  vpc_uuid = digitalocean_vpc.main.id
  ssh_keys = [digitalocean_ssh_key.maldridge1.fingerprint]
}

resource "digitalocean_droplet" "c_sfo3_us" {
  image  = data.digitalocean_image.void_20200730RC1.id
  name   = "c-sfo3-us"
  region = "sfo3"
  size   = "s-1vcpu-2gb"

  vpc_uuid = digitalocean_vpc.main.id
  ssh_keys = [digitalocean_ssh_key.maldridge1.fingerprint]
}

resource "digitalocean_droplet" "d_sfo3_us" {
  image  = data.digitalocean_image.void_20200730RC1.id
  name   = "d-sfo3-us"
  region = "sfo3"
  size   = "s-1vcpu-2gb"

  vpc_uuid = digitalocean_vpc.main.id
  ssh_keys = [digitalocean_ssh_key.maldridge1.fingerprint]
}
