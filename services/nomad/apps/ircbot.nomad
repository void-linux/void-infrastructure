job "ircbot" {
  datacenters = ["VOID"]
  namespace = "apps"
  type = "service"

  group "app" {
    count = 1

    network {
      mode = "bridge"
      port "http" {
        to = 3000
      }
    }

    service {
      name = "ircbot"
      port = "http"
      meta {
        nginx_enable = "true"
        nginx_names = "ircbot.s.voidlinux.org"
      }
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.ircbot.tls=true"
      ]
    }

    task "ircbot" {
      driver = "docker"

      vault {
        policies = ["void-secrets-ircbot"]
      }

      config {
        image = "ghcr.io/void-linux/ircbot:v0.1.5"
      }

      env {
        IRC_SERVER="irc.libera.chat:6697"
        IRC_CHANNEL="#xbps"
        IRC_NICK="void-robot"
        IRC_SASL="true"
      }

      template {
        data = <<EOT
{{- with secret "secret/ircbot/credentials" }}
IRC_USER="{{.Data.user}}"
IRC_PASS="{{.Data.pass}}"
{{- end }}
{{- with secret "secret/ircbot/webhook" }}
WEBHOOK_SECRET="{{.Data.gh}}"
{{- end }}
EOT
        destination = "secret/env"
        env = true
      }
    }
  }
}
