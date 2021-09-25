job "lego" {
  datacenters = ["VOID"]
  namespace = "infrastructure"
  type = "batch"

  periodic {
    cron = "@weekly"
  }

  group "lego" {
    network { mode = "bridge" }

    task "app" {
      driver = "docker"

      vault {
        policies = ["void-secrets-lego"]
      }

      config {
        image = "ghcr.io/void-linux/infra-lego:v20210923RC04"
      }

      env {
        VAULT_ADDR="http://active.vault.service.consul:8200"
        ACTION="renew"
        DO_PROPAGATION_TIMEOUT="10m"
      }

      template {
        data = <<EOF
{{- with secret "secret/lego/do_api" }}
DO_AUTH_TOKEN={{.Data.api_token}}
{{- end }}
EOF
        destination = "secrets/env"
        env = true
      }
    }
  }
}
