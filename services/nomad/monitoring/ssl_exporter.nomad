job "ssl-exporter" {
  datacenters = ["VOID"]
  namespace = "monitoring"
  type = "service"

  group "app" {
    count = 1

    network {
      mode = "bridge"
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
        image = "ribbybibby/ssl-exporter:2.4.0"
        ports = ["http"]
        args = ["--config.file=/local/conf.yaml"]
      }

      template {
        data = <<EOF
modules:
  https:
    prober: https
  https_insecure:
    prober: https
    tls_config:
      insecure_skip_verify: true
  tcp:
    prober: tcp
  tcp_insecure:
    prober: tcp
    tls_config:
      insecure_skip_verify: true
EOF
        destination = "local/conf.yaml"
      }
    }
  }
}
