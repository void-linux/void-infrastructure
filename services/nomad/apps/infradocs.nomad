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
      meta {
        nginx_enable = "true"
        nginx_names = "infradocs.voidlinux.org"
      }
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
        image = "ghcr.io/void-linux/infradocs:ae4c7c00c3b3a09f36872740204895723f73af81"
      }
    }
  }
}
