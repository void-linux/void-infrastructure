job "xmandump" {
  datacenters = ["VOID"]
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
      read_only = false
    }

    task "xmandump" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infra-xmandump:20220913RC01"
      }

      volume_mount {
        volume = "root-mirror"
        destination = "/mirror"
      }

      resources {
        memory = 1000
      }
    }
  }
}
