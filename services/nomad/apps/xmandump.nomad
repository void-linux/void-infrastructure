job "xmandump" {
  datacenters = ["VOID"]
  namespace = "apps"
  type = "batch"

  periodic {
    crons = ["@daily"]
    prohibit_overlap = true
  }

  group "app" {
    count = 1

    restart {
      attempts = 0
      mode = "fail"
    }

    volume "root-mirror" {
      type = "host"
      source = "root_mirror"
      read_only = false
    }

    task "xmandump" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infra-xmandump:20240727R1"
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
