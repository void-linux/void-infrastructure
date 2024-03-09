job "popcorn-report" {
  datacenters = ["VOID"]
  namespace = "apps"
  type = "batch"

  periodic {
    crons = ["@daily"]
    prohibit_overlap = true
  }

  group "report" {
    count = 1

    volume "popcorn_data" {
      type = "host"
      source = "popcorn_data"
      read_only = false
    }

    task "report" {
      driver = "docker"

      vault {
        policies = ["void-secrets-popcorn"]
      }

      config {
        image = "ghcr.io/void-linux/infra-popcorn:TODO"
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
{{ $allocID := env "NOMAD_ALLOC_ID" -}}
#!/bin/sh
{{- range nomadService 1 $allocID "popcorn-statrepo" -}}
exec popcornctl --server "{{ .Address }}" --port "{{ .Port }}" \
    report --reset --key "${POPCORN_KEY}" --file "${OUTDIR}/popcorn_$(date +%F).json"
{{- end -}}
EOF
        destination = "local/popcorn-report"
        perms = "755"
      }

      template {
        data = <<EOF
{{- with secret "secret/popcorn/reset_key" -}}
POPCORN_KEY={{.Data.reset_key}}
{{- end -}}
EOF
        destination = "secrets/env"
        env = true
      }
    }
  }
}
