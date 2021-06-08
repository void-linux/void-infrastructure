job "infradocs" {
  datacenters = ["VOID"]
  namespace = "apps"
  type = "service"

  group "app" {
    count = 1

    network {
      mode = "bridge"
      port "http" {
        to = 8080
      }
    }

    service {
      name = "infradocs"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.infradocs.tls=true",
        "traefik.http.routers.infradocs.rule=Host(`infradocs.voidlinux.org`)",
      ]

      check {
        type = "http"
        address_mode = "host"
        path = "/"
        timeout = "30s"
        interval = "15s"
      }
    }

    task "httpd" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infradocs:3336d97b4f537248bf0bbf6a645cf8d00beda972"
        ports = ["http"]
      }
    }
  }
}
