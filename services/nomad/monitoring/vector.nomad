job "vector" {
  datacenters = [
    "VOID",
    "VOID-MX",
    "VOID-PROXY",
    "VOID-MIRROR",
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
      name         = "vector"
      port         = "8088"
      address_mode = "alloc"
    }

    task "vector" {
      driver = "docker"

      config {
        image = "timberio/vector:0.20.0-debian"
        args  = ["-c", "/local/vector.yaml"]
        ports = ["metrics"]
      }

      resources {
        memory = 150
      }

      volume_mount {
        volume      = "dockersocket"
        destination = "/var/run/docker.sock"
        read_only   = true
      }

      template {
                data = <<EOF
---
sources:
  docker:
    type: docker_logs
    exclude_containers:
      - "vector-"
      - "loki-"
sinks:
  loki:
    type: loki
    inputs:
      - docker
    endpoint: http://loki.service.consul:3100
    encoding:
      codec: text
    healthcheck:
      enabled: false
    out_of_order_action: drop
    labels:
      nomad_namespace: "{{ label.com\\.hashicorp\\.nomad\\.namespace }}"
      nomad_job: "{{ label.com\\.hashicorp\\.nomad\\.job_name }}"
      nomad_group: "{{ label.com\\.hashicorp\\.nomad\\.task_group_name }}"
      nomad_task: "{{ label.com\\.hashicorp\\.nomad\\.task_name }}"
      nomad_node: "{{ label.com\\.hashicorp\\.nomad\\.node_name }}"
      nomad_alloc: "{{ label.com\\.hashicorp\\.nomad\\.alloc_id }}"
EOF
        left_delimiter  = "///1"
        right_delimiter = "///2"

        destination = "local/vector.yaml"
      }

    }
  }
}
