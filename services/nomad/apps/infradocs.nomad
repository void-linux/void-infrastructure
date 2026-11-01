job "infradocs" {
  datacenters = ["VOID"]
  namespace   = "apps"
  type        = "service"

  group "app" {
    count = 1

    network {
      mode = "bridge"
      port "http" {
        to = 8080
      }
    }

    service {
      provider = "nomad"
      name     = "infradocs"
      port     = "http"

      tags = [
        "nginx_enable",
        "nginx_names=infradocs.voidlinux.org",
      ]

      check {
        type         = "http"
        address_mode = "host"
        path         = "/"
        timeout      = "30s"
        interval     = "15s"
      }
    }

    task "httpd" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infradocs:fc4a606"
      }
    }
  }
}
