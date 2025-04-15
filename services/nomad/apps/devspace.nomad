job "devspace" {
  datacenters = ["VOID-MIRROR"]
  namespace = "apps"
  type = "service"

  group "sftpgo" {
    count = 1

    volume "devspace_data" {
      type = "host"
      read_only = false
      source = "devspace_data"
    }

    volume "netauth_config" {
      type = "host"
      read_only = true
      source = "netauth_config"
    }

    network {
      mode = "host"
      port "http" {}
      port "sftp" {
        static = 2022
      }
    }

    service {
      name = "devspace-sftp"
      port = "http"
      meta {
        nginx_enable = "true"
        nginx_names = "devspace-sftp.voidlinux.org"
      }
      check {
        type = "http"
        port = 8081
        path = "/healthz"
        timeout = "1s"
        interval = "30s"
      }
    }

    task "sftpgo" {
      driver = "docker"

      volume_mount {
        volume = "devspace_data"
        destination = "/data"
        read_only = false
      }

      volume_mount {
        volume = "netauth_config"
        destination = "/etc/netauth"
        read_only = true
      }

      config {
        image = "ghcr.io/void-linux/infra-sftpgo:20241231R1"
        network_mode = "host"
      }

      env {
        SFTPGO_HTTPD__BINDINGS__0__PORT = "${NOMAD_PORT_http}"
        SFTPGO_HTTPD__TEMPLATES_PATH = "/usr/share/sftpgo/templates"
        SFTPGO_HTTPD__STATIC_FILES_PATH = "/usr/share/sftpgo/static"
        SFTPGO_SFTPD__HOST_KEYS = "/secrets/id_rsa,/secrets/id_ecdsa,/secrets/id_ed25519"
        SFTPGO_TELEMETRY__BIND_PORT = "8081"
        SFTPGO_TELEMETRY__BIND_ADDRESS = ""
        SFTPGO_DATA_PROVIDER__DRIVER = "sqlite"
        SFTPGO_DATA_PROVIDER__NAME = "/data/sftpgo.db"
        SFTPGO_DATA_PROVIDER__EXTERNAL_AUTH_HOOK = "/usr/libexec/sftpgo/netauth-hook"
        SFTPGO_COMMAND__COMMANDS__0__PATH = "/usr/libexec/sftpgo/netauth-hook"
        SFTPGO_COMMAND__COMMANDS__0__ENV = "SFTPGO_NETAUTH_REQUIREGROUP=devspace-users,SFTPGO_NETAUTH_HOMEDIR=/data/home"
        SFTPGO_COMMAND__COMMANDS__0__HOOK = "external_auth"
      }

      template {
                data = <<EOF
{{- with nomadVar "nomad/jobs/devspace" -}}
{{ .ssh_host_rsa_key }}
{{- end -}}
EOF
        destination = "secrets/id_rsa"
      }

      template {
                data = <<EOF
{{- with nomadVar "nomad/jobs/devspace" -}}
{{ .ssh_host_ed25519_key }}
{{- end -}}
EOF
        destination = "secrets/id_ed25519"
      }

      template {
                data = <<EOF
{{- with nomadVar "nomad/jobs/devspace" -}}
{{ .ssh_host_ecdsa_key }}
{{- end -}}
EOF
        destination = "secrets/id_ecdsa"
      }
    }
  }

  group "nginx" {
    count = 1

    volume "devspace_home" {
      type = "host"
      read_only = true
      source = "devspace_home"
    }

    network {
      mode = "bridge"
      port "http" { to = 80 }
    }

    service {
      name = "devspace"
      port = "http"
      meta {
        nginx_enable = "true"
        nginx_names = "devspace.voidlinux.org"
      }
    }

    task "nginx" {
      driver = "docker"

      volume_mount {
        volume = "devspace_home"
        destination = "/srv/www"
      }

      config {
        image = "ghcr.io/void-linux/infra-nginx:20230812"
      }

      template {
        data = <<EOF
server {
    server_name devspace;
    listen 0.0.0.0:80 default_server;

    root /srv/www;

    location / {
        autoindex on;
    }
}
EOF
        destination = "local/nginx/devspace.conf"
      }
    }
  }
}
