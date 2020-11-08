resource "nomad_acl_policy" "guest" {
  name        = "anonymous"
  description = "View and Examine in a read-only context"

  rules_hcl = <<EOT
namespace "default" {
  policy = "read"
}
node {
  policy = "read"
}
EOT
}
