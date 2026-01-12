job "terrastate" {
  type = "service"
  datacenters = ["VOID"]
  namespace = "infrastructure"

  group "terrastate" {
    count = 1

    network {
      mode = "bridge"
      port "http" {
        to = 8080
      }
    }

    volume "terrastate_data" {
      type = "host"
      read_only = false
      source = "terrastate"
    }

    volume "netauth_config" {
      type = "host"
      read_only = true
      source = "netauth_config"
    }

    service {
      name = "terrastate"
      port = "http"
      meta {
        nginx_enable = "true"
        nginx_names = "terrastate.s.voidlinux.org"
      }

      check {
        type = "http"
        address_mode = "host"
        path = "/healthz"
        timeout = "30s"
        interval = "15s"
      }
    }

    task "app" {
      driver = "docker"

      config {
        image = "ghcr.io/the-maldridge/terrastate:v1.2.4"
        init = true
      }

      env {
        AUTHWARE_BASIC_MECHS = "htpasswd:netauth"
        AUTHWARE_HTPASSWD_FILE = "/secrets/.htpasswd"
        AUTHWARE_HTGROUP_FILE = "/secrets/.htgroup"
        TS_BITCASK_PATH = "/data"
        TS_STORE = "bitcask"
      }

      volume_mount {
        volume = "terrastate_data"
        destination = "/data"
        read_only = false
      }
      volume_mount {
        volume = "netauth_config"
        destination = "/etc/netauth"
        read_only = true
      }

      template {
        data = <<EOF
_terraform:{{ with nomadVar "nomad/jobs/terrastate" }}{{ .hashed_passwd }}{{ end }}
EOF
        destination = "${NOMAD_SECRETS_DIR}/.htpasswd"
        change_mode = "signal"
      }

      template {
        data = <<EOF
terrastate-tls: _terraform
EOF
        destination = "${NOMAD_SECRETS_DIR}/.htgroup"
      }
    }
  }
}
