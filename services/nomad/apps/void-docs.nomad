job "void-docs" {
  datacenters = ["VOID"]
  namespace = "apps"
  type = "batch"

  periodic {
    crons = ["@hourly"]
    prohibit_overlap = true
  }

  group "app" {
    count = 1

    volume "root-mirror" {
      type = "host"
      source = "root_mirror"
      read_only = false
    }

    network { mode = "bridge" }

    task "void-docs" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infra-mdbook:20260113R1"
      }

      env {
        OUTDIR = "/mirror/docs"
        REPO_URL = "https://github.com/void-linux/void-docs.git"
      }

      volume_mount {
        volume = "root-mirror"
        destination = "/mirror"
      }
    }
  }
}
