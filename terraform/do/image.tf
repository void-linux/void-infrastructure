resource "digitalocean_spaces_bucket" "custom_images" {
  name = "void-prod-s3-images"
  region = "sfo2"
}

data "digitalocean_image" "void_20200730RC1" {
  name = "void-linux-20200730RC1"
}
