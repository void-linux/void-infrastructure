job "popcorn" {
  datacenters = ["VOID"]
  namespace = "apps"
  type = "service"

  group "statrepo" {
    count = 1

    network {
      mode = "host"
      port "statrepo" { static = 8001 }
    }

    service {
      name = "popcorn-statrepo"
      port = "statrepo"
    }

    task "statrepo" {
      driver = "docker"

      vault {
        policies = ["void-secrets-popcorn"]
      }

      config {
        image = "ghcr.io/void-linux/infra-popcorn:TODO"
        command = "statrepo"
        args = [
          "--port", "${NOMAD_PORT_statrepo}",
          "--reset_key", "${POPCORN_KEY}",
        ]
        ports = ["statrepo"]
      }

      template {
                data = <<EOF
{{- with secret "secret/popcorn/reset_key" -}}
POPCORN_KEY={{.Data.reset_key}}
{{- end -}}
EOF
        destination = "secrets/env"
        env = true
      }
    }
  }

  group "pqueryd" {
    count = 1

    volume "popcorn_data" {
      type = "host"
      source = "popcorn_data"
      read_only = true
    }

    network {
      mode = "host"
      port "pqueryd" { static = 8003 }
    }

    service {
      name = "popcorn-pqueryd"
      port = "pqueryd"
    }

    task "pqueryd" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infra-popcorn:TODO"
        command = "pqueryd"
        args = [
          "--checkpoint_enabled=false",
          "--port", "${NOMAD_PORT_pqueryd}",
          "--data_dir", "/data",
        ]
      }

      volume_mount {
        volume = "popcorn_data"
        destination = "/data"
      }
    }
  }

  group "nginx" {
    count = 1

    volume "popcorn_data" {
      type = "host"
      source = "popcorn_data"
      read_only = true
    }

    network {
      mode = "bridge"
      port "http" { to = 80 }
    }

    service {
      name = "popcorn"
      port = "http"
      meta {
        nginx_enable = "true"
        nginx_names = "popcorn.voidlinux.org"
      }
    }

    task "nginx" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infra-nginx:20230812"
      }

      volume_mount {
        volume = "popcorn_data"
        destination = "/srv/www"
      }

      template {
        data = <<EOF
server {
    server_name popcorn;
    listen 0.0.0.0:80 default_server;

    root /srv/www;

    location / {
        autoindex on;
    }
}
EOF
        destination = "local/nginx/popcorn.conf"
      }
    }
  }
}
