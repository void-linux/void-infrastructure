job "popcorn-report" {
  datacenters = ["VOID-MIRROR"]
  namespace = "apps"
  type = "batch"

  periodic {
    crons = ["@daily"]
    prohibit_overlap = true
  }

  group "report" {
    count = 1

    network { mode = "bridge" }

    volume "popcorn_data" {
      type = "host"
      source = "popcorn_data"
      read_only = false
    }

    task "report" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infra-popcorn:20240704R1"
        command = "/local/popcorn-report"
      }

      volume_mount {
        volume = "popcorn_data"
        destination = "/data"
      }

      env {
        OUTDIR = "/data"
      }

      template {
        data = <<EOF
#!/bin/sh
{{ range service "popcorn-statrepo" }}
exec popcornctl --server "{{ .Address }}" --port "{{ .Port }}" \
    report --reset --key "${POPCORN_KEY}" --file "${OUTDIR}/popcorn_$(date +%F).json"
{{ end }}
EOF
        destination = "local/popcorn-report"
        perms = "755"
      }

      template {
        data = <<EOF
{{- with nomadVar "nomad/jobs/popcorn" -}}
POPCORN_KEY={{.reset_key}}
{{- end -}}
EOF
        destination = "secrets/env"
        env = true
      }
    }
  }
}
