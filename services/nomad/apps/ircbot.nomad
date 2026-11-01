job "ircbot" {
  datacenters = ["VOID"]
  namespace   = "apps"
  type        = "service"

  group "app" {
    count = 1

    network {
      mode = "bridge"
      port "http" {
        to = 3000
      }
    }

    service {
      provider = "nomad"
      name     = "ircbot"
      port     = "http"

      tags = [
        "nginx_enable",
        "nginx_names=ircbot.voidlinux.org",
      ]
    }

    task "ircbot" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/ircbot:v0.1.5"
      }

      env {
        IRC_SERVER  = "irc.libera.chat:6697"
        IRC_CHANNEL = "#xbps"
        IRC_NICK    = "void-robot"
        IRC_SASL    = "true"
      }

      template {
        data        = <<EOT
{{- with nomadVar "nomad/jobs/ircbot" }}
IRC_USER="{{ .username }}"
IRC_PASS="{{ .password }}"
WEBHOOK_SECRET="{{ .webhook }}"
{{- end }}
EOT
        destination = "secret/env"
        env         = true
      }
    }
  }
}
