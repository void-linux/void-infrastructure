job "oldwiki" {
  datacenters = ["VOID"]
  namespace = "apps"
  type = "service"

  group "app" {
    count = 1

    network {
      mode = "bridge"
      port "http" {
        to = 80
      }
    }

    service {
      name = "oldwiki"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.oldwiki.tls=true",
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
        image = "voidlinux/oldwiki:3"
        ports = ["http"]
      }
    }
  }
}
