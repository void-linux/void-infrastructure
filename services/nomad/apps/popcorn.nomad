job "popcorn" {
  datacenters = ["VOID-MIRROR"]
  namespace = "apps"
  type = "service"

  group "webserver" {
    count = 1

    network {
      mode = "bridge"
      port "http" { to = 80 }
    }

    volume "popcorn_data" {
      type = "host"
      source = "popcorn_data"
      read_only = true
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
        image = "ghcr.io/void-linux/infra-nginx:20250719R1"
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

      volume_mount {
        volume = "popcorn_data"
        destination = "/srv/www"
        read_only = true
      }
    }
  }

  group "popcorn" {
    count = 1

    network {
      mode = "host"
      port "statrepo" { static = 8001 }
      port "pqueryd" { static = 8003 }
    }

    service {
      name = "popcorn-statrepo"
      port = "statrepo"
    }

    service {
      name = "popcorn-pqueryd"
      port = "pqueryd"
    }

    volume "popcorn_data" {
      type = "host"
      source = "popcorn_data"
      read_only = false
    }

    task "statrepo" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infra-popcorn:20240704R1"
        command = "statrepo"
        args = [
          "--addr", "0.0.0.0",
          "--port", 8001,
          "--reset_key", "${POPCORN_KEY}",
        ]
        network_mode = "host"
      }

      template {
        data = <<EOF
{{- with nomadVar "nomad/jobs/popcorn" -}}
POPCORN_KEY={{.reset_key}}
{{- end -}}
EOF
        destination = "secrets/env"
        env = true
      }

      volume_mount {
        volume = "popcorn_data"
        destination = "/var/lib/popcorn"
      }
    }

    task "pqueryd" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infra-popcorn:20240704R1"
        command = "pqueryd"
        args = [
          "--checkpoint_enabled=false",
          "--addr", "0.0.0.0",
          "--port", 8003,
          "--data_dir", "/data",
        ]
        network_mode = "host"
      }

      resources {
        memory = 8000
      }

      volume_mount {
        volume = "popcorn_data"
        destination = "/data"
        read_only = true
      }
    }
  }
}
