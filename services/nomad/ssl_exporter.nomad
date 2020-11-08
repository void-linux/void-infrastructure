job "ssl-exporter" {
  datacenters = ["VOID"]
  type = "service"

  group "app" {
    count = 1

    network {
      port "http" {
        to = 9219
        static = 9219
      }
    }

    service {
      name = "ssl-exporter"
      port = "http"

      check {
        type = "http"
        address_mode = "host"
        path = "/"
        timeout = "30s"
        interval = "15s"
      }
    }

    task "ssl-exporter" {
      driver = "docker"

      config {
        image = "ribbybibby/ssl-exporter:v2.1.1"
        ports = ["http"]
      }
    }
  }
}
