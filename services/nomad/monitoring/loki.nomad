job "loki" {
  datacenters = ["VOID"]
  namespace = "monitoring"
  type = "service"

  group "aio" {
    count = 1

    network {
      port "http" { static = 3100 }
    }

    service {
      name = "loki"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.loki.tls=true",
      ]
    }

    volume "loki-data" {
      type = "host"
      read_only = false
      source = "loki-data"
    }

    task "aio" {
      driver = "docker"

      config {
        image = "grafana/loki:2.4.2"
        network_mode = "host"

        args = [
          "-config.file=/local/loki.yml",
        ]
      }

      template {
        data = file("./loki.yml")
        destination = "local/loki.yml"
        perms = "0644"
      }

      restart {
        attempts = 100
      }

      volume_mount {
        volume = "loki-data"
        destination = "/data"
        read_only = false
      }
    }
  }
}
