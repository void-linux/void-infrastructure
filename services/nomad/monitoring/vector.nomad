job "vector" {
  datacenters = [
    "VOID",
    "VOID-MX",
    "VOID-MIRROR",
    "VOID-CONTROL",
  ]
  namespace   = "monitoring"
  type        = "system"
  priority    = 99

  group "vector" {
    network {
      mode = "bridge"
      port "metrics" { to = 8088 }
    }

    volume "dockersocket" {
      type      = "host"
      source    = "dockersocket"
      read_only = true
    }

    service {
      # provider = "nomad"
      port = "metrics"
      meta {
        nginx_enable = "true"
        nginx_names = "vector-tmp.voidlinux.org"
      }
    }

    task "vector" {
      driver = "docker"

      config {
        image = "timberio/vector:0.35.0-alpine"
        args  = ["-c", "/local/vector.yaml"]
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
          sources = {
            docker = {
              type = "docker_logs"
              exclude_containers = [
                "vector-",
                "loki-",
                "nomad_init_",
              ]
            }
          }
          sinks = {
            loki = {
              type = "loki"
              inputs = ["docker"]
              endpoint = "http://loki.service.consul:3100"
              encoding = { codec = "text" }
              healthcheck = { enabled = false }
              out_of_order_action = "drop"
              labels = {
                nomad_node = "$NOMAD_HOST"
                nomad_namespace = "{{ label.\"com.hashicorp.nomad.namespace\" }}"
                nomad_job = "{{ label.\"com.hashicorp.nomad.job_name\" }}"
                nomad_group = "{{ label.\"com.hashicorp.nomad.task_group_name\" }}"
                nomad_task = "{{ label.\"com.hashicorp.nomad.task_name\" }}"
                nomad_alloc = "{{ label.\"com.hashicorp.nomad.alloc_id\" }}"
              }
            }
          }
        })
        destination = "local/vector.yaml"
        left_delimiter = "[["
        right_delimiter = "]]"
      }
    }
  }
}
