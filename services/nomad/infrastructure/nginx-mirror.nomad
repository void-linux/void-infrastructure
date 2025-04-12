job "nginx" {
  type = "system"
  datacenters = ["VOID-MIRROR"]
  namespace = "mirror"

  group "nginx" {
    network {
      mode = "host"
    }

    dynamic "volume" {
      for_each = [ "mirror", "sources", ]
      labels = [ "dist-${volume.value}" ]

      content {
        type = "host"
        source = "dist_${volume.value}"
        read_only = true
      }
    }

    task "nginx" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/infra-nginx:20221230RC01"
        network_mode = "host"
      }

      dynamic "volume_mount" {
        for_each = [ "mirror", "sources", ]

        content {
          volume = "dist-${volume_mount.value}"
          destination = "/srv/www/${volume_mount.value}"
        }
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
          "10-sources.conf",
          "10-wiki.conf",
          "10-buildbot.conf",
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
