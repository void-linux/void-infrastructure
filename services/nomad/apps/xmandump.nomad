job "xmandump" {
  datacenters = ["VOID-MIRROR"]
  namespace = "apps"
  type = "batch"

  periodic {
    cron = "@daily"
    prohibit_overlap = true
  }

  group "app" {
    count = 1

    volume "root-mirror" {
      type = "host"
      source = "root_mirror"
      read_only = true
    }

    volume "manpages" {
      type = "host"
      source = "manpages"
      read_only = false
    }

    task "xmandump" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infra-xmandump:20220910RC01"
      }

      volume_mount {
        volume = "root-mirror"
        destination = "/mirror"
      }

      volume_mount {
        volume = "manpages"
        destination = "/var/lib/man-cgi"
      }

      resources {
        memory = 1000
      }
    }
  }
}
