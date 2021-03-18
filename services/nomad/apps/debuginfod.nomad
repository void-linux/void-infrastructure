job "debuginfod" {
  datacenters = ["VOID"]
  namespace = "apps"
  type = "service"

  group "app" {
    count = 1

    volume "binpkgs" {
      type = "host"
      read_only = true
      source = "root-pkgs"
    }

    volume "debuginfod" {
      type = "host"
      read_only = false
      source = "debuginfod-data"
    }

    network {
      mode = "bridge"
      port "http" {
        to = 8002
      }
    }

    service {
      name = "debuginfod"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.debuginfod.tls=true",
      ]

      check {
        type = "http"
        address_mode = "host"
        path = "/metrics"
        timeout = "30s"
        interval = "15s"
      }
    }

    task "debuginfod" {
      driver = "docker"

      volume_mount {
        volume = "binpkgs"
        destination = "/binpkgs"
        read_only = true
      }

      volume_mount {
        volume = "debuginfod"
        destination = "/debuginfod"
        read_only = false
      }

      config {
        image = "voidlinux/debuginfod:20210316RC02"
        ports = ["http"]
        args = [
          "-vvv",
          "-d", "/debuginfod/db.sqlite",
          "-I", ".*-dbg-.*",
          "-X", "^linux.*",
          "-Z", ".xbps",
          "-c", "2",
          "/binpkgs",
        ]
      }

      resources {
        memory = 8000
        cpu = 6000
      }

      restart {
        attempts = 100
        delay = "30s"
      }
    }
    task "promtail" {
      driver = "docker"

      config {
        image = "grafana/promtail:2.1.0"
        args = ["-config.file=/local/promtail.yml"]
      }

      template {
                data = <<EOT
---
server:
  disable: true
clients:
  - url: http://loki.service.consul:3100/loki/api/v1/push
positions:
  filename: /alloc/positions.yaml
scrape_configs:
  - job_name: debuginfod
    static_configs:
      - targets:
        - localhost
        labels:
          __path__: /alloc/logs/debuginfod*
          nomad_namespace: "{{ env "NOMAD_NAMESPACE" }}"
          nomad_job: "debuginfod"
          nomad_group: "{{ env "NOMAD_GROUP_NAME" }}"
          nomad_task: "{{ env "NOMAD_TASK_NAME" }}"
EOT
        destination = "local/promtail.yml"
      }
    }
  }
}
