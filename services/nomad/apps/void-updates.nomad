job "void-updates" {
  datacenters = ["VOID"]
  namespace = "apps"
  type = "batch"

  periodic {
    crons = ["0 4 * * *"]
    prohibit_overlap = true
  }

  group "app" {
    count = 1

    network { mode = "bridge" }

    volume "root-mirror" {
      type = "host"
      source = "root_mirror"
      read_only = false
    }

    task "void-updates" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/void-updates:20250624R2"
      }

      resources {
        memory = 1000
      }

      env {
        OUTDIR = "/mirror/void-updates"
      }

      volume_mount {
        volume = "root-mirror"
        destination = "/mirror"
      }
    }
  }
}
