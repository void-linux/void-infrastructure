resource "nomad_acl_policy" "popcorn_admin" {
  name = "popcorn-admin"
  description = "Manage popcorn keys in nomad variables"

  job_acl {
    namespace = "apps"
    job_id = "popcorn-report"
  }

  rules_hcl = <<EOT
namespace "apps" {
  variables {
    path "nomad/jobs/popcorn" {
      capabilities = ["read"]
    }
  }
}
EOT
}
