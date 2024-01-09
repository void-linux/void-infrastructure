resource "nomad_acl_policy" "certs_admin" {
  name = "certs-admin"
  description = "Manage certificates in nomad variables"

  rules_hcl = <<EOT
namespace "mirror" {
  variables {
    path "nomad/jobs/nginx" {
      capabilities = ["read", "write"]
    }
  }
}

namespace "infrastructure" {
  variables {
    path "nomad/jobs/nginx-control" {
      capabilities = ["read", "write"]
    }
  }
}
EOT
}
