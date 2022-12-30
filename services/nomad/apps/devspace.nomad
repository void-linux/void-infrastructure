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
      mode = "bridge"
      port "http" { to = 8080 }
      port "sftp" {
        static = 2022
        to = 2022
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
        address_mode = "alloc"
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

      vault {
        policies = ["void-secrets-devspace"]
      }

      config {
        image = "ghcr.io/void-linux/infra-sftpgo:20221001RC01"
      }

      env {
        SFTPGO_HTTPD__BINDINGS__0__ADDRESS=""
        SFTPGO_TELEMETRY__BIND_PORT="8081"
        SFTPGO_TELEMETRY__BIND_ADDRESS=""
        SFTPGO_NETAUTH_REQUIREGROUP="devspace-users"
      }

      template {
                data = <<EOF
{{- with secret "secret/devspace/ssh" -}}
{{.Data.ssh_host_rsa_key}}
{{- end -}}
EOF
        destination = "secrets/id_rsa"
      }

      template {
                data = <<EOF
{{- with secret "secret/devspace/ssh" -}}
{{.Data.ssh_host_ed25519_key}}
{{- end -}}
EOF
        destination = "secrets/id_ed25519"
      }

      template {
                data = <<EOF
{{- with secret "secret/devspace/ssh" -}}
{{.Data.ssh_host_ecdsa_key}}
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
        image = "ghcr.io/void-linux/infra-nginx:20220909RC01"
      }
    }
  }
}
