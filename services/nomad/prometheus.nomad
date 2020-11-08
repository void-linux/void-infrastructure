job "prometheus" {
  datacenters = ["VOID"]
  type = "service"

  group "app" {
    count = 1

    volume "prometheus" {
      type = "host"
      read_only = false
      source = "prometheus"
    }

    network {
      port "http" {
        to = 9090
        static = 9090
      }
    }

    service {
      name = "prometheus"
      port = "http"
      tags = ["traefik.enable=true", "traefik.http.routers.prometheus.tls=true"]

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
        image = "prom/prometheus:v2.22.0"
        ports = ["http"]
        args = [
          "--config.file=/local/prometheus.yml",
          "--storage.tsdb.path=/prometheus",
          "--web.console.libraries=/usr/share/prometheus/console_libraries",
          "--web.console.templates=/usr/share/prometheus/consoles"
        ]
      }

      template {
        data = <<EOT
global:
  scrape_interval: 30s
  evaluation_interval: 30s
rule_files:
  - /local/alerts/*.yml
scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets:
        - localhost:9090
  - job_name: traefik
    static_configs:
      - targets:
        - e-sfo3-us.node.consul:8080
  - job_name: node
    consul_sd_configs:
      - server: 172.17.0.1:8500
        datacenter: void
        services: ['node-exporter']
  - job_name: 'ssl'
    metrics_path: /probe
    scrape_interval: 2m
    params:
      module: ["https"]
    static_configs:
      - targets:
          - a-hel-fi.m.voidlinux.org
          - alpha.de.repo.voidlinux.org
          - alpha.us.repo.voidlinux.org
          - build.voidlinux.org
          - docs.voidlinux.org
          - infradocs.voidlinux.org
          - sources.voidlinux.org
          - terraform.voidlinux.org
          - vm1.a-mci-us.m.voidlinux.org
          - voidlinux.org
          - www.voidlinux.org
          - xq-api.voidlinux.org
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: ssl-exporter.service.consul:9219
EOT
        destination = "local/prometheus.yml"
        perms = 644
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }

      artifact {
        source = "https://raw.githubusercontent.com/void-linux/void-infrastructure/master/services/configs/prometheus/alerts/prometheus.yml"
        destination = "local/alerts/"
      }
    }
  }
}
