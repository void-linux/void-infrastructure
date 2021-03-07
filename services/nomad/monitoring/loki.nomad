job "loki" {
  datacenters = ["VOID"]
  namespace = "monitoring"
  type = "service"

  group "aio" {
    count = 1

    network {
      port "http" { static = 3100 }
      port "grpc" { static = 9095 }
    }

    service {
      name = "loki"
      port = "http"
    }

    volume "loki-data" {
      type = "host"
      read_only = false
      source = "loki-data"
    }

    task "aio" {
      driver = "docker"

      config {
        image = "grafana/loki:2.1.0"
        network_mode = "host"

        args = [
          "-config.file=/local/loki.yml",
          "-server.http-listen-address=${NOMAD_IP_http}",
          "-server.http-listen-port=${NOMAD_PORT_http}",
          "-server.grpc-listen-address=${NOMAD_IP_grpc}",
          "-server.grpc-listen-port=${NOMAD_PORT_grpc}",
          "-ingester.lifecycler.addr=${NOMAD_IP_http}",
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
