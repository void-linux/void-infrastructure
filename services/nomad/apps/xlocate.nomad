job "xlocate" {
  datacenters = ["VOID"]
  namespace = "apps"
  type = "batch"

  periodic {
    crons = ["0 6 * * *"]
    prohibit_overlap = true
  }

  group "app" {
    count = 1

    volume "root-mirror" {
      type = "host"
      source = "root_mirror"
      read_only = false
    }

    task "xlocate" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infra-xlocate:20231023R1"
        volumes = [ "local/xbps.conf:/etc/xbps.d/00-repository-main.conf" ]
      }

      env {
        XLOCATE_GIT = "/mirror/xlocate/xlocate.git"
      }

      volume_mount {
        volume = "root-mirror"
        destination = "/mirror"
      }

      template {
        data = <<EOF
repository=/mirror/current
repository=/mirror/current/nonfree
repository=/mirror/current/multilib
repository=/mirror/current/multilib/nonfree
EOF
        destination = "local/xbps.conf"
      }
    }
  }
}
