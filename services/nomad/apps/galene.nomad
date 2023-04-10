job "galene" {
  datacenters = ["VOID-CONF"]
  namespace = "apps-restricted"
  type = "service"

  group "app" {
    count = 1

    network {
      mode = "host"
    }

    task "app" {
      driver = "docker"

      vault {
        policies = ["void-secrets-traefik"]
      }

      config {
        image = "maldridge/galene:v0.6.2"
        network_mode = "host"
        args = ["-http", ":443"]

        ulimit {
          nofile = "65536:65536"
        }
      }

      template {
        data = jsonencode({
          op = [{}]
          other = [{}]
          autolock = true
          displayName = "Live Developer Support"
          description = "PR Review Taking Too Long?  Join and get real-time feedback!"
        })
        destination = "secrets/groups/devassist.json"
      }

      template {
        data =<<EOF
{{- with secret "secret/lego/data/certificates/_.voidlinux.org.crt" -}}
{{.Data.contents}}
{{- end -}}
EOF
        destination = "secrets/data/cert.pem"
        perms = 400
      }

      template {
        data =<<EOF
{{- with secret "secret/lego/data/certificates/_.voidlinux.org.key" -}}
{{.Data.contents}}
{{- end -}}
EOF
        destination = "secrets/data/key.pem"
        perms = 400
      }
    }
  }
}
