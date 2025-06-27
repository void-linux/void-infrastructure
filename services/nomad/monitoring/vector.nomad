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
      port = "metrics"
      meta {
        nginx_enable = "true"
        nginx_names = "vector-tmp.voidlinux.org"
      }
    }

    task "vector" {
      driver = "docker"

      config {
        image = "timberio/vector:0.45.0-alpine"
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
            vlogs = {
              type        = "elasticsearch"
              inputs      = ["docker"]
              endpoints   = ["http://vmlogs.service.consul:9428/insert/elasticsearch/"]
              api_version = "v8"
              compression = "gzip"
              healthcheck = { enabled = false }
              query = {
                "_time_field" = "timestamp"
                "_stream_fields" = join(",", formatlist("label.com.hashicorp.nomad.%s", [
                  "namespace", "job_name", "task_group_name", "task_name", "alloc_id",
                ]))
                "_msg_field" = "message"
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
