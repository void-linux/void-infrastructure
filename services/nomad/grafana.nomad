job "grafana" {
  datacenters = ["VOID"]
  type = "service"

  group "app" {
    count = 1

    volume "grafana" {
      type = "host"
      read_only = false
      source = "grafana"
    }

    network {
      port "http" { to = 3000 }
    }

    service {
      name = "grafana"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.grafana.tls=true",
      ]

      check {
        type = "http"
        address_mode = "host"
        path = "/healthz"
        timeout = "30s"
        interval = "15s"
      }
    }

    task "grafana" {
      driver = "docker"

      volume_mount {
        volume = "grafana"
        destination = "/var/lib/grafana"
        read_only = false
      }

      config {
        image = "grafana/grafana:7.2.2"
        ports = ["http"]
      }

      env {
        GF_AUTH_ANONYMOUS_ENABLED="true"
        GF_AUTH_ANONYMOUS_ORG_NAME="Main Org."
        GF_AUTH_ANONYMOUS_ORG_ROLE="Viewer"
      }
    }
  }
}
