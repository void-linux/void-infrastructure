job "buildsync-dist" {
  type = "batch"
  datacenters = ["VOID"]
  namespace = "build"

  periodic {
    cron             = "*/2 * * * * *"
    prohibit_overlap = true
  }

  group "rsync" {
    network { mode = "bridge" }

    volume "dist-pkgs" {
      type = "host"
      source = "dist_pkgs"
      read_only = false
    }

    task "rsync" {
      leader = true
      driver = "docker"

      vault {
        policies = ["void-secrets-buildsync"]
      }

      config {
        image = "eeacms/rsync"
        args = [
          "rsync", "-vurk",
          "--delete-after",
          "-e", "ssh -i /secrets/id_rsa -o UserKnownHostsFile=/local/known_hosts",
          "void-buildsync@b-hel-fi.node.consul:/mnt/data/pkgs/", "/pkgs/"
        ]
      }

      resources {
        memory = 1000
      }

      volume_mount {
        volume = "dist-pkgs"
        destination = "/pkgs"
      }

      template {
        data = <<EOF
{{- with secret "secret/buildsync/ssh" -}}
{{.Data.private_key}}
{{- end -}}
EOF
        destination = "secrets/id_rsa"
        perms = "0400"
      }

      template {
        data = <<EOF
b-hel-fi.node.consul ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMU4d2VBQ3GYGdPOFlvjsJupPnnCk+42hLhrGuCrGLgT
EOF
        destination = "local/known_hosts"
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
  - job_name: buildsync-dist
    static_configs:
      - targets:
        - localhost
        labels:
          __path__: /alloc/logs/rsync*
          nomad_namespace: "{{ env "NOMAD_NAMESPACE" }}"
          nomad_job: "buildsync-dist"
          nomad_group: "{{ env "NOMAD_GROUP_NAME" }}"
          nomad_task: "{{ env "NOMAD_TASK_NAME" }}"
EOT
        destination = "local/promtail.yml"
      }
    }
  }
}
