job "alertmanager" {
  datacenters = ["VOID"]
  namespace   = "monitoring"
  type        = "service"

  group "app" {
    count = 1

    network {
      mode = "bridge"
      port "http" { to = 9093 }
    }

    service {
      provider = "nomad"
      name     = "alertmanager"
      port     = "http"

      tags = [
        "nginx_enable",
        "nginx_names=alertmanager.s.voidlinux.org alertmanager.voidlinux.org",
        "prometheus_enable",
      ]

      check {
        type         = "http"
        address_mode = "host"
        path         = "/-/healthy"
        timeout      = "30s"
        interval     = "15s"
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
        data        = <<EOT
{{- $allocID := env "NOMAD_ALLOC_ID" -}}
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
{{ range nomadService 1 $allocID "alertrelay-irc" }}
      - url: http://{{ .Address }}:{{ .Port }}/xbps
{{ end }}
EOT
        destination = "local/alertmanager.yml"
      }
    }
  }
}
