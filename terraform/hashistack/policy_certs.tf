resource "nomad_acl_policy" "certs_admin" {
  name = "certs-admin"
  description = "Manage certificates in nomad variables"

  job_acl {
    namespace = "infrastructure"
    job_id = "cert-renew"
  }

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

namespace "apps-restricted" {
  variables {
    path "nomad/jobs/maddy" {
      capabilities = ["read", "write"]
    }
  }
}
EOT
}
