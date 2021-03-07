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
        image = "ghcr.io/void-linux/infradocs:1a44cd99d8a35dfe28fc0c7b0a7f27dffb65efa8"
        ports = ["http"]
      }
    }
  }
}
