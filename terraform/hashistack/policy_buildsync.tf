resource "nomad_acl_policy" "buildsync_admin" {
  name = "buildsync-admin"
  description = "Manage buildsync secrets in nomad variables"

  job_acl {
    namespace = "build"
    job_id = "build-rsyncd"
  }

  rules_hcl = <<EOT
namespace "build" {
  variables {
    path "nomad/jobs/buildsync" {
      capabilities = ["read"]
    }
  }
}
EOT
}

resource "nomad_acl_policy" "buildsync_buildbot_admin" {
  name = "buildsync-buildbot-admin"
  description = "Manage buildsync secrets in nomad variables for buildbot"

  job_acl {
    namespace = "build"
    job_id = "buildbot-worker"
  }

  rules_hcl = <<EOT
namespace "build" {
  variables {
    path "nomad/jobs/buildsync" {
      capabilities = ["read"]
    }
  }
}
EOT
}
