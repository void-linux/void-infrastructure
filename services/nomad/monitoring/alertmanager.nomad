job "alertmanager" {
  datacenters = ["VOID"]
  namespace = "monitoring"
  type = "service"

  group "app" {
    count = 1

    network {
      mode = "bridge"
      port "http" { to = 9093 }
    }

    service {
      name = "alertmanager"
      port = "http"
      meta {
        nginx_enable = "true"
        nginx_names = "alertmanager.s.voidlinux.org alertmanager.voidlinux.org"
      }

      check {
        type = "http"
        address_mode = "host"
        path = "/-/healthy"
        timeout = "30s"
        interval = "15s"
      }
    }

    task "alertmanager" {
      driver = "docker"

      config {
        image = "prom/alertmanager:v0.23.0"
        ports = ["http"]
        args = [
          "--config.file=/local/alertmanager.yml",
          "--web.external-url=https://alertmanager.s.voidlinux.org"
        ]
      }

      resources {
        memory = 100
      }

      template {
        data = <<EOT
global:
route:
  receiver: 'infra-team'
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 4h
  group_by: [instance, alertname]
receivers:
  - name: infra-team
    webhook_configs:
      - url: http://alertrelay-irc.service.consul:21225/xbps
EOT
        destination = "local/alertmanager.yml"
      }
    }
  }
}
