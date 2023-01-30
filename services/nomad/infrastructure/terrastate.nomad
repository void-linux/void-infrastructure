job "terrastate" {
  type = "service"
  datacenters = ["VOID"]
  namespace = "infrastructure"

  group "terrastate" {
    volume "terrastate_data" {
      type = "host"
      read_only = false
      source = "terrastate"
    }

    volume "netauth_config" {
      type = "host"
      read_only = true
      source = "netauth_config"
    }

    network {
      mode = "bridge"
      port "http" {
        to = 8080
      }
    }

    service {
      name = "terrastate"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.terrastate.tls=true",
      ]

      check {
        type = "http"
        address_mode = "host"
        path = "/healthz"
        timeout = "30s"
        interval = "15s"
      }
    }

    task "app" {
      driver = "docker"

      volume_mount {
        volume = "terrastate_data"
        destination = "/data"
        read_only = false
      }
      volume_mount {
        volume = "netauth_config"
        destination = "/etc/netauth"
        read_only = true
      }

      config {
        image = "ghcr.io/the-maldridge/terrastate:v1.1.1"
        init = true
      }
    }
  }
}
