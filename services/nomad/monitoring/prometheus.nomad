job "prometheus" {
  datacenters = ["VOID"]
  namespace = "monitoring"
  type = "service"

  group "app" {
    count = 1

    volume "prometheus" {
      type = "host"
      read_only = false
      source = "prometheus"
    }

    network {
      mode = "bridge"
      port "http" {
        to = 9090
        static = 9090
      }
    }

    service {
      name = "prometheus"
      port = "http"
      meta {
        nginx_enable = "true"
        nginx_names = "prometheus.s.voidlinux.org prometheus.voidlinux.org"
      }

      check {
        type = "http"
        address_mode = "host"
        path = "/-/healthy"
        timeout = "30s"
        interval = "15s"
      }
    }

    task "prometheus" {
      driver = "docker"

      volume_mount {
        volume = "prometheus"
        destination = "/prometheus"
        read_only = false
      }

      config {
        image = "prom/prometheus:v2.34.0"
        ports = ["http"]
        args = [
          "--config.file=/local/prometheus.yml",
          "--storage.tsdb.path=/prometheus",
          "--web.console.libraries=/usr/share/prometheus/console_libraries",
          "--web.console.templates=/usr/share/prometheus/consoles"
        ]
      }

      resources {
        cpu = 500
        memory = 400
      }

      template {
        data = file("./prometheus.yml")
        destination = "local/prometheus.yml"
        perms = 644
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }

      template {
        data = file("./alerts/node_exporter.yml")
        destination = "local/alerts/node_exporter_alerts.yml"
        left_delimiter = "@@"
        right_delimiter = "@@"
      }

      template {
        data = file("./alerts/prometheus.yml")
        destination = "local/alerts/prometheus_alerts.yml"
        left_delimiter = "@@"
        right_delimiter = "@@"
      }
    }
  }
}
