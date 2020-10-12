resource "digitalocean_spaces_bucket" "generated_content" {
  name   = "void-prod-s3-generated-content"
  region = "sfo2"
}
