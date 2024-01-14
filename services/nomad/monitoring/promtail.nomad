job "promtail" {
  datacenters = [
    "VOID",
  ]
  namespace   = "monitoring"
  type        = "service"
  priority    = 99

  group "promtail" {
    network {
      mode = "bridge"
      port "metrics" { to = 80 }
    }

    volume "dockersocket" {
      type      = "host"
      source    = "dockersocket"
      read_only = true
    }

    service {
      port = "metrics"
      meta {
        nginx_enable = "true"
        nginx_names = "promtail-tmp.voidlinux.org"
      }
    }

    task "promtail" {
      driver = "docker"

      config {
        image = "docker.io/grafana/promtail:2.9.2"
        args = ["-config.file", "/local/config.yaml", "-config.expand-env=true"]
      }

      resources {
        memory = 150
      }

      volume_mount {
        volume      = "dockersocket"
        destination = "/var/run/docker.sock"
        read_only   = true
      }

      env {
        NOMAD_HOST = "${node.unique.name}"
      }

      template {
        data = yamlencode({
          positions = {
            filename = "/tmp/positions.yml"
          }
          clients = [{
            url = "http://loki.service.consul:3100"
            external_labels = {
              host = "${NOMAD_HOST}"
            }
          }]
          scrape_configs = [{
            job_name = "docker"
            docker_sd_configs = [{
              host = "unix:///var/run/docker.sock"
              refresh_interval = "5s"
            }]
            relabel_configs = [
              {
                source_labels = ["__meta_docker_container_label_com_hashicorp_nomad_namespace"]
                target_label = "nomad_namespace"
              },
              {
                source_labels = ["__meta_docker_container_label_com_hashicorp_nomad_job_name"]
                target_label = "nomad_job"
              },
              {
                source_labels = ["__meta_docker_container_label_com_hashicorp_nomad_group_name"]
                target_label = "nomad_group"
              },
              {
                source_labels = ["__meta_docker_container_label_com_hashicorp_nomad_task_name"]
                target_label = "nomad_task"
              },
              {
                source_labels = ["__meta_docker_container_label_com_hashicorp_nomad_alloc_id"]
                target_label = "nomad_alloc"
              },
            ]
          }]
        })
        destination = "local/config.yaml"
      }
    }
  }
}
