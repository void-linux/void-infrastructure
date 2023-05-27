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
      meta {
        nginx_enable = "true"
        nginx_names = "wiki.voidlinux.org"
      }
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.oldwiki.tls=true",
        "traefik.http.routers.oldwiki.rule=Host(`wiki.voidlinux.org`)",
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
