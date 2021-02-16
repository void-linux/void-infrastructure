job "maddy-certs" {
  type = "batch"
  namespace = "apps-restricted"
  datacenters = ["VOID-MX"]

  periodic {
    cron = "@daily"
  }

  group "lego" {
    network {
      mode = "bridge"
    }

    volume "maddy_data" {
      type = "host"
      read_only = "false"
      source = "maddy_data"
    }

    task "app" {
      driver = "docker"

      vault {
        policies = ["void-secrets-traefik"]
      }

      config {
        image = "goacme/lego:v4.2.0"
        args = [
          "--email", "postmaster@voidlinux.org",
          "--accept-tos",
          "--domains", "f-sfo3-us.m.voidlinux.org",
          "--dns", "digitalocean",
          "--path", "/data",
          "--pem",
          "run"
        ]
      }

      volume_mount {
        volume = "maddy_data"
        destination = "/data"
        read_only = false
      }

      template {
        data=<<EOF
{{- with secret "secret/traefik/do-api" }}
DO_AUTH_TOKEN={{.Data.api_key}}
{{- end }}
EOF
        destination = "secrets/env"
        perms = 400
        env = true
      }
    }
  }
}
