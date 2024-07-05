resource "nomad_acl_policy" "buildbot_worker_admin" {
  name = "buildbot-worker-admin"
  description = "Manage buildbot worker secrets in nomad variables"

  job_acl {
    namespace = "build"
    job_id = "buildbot"
  }

  rules_hcl = <<EOT
namespace "build" {
  variables {
    path "nomad/jobs/buildbot-worker" {
      capabilities = ["read"]
    }
  }
}
EOT
}
