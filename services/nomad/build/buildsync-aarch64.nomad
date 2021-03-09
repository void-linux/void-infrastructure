job "buildsync-aarch64" {
  type = "service"
  datacenters = ["VOID"]
  namespace = "build"

  group "rsync" {
    network { mode = "bridge" }

    volume "root-pkgs" {
      type = "host"
      source = "root-pkgs"
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
        args = ["client"]
      }

      env {
        CRON_TASK_1="*/5 * * * * flock -n /run/rsync.lock rsync -vurk -e 'ssh -i /secrets/id_rsa -o UserKnownHostsFile=/local/known_hosts' --exclude '*.sig' --delete-after -f '+ */' -f '+ aarch64*-repodata' -f '+ *.aarch64*.xbps' -f '+ *.noarch*.xbps' -f '- *' xbps-master@c-lej-de.node.consul:/hostdir/binpkgs/ /pkgs/aarch64"
      }

      volume_mount {
        volume = "root-pkgs"
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
c-lej-de.node.consul ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHS8zm2q6zhddkYBeoiBH1vXTkPqT3M3UeutauT/G4Ms
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
  - job_name: buildsync-aarch64
    static_configs:
      - targets:
        - localhost
        labels:
          __path__: /alloc/logs/rsync*
          nomad_namespace: "{{ env "NOMAD_NAMESPACE" }}"
          nomad_job: "buildsync-aarch64"
          nomad_group: "{{ env "NOMAD_GROUP_NAME" }}"
          nomad_task: "{{ env "NOMAD_TASK_NAME" }}"
EOT
        destination = "local/promtail.yml"
      }
    }
  }
}
