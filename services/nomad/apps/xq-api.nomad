job "xq-api" {
  datacenters = ["VOID-MIRROR"]
  namespace = "apps"
  type = "system"

  group "xq-api" {
    count = 1

    volume "dist_mirror" {
      type = "host"
      source = "dist_mirror"
      read_only = true
    }

    network {
      mode = "bridge"
      port "http" { to = 8197 }
    }

    service {
      name = "xq-api"
      port = "http"
      meta {
        nginx_enable = "true"
        nginx_names = "xq-api.voidlinux.org"
      }
    }

    task "xq-api" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infra-xq-api:20231023R1"
      }

      volume_mount {
        volume = "dist_mirror"
        destination = "/mirror"
      }

      resources {
        memory = 1000
      }
    }
  }
}
