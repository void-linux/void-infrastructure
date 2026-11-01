job "alps" {
  datacenters = ["VOID"]
  namespace   = "apps-restricted"
  type        = "service"

  group "app" {
    count = 1

    network {
      mode = "bridge"
      port "http" { to = 1323 }
    }

    service {
      provider = "nomad"
      name     = "alps"
      port     = "http"

      tags = [
        "nginx_enable",
        "nginx_names=alps.s.voidlinux.org alps.voidlinux.org",
      ]
    }

    task "alps" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infra-alps:9cb23b09"
        args  = ["imaps://mx1.voidlinux.org:993", "smtps://mx1.voidlinux.org:465"]
      }
    }
  }
}
