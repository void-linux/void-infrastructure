job "alertrelay" {
  type = "service"
  namespace = "monitoring"
  datacenters = ["VOID"]

  group "app" {
    network {
      mode = "bridge"
      port "http" { static = 21225 }
    }

    service {
      name = "alertrelay-irc"
      port = "http"
    }

    task "app" {
      driver = "docker"

      config {
        image = "maldridge/alertmanager-irc-relay:v0.4.1"
        args = ["--config=/local/config.yml"]
      }

      resources {
        memory = 100
      }

      template {
        data = <<EOT
---
http_host: 0.0.0.0
http_port: 21225

irc_host: irc.libera.chat
irc_port: 6697

irc_nickname: void-fleet
irc_nickname_password: $NICKSERV_PASSWORD

irc_channels:
  - name: "#xbps"
EOT
        destination = "local/config.yml"
      }

      template {
        data = <<EOT
NICKSERV_PASSWORD={{ with nomadVar "nomad/jobs/alertrelay" }}{{ .password }}{{end}}
EOT
        destination = "secrets/env"
        env = true
      }
    }
  }
}
