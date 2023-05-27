job "alps" {
  datacenters = ["VOID"]
  namespace = "apps-restricted"
  type = "service"

  group "app" {
    count = 1

    network {
      mode = "bridge"
      port "http" { to = 1323 }
    }

    service {
      name = "alps"
      port = "http"
      meta {
        nginx_enable = "true"
        nginx_names = "alps.s.voidlinux.org alps.voidlinux.org"
      }
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.alps.tls=true",
      ]
    }

    task "alps" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infra-alps:9cb23b09"
        args = ["imaps://mx1.voidlinux.org:993", "smtps://mx1.voidlinux.org:465"]
      }
    }
  }
}
