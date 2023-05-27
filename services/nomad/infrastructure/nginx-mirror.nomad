job "nginx" {
  type = "system"
  datacenters = ["VOID-MIRROR"]
  namespace = "mirror"

  group "nginx" {
    network {
      mode = "host"
    }

    volume "dist-mirror" {
      type = "host"
      source = "dist_mirror"
      read_only = true
    }

    task "nginx" {
      driver = "docker"

      vault {
        policies = ["void-secrets-tls"]
      }

      config {
        image = "ghcr.io/void-linux/infra-nginx:20221230RC01"
        network_mode = "host"
      }

      volume_mount {
        volume = "dist-mirror"
        destination = "/srv/www"
      }

      dynamic "template" {
        for_each = [
          "voidlinux.org.crt",
          "voidlinux.org.key",
        ]

        content {
          data = file("nginx-sites/${template.value}")
          destination = "secrets/certs/${template.value}"
          perms = 400
          change_mode = "signal"
        }
      }

      dynamic "template" {
        for_each = [
          "00-default.conf",
          "05-hashi.conf",
          "10-ssl-redirect.conf",
          "10-mirror.conf",
          "10-proxy.conf",
        ]

        content {
          data = file("nginx-sites/${template.value}")
          destination = "local/nginx/${template.value}"
          perms = 400
          change_mode = "signal"
        }
      }
    }
  }
}
