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
        image = "ghcr.io/the-maldridge/terrastate:v1.2.1"
        init = true
      }

      env {
        TS_AUTH = "htpasswd:netauth"
        TS_BITCASK_PATH = "/data"
        TS_HTGROUP_FILE = "/secrets/.htgroup"
        TS_HTPASSWD_FILE = "/secrets/.htpasswd"
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
