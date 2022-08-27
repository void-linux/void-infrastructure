job "maddy" {
  datacenters = ["VOID-MX"]
  namespace = "apps-restricted"
  type = "service"

  group "app" {
    count = 1

    volume "maddy_data" {
      type = "host"
      read_only = false
      source = "maddy_data"
    }

    network {
      mode = "bridge"
      port "smtp"        { static = 25 }
      port "imap"        { static = 143 }
      port "submissions" { static = 465 }
      port "submission"  { static = 587 }
      port "imaps"       { static = 993 }
    }

    task "maddy" {
      driver = "docker"

      vault {
        policies = ["void-secrets-maddy"]
      }

      volume_mount {
        volume = "maddy_data"
        destination = "/data"
        read_only = false
      }

      config {
        image = "foxcpp/maddy:0.6.2"
        volumes = [
          "secrets/tls:/data/tls",
          "local/maddy.conf:/data/maddy.conf",
        ]
      }

      env {
        MADDY_DOMAIN = "voidlinux.org"
        MADDY_HOSTNAME = "mx1.voidlinux.org"
      }

      template {
        data = file("maddy.conf")
        destination = "local/maddy.conf"
        perms = 644
      }

      template {
        data =<<EOF
{{- with secret "secret/lego/data/certificates/_.voidlinux.org.crt" -}}
{{.Data.contents}}
{{- end -}}
EOF
        destination = "secrets/tls/fullchain.pem"
        perms = 400
      }

      template {
        data =<<EOF
{{- with secret "secret/lego/data/certificates/_.voidlinux.org.key" -}}
{{.Data.contents}}
{{- end -}}
EOF
        destination = "secrets/tls/privkey.pem"
        perms = 400
      }
    }
  }
}
