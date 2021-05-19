job "etherpad" {
  type = "service"
  datacenters = ["VOID"]
  namespace = "apps"

  group "etherpad" {
    network {
      mode = "bridge"
      port "http" { to = 9001 }
    }

    service {
      name = "pad"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.pad.tls=true",
      ]
    }

    volume "etherpad" {
      type = "host"
      read_only = false
      source = "etherpad-data"
    }

    task "app" {
      driver = "docker"

      config {
        image = "etherpad/etherpad:1.8.13"
      }

      env {
        DB_FILENAME="/data/db.json"
        SUPPRESS_ERRORS_IN_PAD_TEXT="false"
        TRUST_PROXY="true"
      }

      volume_mount {
        volume = "etherpad"
        destination = "/data"
        read_only = false
      }
    }
  }
}
