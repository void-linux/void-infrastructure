job "vector" {
  datacenters = [
    "VOID",
    "VOID-MX",
    "VOID-MIRROR",
    "VOID-CONTROL",
  ]
  namespace = "monitoring"
  type      = "system"
  priority  = 99

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
      provider = "nomad"
      port     = "metrics"

      tags = [
        "nginx_enable",
        "nginx_names=vector-tmp.voidlinux.org",
      ]
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
        data        = <<EOF
sources:
  docker:
    type: docker_logs
    exclude_containers:
      - "vector-"
      - "loki-"
      - "nomad_init_"
sinks:
  vlogs:
    type: elasticsearch
    inputs:
      - docker
    endpoints:
{{ range nomadService "vmlogs" }}
      - "{{ .Address }}:{{ .Port }}"
{{ end }}
    api_version: v8
    compression: gzip
    healthcheck:
      enabled: false
    query:
      _time_field: timestamp
      _stream_fields:
        - label.com.hashicorp.nomad.namespace
        - label.com.hashicorp.nomad.job_name
        - label.com.hashicorp.nomad.task_group_name
        - label.com.hashicorp.nomad.task_name
        - label.com.hashicorp.nomad.alloc_id
      _msg_field: message
EOF
        destination = "local/vector.yaml"
      }
    }
  }
}
