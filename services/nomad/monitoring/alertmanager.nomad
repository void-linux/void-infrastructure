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
      tags = ["traefik.enable=true", "traefik.http.routers.alertmanager.tls=true"]

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
        image = "quay.io/prometheus/alertmanager:v0.21.0"
        ports = ["http"]
        args = [
          "--config.file=/local/alertmanager.yml",
          "--web.external-url=https://alertmanager.s.voidlinux.org"
        ]
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
